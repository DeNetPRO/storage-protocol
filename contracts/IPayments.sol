// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;


interface IPayments {
    event LocalTransferFrom(
        address indexed _token,
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event RegisterToken(address indexed _token, uint8 indexed _id);

    function getBalance(address _token, address _address)
        external
        view
        returns (uint256 result);

    function localTransferFrom(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) external;

    function depositToLocal(
        address _user_address,
        address _token,
        uint256 _amount
    ) external;

    function closeDeposit(address _user_address, address _token) external;
}
