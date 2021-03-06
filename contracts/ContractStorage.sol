// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IContractStorage.sol";

/**
    @dev ContractStorage is storing addresses of main contracts.

    Add & Update contracts via updateVersion()
    Get contract address via getContractAddressViaName()

*/
contract ContractStorage is IContractStorage, Ownable {

    /**
        @dev _contractVector is vector for last version smart contracts
        
        last version = _contractVector[sha256(contractName)].last
    */
    mapping (bytes32=>mapping (uint => address[])) _contractVector;
    mapping (uint => string[]) private  _contractNames;
    uint[] private _knownNetworkIds;

    /**
        @dev Returns address of contract in selected network by keccak name

        @param contractName - keccak name of contract (with encodepacked);
    */
    function getContractAddress(bytes32 contractName, uint networkId) public override view returns (address) { 
        uint versionCount = _contractVector[contractName][networkId].length;
        if (versionCount == 0) {
            return address(0);
        }
        return _contractVector[contractName][networkId][versionCount - 1];
    }

    /**
        @dev Returns address of contract in selected network by string name

        @param contractString - string name of contract
    */
    function getContractAddressViaName(string calldata contractString, uint networkId) public override view returns (address) { 
        return getContractAddress(stringToContractName(contractString), networkId);
    }

    /**
        @dev updateVersion is function to update address of contracts
    */
    function _updateVersion(bytes32 contractName, address newAddress, uint networkId) internal {
        _contractVector[contractName][networkId].push(newAddress);
    }

    /**
        @dev function returns keccak256 of named contract

        @param nameString - name of core contract, examples:
            "proofofstorage" - ProofOfStorage 
            "gastoken" - TB/Year gas token
            "userstorage" - UserStorage Address
            "nodenft" - node nft address

        @return bytes32 - keccak256(nameString)
    */
    function stringToContractName(string calldata nameString) public override pure returns(bytes32) {
        return keccak256(abi.encodePacked(nameString));
    }

    /**
        @dev Compex function to update contracts on all networks

        @param contractNameString - name of core contract, examples:
            "proofofstorage" - ProofOfStorage 
            "gastoken" - TB/Year gas token
            "userstorage" - UserStorage Address
            "nodenft" - node nft address
            "pairtoken" - DFILE Token (as main token). If not available, using USDC or other.
            "userstorage" - User Storage address (Contract where stored data like Nonce and root hash)
        @param newContractAddress - new address of contract
        @param networkId - ID of network, examples:
            1 - Ethereum Mainnet
            3 - Ropsten Testnet
            10 - Optimism
            42 - Kovan Testnet
            56 - Binance Smart Chain
            57 - Syscoin Mainnet
            61 - Ethereum Classic Mainnet
            66 - OKXChain Mainnet
            100 - Gnosis
            128 - Huobi ECO Chain Mainnet
            137 - Polygon Mainne
            250 - Fantom Opera
            1285 - Moonriver
            1313161554 - Aurora Mainnet            
    */
    function updateVersion(string calldata contractNameString, address newContractAddress, uint networkId) public onlyOwner {
        bytes32 _contractName = stringToContractName(contractNameString);
        if (_contractVector[_contractName][networkId].length == 0) {
            if (_contractNames[networkId].length == 0) {
                _knownNetworkIds.push(networkId);
            }
            _contractNames[networkId].push(contractNameString);
        }
        _updateVersion(_contractName, newContractAddress, networkId);
    }

    function getContractListOfNetwork(uint networkId) public view returns (string[] memory) {
        return _contractNames[networkId];
    }

    function getNetworkLists() public view returns (uint[] memory) {
        return _knownNetworkIds;
    }
}