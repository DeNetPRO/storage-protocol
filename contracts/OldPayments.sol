// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IPayments.sol";


contract OldPayments is IPayments, Ownable {
    using SafeMath for uint256;

    string public name;
    address public PoS_Contract_Address;
    uint256 private _tokensCount;
    mapping(address => bool) private _knownTokens;
    mapping(address => mapping(address => uint256)) public balances;

    modifier onlyPoS() {
        require(msg.sender == PoS_Contract_Address, "Access denied");
        _;
    }

    constructor(string memory _name, address _address) {
        name = _name;
        PoS_Contract_Address = _address;
    }

    function getBalance(address _token, address _address) public view override returns (uint256 result) {
        return balances[_token][_address];
    }

    function changePoS(address _new_address) public onlyOwner {
        PoS_Contract_Address = _new_address;
        emit ChangePoSContract(_new_address);
    }

    function localTransferFrom(address _token, address _from, address _to, uint256 _amount) public override onlyPoS {
        require(_amount > 0, "amount iz zero");

        balances[_token][_from] = balances[_token][_from].sub(_amount, "Not enough balance");
        balances[_token][_to] = balances[_token][_to].add(_amount);

        emit LocalTransferFrom(_token, _from, _to, _amount);
    }

    function depositToLocal(address _account, address _token, uint256 _amount) public override onlyPoS {
        require(_amount > 0);
        _registerTokenIfNeeded(_token);

        // TODO: fix for token with transfer fees
        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transferFrom(_account, address(this), _amount);
        uint256 balanceAfter = IERC20(_token).balanceOf(address(this));
        uint256 resultAfter = balanceAfter.sub(balanceBefore);
        require(resultAfter > 0, "Result is zero");
        balances[_token][_account] = balances[_token][_account].add(
            resultAfter
        );
    }

    /**
        TODO:
            - add vesting/unlockable balance
     **/
    function closeDeposit(address _account, address _token) public override onlyPoS {
        uint256 amount = balances[_token][_account];
        balances[_token][_account] = 0;
        IERC20(_token).transfer(_account, amount);
    }

    function _registerTokenIfNeeded(address _token) private {
        if (!_knownTokens[_token]) {
            _tokensCount++;
            _knownTokens[_token] = true;
            emit RegisterToken(_token, _tokensCount - 1);
        }
    }
}
