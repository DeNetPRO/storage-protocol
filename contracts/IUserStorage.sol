// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;


interface IUserStorage {
    function GetUserPayToken(address _user_address)
        external
        view
        returns (address);

    function GetUserLastBlockNumber(address _user_address)
        external
        view
        returns (uint32);

    function GetUserRootHash(address _user_address)
        external
        view
        returns (bytes32, uint256);

    function UpdateRootHash(
        address _user_address,
        bytes32 _user_root_hash,
        uint64 _nonce,
        address _updater
    ) external;

    function UpdateLastBlockNumber(address _user_address, uint32 _block_number)
        external;

    function SetUserPlan(address _user_address, address _token) external;
}
