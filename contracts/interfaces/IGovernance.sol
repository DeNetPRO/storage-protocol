// SPDX-License-Identifier: MIT
/*
    Created by DeNet
*/
pragma solidity ^0.8.0;

interface IGovernance {
    
    event Deposit(
        address indexed to,
        uint256 indexed amount
    );

    event Withdraw(
        address indexed to,
        uint256 indexed amount
    );
}