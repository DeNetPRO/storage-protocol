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

contract Selection is Ownable {
    using SafeMath for uint;

    mapping (address => uint256) public timeVote; // date of last vote

    uint256 public votesCount;
    uint256 public votesAmount;

    uint256 public lastVotePeriod; // last vote time 
    uint256 public minVote;
    uint256 public maxVote;
    uint256 public votePeriod; // when update 
    uint256 public currentState; // current result (between min and max)

    string public contractName;

    constructor (uint _minVote, uint _maxVote, string memory _name, uint _period) {
        minVote = _minVote;
        maxVote = _maxVote;
        contractName = _name;
        votePeriod = _period;
        currentState = (minVote  + maxVote) / 2;
    }

    function getCurPeriod() public view returns(uint) {
        return block.timestamp / votePeriod;
    }
    
    function getCurrentState() public view returns (uint256){
        uint nowPeriod = getCurPeriod();
        if (nowPeriod == lastVotePeriod) {
            return currentState;
        } else {
            if (votesCount != 0) {
                return (currentState + votesAmount) / (votesCount + 1);
            } else {
                return (currentState + maxVote + minVote) / 3;
            }
        }
    }

    function _updateVotes() internal {
        if (votesCount == 0) {
            currentState = (currentState + maxVote + minVote) / 3;
        } else {
            currentState = (currentState + votesAmount) / (votesCount + 1);
        }
        votesCount = 0;
        votesAmount = 0;
    }

    function voteFor(address account, uint vote, uint votePower) public onlyOwner {
        require(vote >= minVote, "vote < minVote");
        require(vote <= maxVote, "vote < minVote");
        require(votePower > 0, "votePower < 0");
        uint nowPeriod = getCurPeriod();
        if (nowPeriod != lastVotePeriod) {
            _updateVotes();
            lastVotePeriod = nowPeriod;
        }
        uint accountPeriod = timeVote[account];
        if (accountPeriod != nowPeriod) {
            votesAmount += vote * votePower;
            votesCount += votePower; 
        }
    }
}

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