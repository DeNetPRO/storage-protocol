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
    uint256 public lockPeriod = 86400; // one day

    constructor (address _token) {
        depositTokenAddresss = _token;
    }

    function updateLockTime(uint256 newPeriod) public onlyOwner {
        lockPeriod = newPeriod;
    }

    function balanceOf(address account) public view returns(uint256) {
    
        if (block.timestamp  < unlockTime[account]) {
            return depositedBalance[account].sub(lockedAmounts[account]);
        }
        return depositedBalance[account];
    }

    function vote(uint256 voteID,  uint256 votePower) public {
        address account = msg.sender;
        require(balanceOf(account) >= votePower, "vote power > unlocked deposit");
        if (block.timestamp < unlockTime[account]) {
            lockedAmounts[account] = lockedAmounts[account].add(votePower);    
        } else {
            lockedAmounts[account] = votePower;
        }
        unlockTime[account] = block.timestamp + lockPeriod;
        votes[voteID] = votes[voteID].add(votePower);
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
        require(balanceOf(msg.sender) >= amount, "Amount > unlocked deposit");
        depositedBalance[msg.sender] = depositedBalance[msg.sender].sub(amount);
        token.transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }
}