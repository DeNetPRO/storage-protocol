/*
    Test Cases for miners
*/
const { BN } = require('bn.js');
const { network } = require('hardhat');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const OldPayments = artifacts.require('OldPayments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');
const amount100 = '100000000000000000000';
const amount100k = '100000000000000000000000';
const e16 = new BN('10000000000000000', 10);

contract('StorageToken', async function ([_, w1, w2, w3, w4]) {
    beforeEach(async function () {
        /* Deploy Contracts */
        await network.provider.send('evm_increaseTime', [60 * 60 * 24]); // set block time 24H
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000', '10000000');
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await OldPayments.new('Old Payments', this.pos.address);

        /* Update Supported Addresses */
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);

        /* Mint Tokens For test accounts */
        await this.token.mint(w1, amount100k);
        await this.token.mint(w2, amount100k);
        await this.token.mint(w3, amount100k);
    });
    
    /* Beautify token logging balances */
    async function logBalance (address, _tkn) {
        const symbol = await _tkn.symbol();
        const result = await _tkn.balanceOf(address);
        console.log(
            address + ' => ' + parseInt(result.div(e16).toString(10)) / 100.0 + ' ' + symbol,
        );
    }

    it('should deposit successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w1 });
        await this.pos.setUserPlan(this.token.address, { from: w1 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
    });

    it('should withdraw successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w1 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
        await this.pos.closeDeposit(this.token.address, { from: w1 });
    });

    /*
        1. Deposit tokens to Old Payments for w1 and w2
        2. Show Balances
        3. Withdraw for w1
        4. Upgrade contract
        5. Migrate for w2
        6. Show balances and collect fees. +
        7. Deposit tokens for w1 (same amount of tokens in w2)
        8. Show balances
        8. Withdraw for w1, w2
    */
    it('should upgrade successfully', async function () {
        for (let i = 0; i < 10; i++) {
            /* add balance to account 1 */
            await this.token.approve(this.payments.address, amount100, { from: w1 });
            await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
            
            /* add balance to account 2 */
            await this.token.approve(this.payments.address, amount100, { from: w2 });
            await this.pos.makeDeposit(this.token.address, amount100, { from: w2 });
        }

        await this.pos.closeDeposit(this.token.address, { from: w1 });

        this.newPayments = await Payments.new(this.pos.address, this.payments.address, 'Terabyte Years', 'TB/Year', 1);
        
        await this.payments.changePoS(this.newPayments.address); // add new payments as PoS
        await this.newPayments.change_recipient_fee(w3);
        await this.newPayments.changeTokenAddress(this.token.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.newPayments.address);
        
        await this.newPayments.migrateFromOldPayments(w2);
        
        for (let i = 0; i < 10; i++) {
            /* add balance to account 1 */
            await this.token.approve(this.newPayments.address, amount100, { from: w1 });
            await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
        }

        await this.newPayments.transfer(w2, e16.mul(new BN(10)), { from: w1 });
        
        await this.newPayments.testMint(w4, amount100);

        await this.pos.closeDeposit(this.token.address, { from: w1 });
        await this.pos.closeDeposit(this.token.address, { from: w2 });

        const _supply = await this.newPayments.totalSupply();
        const _amounts = await this.token.balanceOf(this.newPayments.address);
        console.log('Total TB Supply ', _supply.div(e16) / 100.0);
        console.log('Total Token Collected ', _amounts.div(e16) / 100.0);
    });
});
