// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/IUserStorage.sol";


contract UserStorage is IUserStorage, Ownable {
    struct UserData {
        bytes32 user_root_hash;
        uint64 nonce;
        uint32 last_block_number;
        address pay_token;
    }

    string public name;
    address public PoS_Contract_Address;
    mapping(address => UserData) private _users;

    modifier onlyPoS() {
        require(msg.sender == PoS_Contract_Address);
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

    function getUserPayToken(address _user_address) public view override returns (address) {
        return _users[_user_address].pay_token;
    }

    function getUserLastBlockNumber(address _user_address) public view override returns (uint32) {
        if (_users[_user_address].last_block_number == 0) {
            return uint32(block.number - 10000);
        }
        return _users[_user_address].last_block_number;
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
        uint64 _nonce,
        address _updater
    ) public override onlyPoS {
        require(
            _nonce >= _users[_user_address].nonce &&
                _user_root_hash != _users[_user_address].user_root_hash
        );

        _users[_user_address].user_root_hash = _user_root_hash;
        _users[_user_address].nonce = _nonce;

        emit ChangeRootHash(_user_address, _updater, _user_root_hash);
    }

    function updateLastBlockNumber(address _user_address, uint32 _block_number) public override onlyPoS {
        require(_block_number > _users[_user_address].last_block_number);
        _users[_user_address].last_block_number = _block_number;
    }

    function setUserPlan(address _user_address, address _token) public override onlyPoS {
        _users[_user_address].pay_token = _token;
        emit ChangePaymentMethod(_user_address, _token);
    }
}
