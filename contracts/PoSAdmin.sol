// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    Contract is modifier only
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPoSAdmin.sol";

contract PoSAdmin  is IPoSAdmin, Ownable {
    address public proofOfStorageAddress = address(0);
    
    constructor (address _pos) {
        proofOfStorageAddress = _pos;
    }

    modifier onlyPoS() {
        require(msg.sender == proofOfStorageAddress, "Access denied by PoS");
        _;
    }

    function changePoS(address _newAddress) public onlyOwner {
        proofOfStorageAddress = _newAddress;
        emit ChangePoSAddress(_newAddress);
    }
}