// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    This Contract - ope of step for moving from rating to VDF, before VDF not realized.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IGovernance.sol";

contract Governance is Ownable, IGovernance {
    address public depositTokenAddresss = address(0);

    using SafeMath for uint;

    mapping (address => uint256) public depositedBalance;
    mapping (address => uint256) public lockedAmounts;
    mapping (address => uint256) public unlockTime;
    mapping (uint256 => uint256) public votes;
    uint256 lock_period = 86400; // one day

    constructor (address _token) {
        depositTokenAddresss = _token;
    }

    function updateLockTime(uint256 new_period) public onlyOwner {
        lock_period = new_period;
    }

    function balanceOf(address account) public view returns(uint256) {
    
        if (block.timestamp  < unlockTime[account]) {
            return depositedBalance[account].sub(lockedAmounts[account]);
        }
        return depositedBalance[account];
    }

    function vote(uint256 vote_id,  uint256 vote_power) public {
        address account = msg.sender;
        require(balanceOf(account) >= vote_power, "vote power is more than unlocked deposit");
        if (block.timestamp < unlockTime[account]) {
            lockedAmounts[account] = lockedAmounts[account].add(vote_power);    
        } else {
            lockedAmounts[account] = vote_power;
        }
        unlockTime[account] = block.timestamp + lock_period;
        votes[vote_id] = votes[vote_id].add(vote_power);
    }

    function depositToken(uint256 amount) public {
        /*
            1. token.Approve(address(governance), infinity);
            2. 
        */
        IERC20 token = IERC20(depositTokenAddresss);
        uint256 balanceBefore = token.balanceOf(address(this));
        require(token.transferFrom(msg.sender, address(this), amount), "Can't transfer funds");
        uint256 amountToAdd = token.balanceOf(address(this)).sub(balanceBefore);
        depositedBalance[msg.sender] = depositedBalance[msg.sender].add(amountToAdd);
        emit Deposit(msg.sender, amountToAdd);
    }

    function withdrawToken(uint256 amount) public {
        IERC20 token = IERC20(depositTokenAddresss);
        require(balanceOf(msg.sender) >= amount, "Amount more than unlocked deposit balance");
        token.transfer(msg.sender, amount);
        depositedBalance[msg.sender] = depositedBalance[msg.sender].sub(amount);
        emit Withdraw(msg.sender, amount);
    }
}