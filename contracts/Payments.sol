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

import "./StorageToken.sol";
import "./PoSAdmin.sol";
import "./interfaces/IPayments.sol";


contract Payments is IPayments, Ownable, StorageToken, PoSAdmin {
    using SafeMath for uint256;

    uint256 private _tokensCount;
    // mapping (address =>  uint) public balances;

    constructor(
            address _address, 
            string memory _tokenName,
            string memory _tokenSymbol
    ) PoSAdmin(_address) StorageToken(_tokenName, _tokenSymbol) {}



    function getBalance(address _address) public override view returns (uint result) {
        return balanceOf(_address);
    }

    function localTransferFrom(address _from, address _to, uint _amount)  override public onlyPoS {
        require (_balances[_from]  >= _amount, "Not enough balance");
        require (0  <  _amount, "Amount < 0");
        
        _balances[_from] = _balances[_from].sub(_amount, "Not enough balance");
        _balances[_to] = _balances[_to].add(_amount);
        
        emit LocalTransferFrom(_from, _to, _amount);
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