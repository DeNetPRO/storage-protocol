// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;


interface IContractStorage {

    function stringToContractName(string calldata nameString) external pure returns(bytes32);

    function getContractAddress(bytes32 contractName, uint networkId) external view returns (address);

    function getContractAddressViaName(string calldata contractString, uint networkId) external view returns (address);

}