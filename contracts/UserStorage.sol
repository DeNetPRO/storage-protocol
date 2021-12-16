// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/IUserStorage.sol";


contract UserStorage is IUserStorage, Ownable {
    struct UserData {        
        uint last_proof_time;
        uint user_storage_size;
        uint nonce;
        bytes32 user_root_hash;
    }

    string public name;
    address public PoS_Contract_Address;
    uint256 public lastProofRange = 10000;
    mapping(address => UserData) private _users;

    modifier onlyPoS() {
        require(msg.sender == PoS_Contract_Address, "Only PoS");
        _;
    }

    constructor(string memory _name, address _address) {
        name = _name;
        PoS_Contract_Address = _address;
    }

    function changePoS(address _new_address) public onlyOwner {
        PoS_Contract_Address = _new_address;
        emit ChangePoSContract(_new_address);
    }

    function getUserRootHash(address _user_address) public view override returns (bytes32, uint256) {
        return (
            _users[_user_address].user_root_hash,
            _users[_user_address].nonce
        );
    }

    function updateRootHash(
        address _user_address,
        bytes32 _user_root_hash,
        uint64 _user_storage_size,
        uint64 _nonce,
        address _updater
    ) public override onlyPoS {
        require(
            _nonce >= _users[_user_address].nonce &&
            _user_root_hash != _users[_user_address].user_root_hash
        );

        _users[_user_address].user_root_hash = _user_root_hash;
        _users[_user_address].nonce = _nonce;
        _users[_user_address].user_storage_size = _user_storage_size;

        emit ChangeRootHash(_user_address, _updater, _user_root_hash);
    }

    /*
        updateLastProofTime

        Function set current timestamp yo lastProofTime in users[userAddress]. it means, that
        userDifficulty = zero (current time - lastProofTime), and will grow  with time.
    */
    function updateLastProofTime(address _user_address) public override onlyPoS {
        _users[_user_address].last_proof_time = block.timestamp;
    }

    /* 
        getPeriodFromLastProof
        function return userDifficulty.
        userDifficulty =  timestamp (curren time - lastProofTime)
    */
    function getPeriodFromLastProof(address _user_address) external override view returns(uint) {
        return block.timestamp - _users[_user_address].last_proof_time;
    }
}
