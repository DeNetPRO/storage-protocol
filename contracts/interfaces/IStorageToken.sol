// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;


interface IStorageToken {

    function getDepositRate(uint256 amount) external view  returns (uint256);
    function balanceOf (address _user) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}