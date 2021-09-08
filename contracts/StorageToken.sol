// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC20Unsafe.sol";


import "./interfaces/IUserStorage.sol";
import "./interfaces/IPayments.sol";


/*
    @feeCollector - is cotnract created for getting some fees per storage actions.
    
    User Transfer Fee = 7% 
    User Payout Fee = 10%
    Local Transfer's - zeor or less than User Transfer Fee.

    where does the fees go:
        30% of fee goes to Govermance
        20% of fee goes to Dapp Market Fund
        10% of fee goes to Miners Funding 
        10% of fee goes to All storage Token Holders 
        10% of fee goes to Referal rewards 

    fees can be changed via Voting by DFILE Token
*/

contract feeCollector is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint16;
    
    /* 
        Fee in TB tokne works with Minting by Transaction and Payout operations
        
        Fee calcs  by amount * fee / div_fee
    */
    
    uint16 constant public div_fee = 10000;
    uint16 public transfer_fee = 100; // 1% by default always minting, no charging
    uint16 public payout_fee = 100;// 1% by default 
    uint16 public payin_fee = 100; // 1% by default
    uint16 public mint_percent = 5000; // 50% will minted by default if user exchange TB to DFILE,  50% will charded from user.
    uint16 private _mint_daily_limit_of_totalSupply = 100; // 0.1%
    
    
    address public recipient_fee = 0x3D71E8A1A1038623A2dEF831ABDF390897Eb1D77; // for testnet only
    uint256 public fee_limit = 100000000000000000000; // 100 TB 
    uint256 public fee_collected = 0;
    
  
    function _addFee(uint256 amount) internal  {
        require(amount > 0);
        fee_collected = fee_collected.add(amount);
    }
    
    function calc_transfer_fee(uint256 amount) public view returns(uint256) {
        return amount.mul(transfer_fee).div(div_fee);
    }
    
    function calc_payout_fee(uint256 amount) public  view returns(uint256){
        return amount.mul(payout_fee).div(div_fee);
    }
    
    function toFeeless(uint256 amount) public view returns(uint256) {
        return amount.div(div_fee.add(transfer_fee.mul(mint_percent).div(div_fee))).mul(div_fee);
    }
    function toFeelessPayout(uint256 amount) public view returns(uint256) {
        return amount.div(div_fee.add(payout_fee.mul(mint_percent).div(div_fee))).mul(div_fee);
    }
    
    function change_fee_limit(uint new_fee_limit) public onlyOwner {
        fee_limit = new_fee_limit;
    }
    function change_transfer_fee(uint16 new_fee) public onlyOwner {
        require(new_fee <= div_fee, "max fee limit exceeded");
        transfer_fee = new_fee;
    }
    function change_payout_fee(uint16 new_fee) public onlyOwner {
        require(new_fee <= div_fee, "max fee limit exceeded");
        payout_fee = new_fee;
    }
    function change_payin_fee(uint16 new_fee) public onlyOwner {
        require(new_fee <= div_fee, "max fee limit exceeded");
        payin_fee = new_fee;
    }
    function change_recipient_fee(address _new_recipient_fee) public onlyOwner {
        require(_new_recipient_fee != address(0), "wrong address");
        recipient_fee = _new_recipient_fee;
    }
    
}


