// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;


interface IUserStorage {
    event ChangeRootHash(
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

    function getUserPayToken(address _user_address)
        external
        view
        returns (address);

    function getUserLastBlockNumber(address _user_address)
        external
        view
        returns (uint32);

    function getUserRootHash(address _user_address)
        external
        view
        returns (bytes32, uint256);

    function updateRootHash(
        address _user_address,
        bytes32 _user_root_hash,
        uint64 _nonce,
        address _updater
    ) external;

    function updateLastBlockNumber(address _user_address, uint32 _block_number) external;

    function setUserPlan(address _user_address, address _token) external;
}
