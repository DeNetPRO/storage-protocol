// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./StorageToken.sol";
import "./PoSAdmin.sol";
import "./interfaces/IPayments.sol";


contract Payments is IPayments, Ownable, StorageToken, PoSAdmin {
    using SafeMath for uint256;

    uint256 private _tokensCount;
    address public oldPaymentAddress;
    uint256 private _autoMigrationTimeEnds = 0;

    // mapping (address =>  uint) public balances;

    constructor(
            address _address, 
            address _oldPaymentsAddress,
            string memory _tokenName,
            string memory _tokenSymbol,
            uint  _endTime
    ) PoSAdmin(_address) StorageToken(_tokenName, _tokenSymbol) {
        oldPaymentAddress = _oldPaymentsAddress;
        _autoMigrationTimeEnds = _endTime;
    }

    function canMigrate(address _user) public view returns (bool) {
        return IPayments(oldPaymentAddress).getBalance(_user, DeNetFileToken) > 0;
    }

    function migrateFromOldPayments(address _user) public {
        IPayments oldPay = IPayments(oldPaymentAddress);
        uint256 oldBalance = oldPay.getBalance(_user, DeNetFileToken);
        oldPay.localTransferFrom(DeNetFileToken,_user, address(this), oldBalance);
        oldPay.closeDeposit(address(this), DeNetFileToken);
        _mint(_user, _getDepositReturns(oldBalance));
        dfileBalance = dfileBalance.add(oldBalance);
    }

    function getBalance(address _token, address _address) public override view returns (uint result) {
        return balanceOf(_address);
    }

    function localTransferFrom(address _token, address _from, address _to, uint _amount)  override public onlyPoS {
        if (block.timestamp <= _autoMigrationTimeEnds) {
            
            if (canMigrate(_from)) {
                migrateFromOldPayments(_from);
            }
            
            if (canMigrate(_to)) {
                migrateFromOldPayments(_to);
            }
        }
        require (_balances[_from]  >= _amount, "Not enough balance");
        require (0  <  _amount, "Amount < 0");
        
        _balances[_from] = _balances[_from].sub(_amount, "Not enough balance");
        _balances[_to] = _balances[_to].add(_amount);
        
        emit LocalTransferFrom(_token, _from, _to, _amount);
    }



    function depositToLocal(address _user_address, address _token, uint _amount)  override public onlyPoS{
        _depositByAddress(_user_address, _amount);
    }


    /**
        TODO:
            - add vesting/unlockable balance
     **/
    function closeDeposit(address _account, address _token) public override onlyPoS {
        _closeAllDeposiByAddresst(_account);
    }
}