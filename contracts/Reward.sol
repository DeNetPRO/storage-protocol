// SPDX-License-Identifier: MIT

/*
    Created by DeNet

    WARNING:
        This token includes fees for transfers, but no fees for ProofOfStorage.
        - Transfers may used only for tests. 
        - Transfers will removed in future versions.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IStorageToken.sol";

contract Reward is Ownable {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint256 value);

    address  public storageTokenAddress;
    uint256 public rewardLimit = 190000000000000000;
    mapping (address =>  uint) public rewarded;
    
    constructor (address _tokAddress) {
        storageTokenAddress = _tokAddress;
    }

    function addReward(address _reciever, uint256 _amount) public onlyOwner{
        require(rewarded[_reciever].add(_amount) < rewardLimit, "Reward limit exceeded");
        IStorageToken _token = IStorageToken(storageTokenAddress);
        rewarded[_reciever] = rewarded[_reciever].add(_amount);
        _token.transfer(_reciever, _amount);
        emit Transfer(address(this), _reciever, _amount);
    }
}
