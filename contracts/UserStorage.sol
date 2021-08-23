pragma solidity ^0.8.0;

import "./safe/owner.sol";

contract UserStorage is Ownable {
    
    string public name;
    address public PoS_Contract_Address;
    
    event ChngeRootHash(
            address indexed user_address,
            address indexed node_address,
            bytes32 new_root_hash
    );
    
    event ChangePoSContract(
        address indexed PoS_Contract_Address
    );
    
    event ChangePaymentMethod(
        address indexed user_address,
        address indexed token
    );
    
    constructor (
        string memory _name,
        address  _address
    ) {
        name = _name;
        PoS_Contract_Address = _address;
    }
    
    modifier onlyPoS() {
        require(msg.sender == PoS_Contract_Address);
        _;
    }
    
    function changePoS(address _new_address) onlyOwner public  {
        PoS_Contract_Address = _new_address;
        emit ChangePoSContract(_new_address);
    }
    
    struct user_data {
        bytes32 user_root_hash;
        uint64 nonce;
        uint32 last_block_number;
        
        address pay_token;
    }
    
    
    
    mapping (address => user_data)  private _users;
    
    function GetUserPayToken(address _user_address) public view returns(address) {
        return _users[_user_address].pay_token;
    }
    
    function GetUserLastBlockNumber(address _user_address) public view returns(uint32) {
         if (_users[_user_address].last_block_number == 0) {
             return uint32(block.number - 10000);
         }
         return _users[_user_address].last_block_number;
    }
    
    function GetUserRootHash(address _user_address) public view returns (bytes32, uint256) {
         return (_users[_user_address].user_root_hash, _users[_user_address].nonce);
        
    }
    
    function UpdateRootHash(address  _user_address, bytes32 _user_root_hash, uint64 _nonce, address _updater) onlyPoS public {
       
        require(_nonce >= _users[_user_address].nonce && _user_root_hash != _users[_user_address].user_root_hash);
        
        _users[_user_address].user_root_hash = _user_root_hash;
        _users[_user_address].nonce = _nonce;
        
        emit ChngeRootHash(_user_address, _updater, _user_root_hash);
    }
    
    function UpdateLastBlockNumber(address  _user_address, uint32 _block_number) onlyPoS public {
        require (_block_number > _users[_user_address].last_block_number);
        _users[_user_address].last_block_number = _block_number;
    }
    
    function SetUserPlan(address _user_address, address _token) onlyPoS public {
        _users[_user_address].pay_token = _token;

        emit ChangePaymentMethod(_user_address, _token);
    }
    
}