contract StorageToken is  ERC20, Ownable, feeCollector{
    using SafeMath for uint256;
    using SafeMath for uint16;
    
    uint256 public dfileBalance = 4000000000000000000; // 25 DFILE per TB year start price
    address public DeNetFileToken = 0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848;
    
    constructor (string memory name_, string memory symbol_)  ERC20(name_, symbol_) {
        _mint(recipient_fee, fee_limit); // mint start capital
    }
    
    // only for test
    function changeTokenAddress(address newAddress) public onlyOwner {
        DeNetFileToken = newAddress;
    }
    function _getDepositReturns(uint256 amount) internal view returns (uint256) {
        require(amount > 0, "amount can't require 0 or zero");
         return totalSupply().mul(amount).div(dfileBalance).mul(div_fee.sub(payin_fee)).div(div_fee);
    }
    
    function _getWidthdrawithReturns(uint256 amount) internal view returns (uint256) {
        require(amount > 0, "amount can't require 0 or zero");
        return dfileBalance.mul(amount).div(totalSupply());
    }
    function feelessBalance(address account) public view returns(uint256) {
        return _balances[account];
    }
    
    function getWidthdrawtReturns(uint256 amount) public view returns (uint256) {
        return _getWidthdrawithReturns(toFeelessPayout(amount));
    }
    
    
    /*
        returns amount of returnable Storage Token with Fees.
    */
    function getDepositRate(uint256 amount) public view  returns (uint256){
        return toFeeless(amount);
    }
    
 
    /*
        Function to Deposit DFILE
    */
    function _deposit(uint256 amount) internal {
        _depositByAddress(msg.sender, amount);
    }
    
    function _depositByAddress(address _account, uint256 amount) internal {
        
        IERC20 DFILEToken = IERC20(DeNetFileToken);
        require(DFILEToken.transferFrom(_account, address(this), amount), "Can't transfer from DFILE token");
        _mint(_account, _getDepositReturns(amount));
        dfileBalance = dfileBalance.add(amount);
    }
    
    function  _closeAllDeposit() internal  {
        _closeAllDeposiByAddresst(msg.sender);
    }
    
    function  _closeAllDeposiByAddresst(address account) internal  {
        IERC20 DFILEToken = IERC20(DeNetFileToken);
        uint256 account_balance_TB = feelessBalance(account);
        uint256 dfile_return = _getWidthdrawithReturns(account_balance_TB);
        dfileBalance = dfileBalance.sub(dfile_return);
        _burn(account, account_balance_TB);
        DFILEToken.transfer(account,dfile_return);
    }
    
    function _closePartOfDeposit(uint256 amount) internal {
        _closePartOfDepositByAddress(msg.sender, amount);
    }

    function _closePartOfDepositByAddress(address account, uint256 amount) internal {

        IERC20 DFILEToken = IERC20(DeNetFileToken);
        require(feelessBalance(account) >= amount, "Amount too big");
        uint256 dfile_return = _getWidthdrawithReturns(amount);
        dfileBalance = dfileBalance.sub(dfile_return);
        _burn(account, amount);
        DFILEToken.transfer(account, dfile_return);
        
    }
       
    /*
            Balance OF with fee collector changer 
            
            Balance = amount / (100% + fee percent)
            amount / (div fee  + payout_fee * mint_percent / div fee) * div fee
    */
    function balanceOf(address User) public view override(ERC20) returns (uint256){
        return toFeeless(_balances[User]);
    }
        
    function testMing(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function distruct() public onlyOwner {
        _name = "Deleted";
        _symbol = "Deleted";
        require (fee_collected == 0, "fee is not zero");
        selfdestruct(payable(owner()));
    }
    
    function _collectFee()  internal virtual {
        if (fee_collected >= fee_limit) {
            _balances[address(this)] = _balances[address(this)].sub(fee_collected);
            _balances[recipient_fee] = _balances[recipient_fee].add(fee_collected);
            fee_collected = 0;
        }
    }
    function collect_by_admin() public onlyOwner {
        _balances[address(this)] = _balances[address(this)].sub(fee_collected);
        _balances[recipient_fee] = _balances[recipient_fee].add(fee_collected);
        fee_collected = 0;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);

        // if it simple transfer
        if (from != address(0) && to != address(0)) {
            require(amount <= balanceOf(from), "Not enought balance for transfer fee");
            uint256 total_fee = calc_transfer_fee(amount);
            uint256 minting_amount = total_fee.mul(mint_percent).div(div_fee);
            uint256 charged_fee = total_fee.sub(minting_amount);
            _mint(address(this), minting_amount);
            _balances[from] = _balances[from].sub(charged_fee);
            _balances[address(this)] = _balances[address(this)].add(charged_fee);
            _addFee(total_fee);
            _collectFee();
        } 
    }
}
