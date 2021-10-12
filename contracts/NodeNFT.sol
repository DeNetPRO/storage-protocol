// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    This Contract - ope of step for moving from rating to VDF, before VDF not realized.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./PoSAdmin.sol";
import "./interfaces/INodeNFT.sol";

contract SimpleNFT is ISimpleINFT {
    using SafeMath for uint256;
  
    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned token
    mapping (address => uint256) private _ownedTokensCount;

    mapping (address => uint256) public nodeByAddress;
    
    // Mapping from owner to token last token id
    function balanceOf(address owner) public override view returns (uint256) {
        require(owner != address(0), "0x0 is blocked");
        return _ownedTokensCount[owner];
    }

    function getNodeIDByAddress(address _node) public override view returns (uint256) {
        return nodeByAddress[_node];
    }
    
    function ownerOf(uint256 tokenId) public override view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "0x0 is blocked");
        return owner;
    }
    
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "0x0 is blocked");
        _addTokenTo(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }
    
    function _burn(address owner, uint256 tokenId) internal {
        _removeTokenFrom(owner, tokenId);
        emit Transfer(owner, address(0), tokenId);
    }
    
    function _removeTokenFrom(address _from, uint256 tokenId) internal {
        require(ownerOf(tokenId) == _from, "token owner is not true");
        _ownedTokensCount[_from] = _ownedTokensCount[_from].sub(1);
        _tokenOwner[tokenId] = address(0);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenID) internal {
        require(_tokenOwner[_tokenID] != address(0), "token owner is 0x0");
        _ownedTokensCount[_from] = _ownedTokensCount[_from].sub(1);
        _ownedTokensCount[_to] = _ownedTokensCount[_from].add(1);
        _tokenOwner[_tokenID] = _to;
        nodeByAddress[_from] = 0;
        nodeByAddress[_to] = _tokenID;
        emit Transfer(_from, _to, _tokenID);

    }
    
    function _addTokenTo(address to, uint256 tokenId) internal {
        require(_tokenOwner[tokenId] == address(0), "token owner is not 0x0");
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
    }
    
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }
}

contract SimpleMetaData is SimpleNFT, IMetaData {

    using SafeMath for uint256;

    // Token name
    string internal _name;
    
    // Token symbol
    string internal _symbol;

    // Rank degradation per update
    uint256 internal _degradation = 10;

    mapping(uint256 => DeNetNode) private _node;

    constructor(string  memory name_, string  memory symbol_)  {
        _name = name_;
        _symbol = symbol_;
    }
    
    function name() external view returns (string memory) {
        return _name;
    }
    
    function symbol() external view returns (string memory) {
        return _symbol;
    }
    
    
    function nodeInfo(uint256 tokenId) public override view returns (DeNetNode memory) {
        require(_exists(tokenId), "node not found");
        return _node[tokenId];
    }
    
    function _setNodeInfo(uint256 tokenId,  uint8[4] calldata ip, uint16 port) internal {
        require(_exists(tokenId), "node not found");
        
        _node[tokenId].ipAddress = ip;
        _node[tokenId].port = port;
        if (_node[tokenId].createdAt == 0) {
            _node[tokenId].createdAt = block.timestamp;
        } else {
            // degradation rank for update node
            bool _err;
            (_err, _node[tokenId].rank) = _node[tokenId].rank.trySub(_degradation);
        }
         
        _node[tokenId].updatedAt = block.timestamp;
        _node[tokenId].updatesCount += 1;

        
        
        emit UpdateNodeStatus(msg.sender, tokenId, ip, port);
    }
    
    function _burnNode(address owner, uint256 tokenId) internal  {
        super._burn(owner, tokenId);
        
        // Clear metadata (if any)
        if (_node[tokenId].createdAt != 0) {
            delete _node[tokenId];
        }
    }

    function _increaseRank(uint256 tokenId) internal {
        _node[tokenId].rank = _node[tokenId].rank + 1;
        _node[tokenId].updatedAt = block.timestamp;
    }
}

contract DeNetNodeNFT is SimpleMetaData, PoSAdmin, IDeNetNodeNFT {
    uint256 public nextNodeID = 1;
    uint256 public maxNodeID = 0;
    uint256 public nodesAvailable = 0;
    uint256 public maxAlivePeriod = 2592000; // ~ 30 days
    
    constructor (string memory _name, string memory _symbol, address _pos, uint256 nodeLimit) SimpleMetaData(_name, _symbol) PoSAdmin(_pos){
        maxNodeID = nodeLimit;
    }
     
    function createNode(uint8[4] calldata ip, uint16 port) public returns (uint256){
        require(maxNodeID > nodesAvailable, "Max node count limit exceeded");       
        // if user have not nodes
        require(nodeByAddress[msg.sender] == 0, "This address already have node");
        _mint(msg.sender, nextNodeID);
        _setNodeInfo(nextNodeID, ip, port);
        nodeByAddress[msg.sender] = nextNodeID;
        nextNodeID += 1;
        nodesAvailable += 1;
        return nextNodeID - 1;
    }
    
    function updateNode(uint256 nodeID, uint8[4] calldata ip, uint16 port) public {
        require(ownerOf(nodeID) == msg.sender, "only nft owner can update node");
        _setNodeInfo(nodeID, ip, port);
    }
    function totalSupply() public override view returns (uint256) {
        return nextNodeID - 1;
    }

    function addSuccessProof(address _nodeOwner) public override onlyPoS {
        require(nodeByAddress[_nodeOwner] != 0, "node does not registered");
        _increaseRank(nodeByAddress[_nodeOwner]);
    }

    function updateNodesLimit(uint256 _newLimit) public onlyOwner {
        maxNodeID = _newLimit;
    }

    function stealNode(uint256 _nodeID, address _to) public {
        require(_exists(_nodeID), "Attacked node not found");
        require(nodeByAddress[_to] == 0, "Reciever already have node");
        DeNetNode memory _tmpNode = nodeInfo(_nodeID);
        require(block.timestamp - _tmpNode.updatedAt > maxAlivePeriod, "Node is alive");
        address _oldOwner = ownerOf(_nodeID);
        _transferFrom(_oldOwner, _to, _nodeID);
        _increaseRank(_nodeID);
    }
}