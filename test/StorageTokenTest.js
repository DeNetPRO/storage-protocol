/*
    Test Cases for miners
*/
const { BN } = require('bn.js');
const { network } = require('hardhat');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');
const amount100 = '100000000000000000000';
const amount100k = '100000000000000000000000';
const e16 = new BN('10000000000000000', 10);

contract('StorageToken', async function ([_, w1, w2, w3]) {
    beforeEach(async function () {
        await network.provider.send('evm_increaseTime', [60 * 60 * 24]); // set block time 24H
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000', '10000000');
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await Payments.new(this.pos.address, this.pos.address, 'Terabyte Years', 'TB/Year', 1);
        await this.payments.change_recipient_fee(w2);
        await this.payments.changeTokenAddress(this.token.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);
        
        await this.token.mint(w1, amount100k);
        await this.token.mint(w2, amount100k);
    });
    
    async function getBalance (address, _tkn, callback) {
        const result = await _tkn.balanceOf(address);
        callback(result);
    }

    async function logBalance (address, _tkn) {
        const symbol = await _tkn.symbol();
        await getBalance(address, _tkn, (result) => {
            console.log(
                address + ' => ' + parseInt(result.div(e16).toString(10)) / 100.0 + ' ' + symbol,
            );
        });
    }

    it('should deposit successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w1 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
        await logBalance(w1, this.payments);
        // await getBalance(this, w1, (res) => { console.log('Balance ' + res); });
        // expectEvent(result, 'Transfer', { from: w1, to: this.payments.address, value: '1000'});
    });

    it('should withdraw successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w1 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });

        await this.pos.closeDeposit(this.token.address, { from: w1 });
        await logBalance(w1, this.payments);
    });

    it('should upgrade successfully', async function () {
        await logBalance(w1, this.token);
        for (let i = 0; i < 10; i++) {
            await this.token.approve(this.payments.address, amount100, { from: w1 });
            await this.pos.makeDeposit(this.token.address, amount100, { from: w1 });
            if (i % 2 === 0) {
                await this.token.approve(this.payments.address, amount100, { from: w2 });
                await this.pos.makeDeposit(this.token.address, amount100, { from: w2 });
            }
        }
        await logBalance(w1, this.token);
        await logBalance(w1, this.payments);
        console.log('----------- WITHDRAWING -----------');
        await this.pos.closeDeposit(this.token.address, { from: w1 });
        await logBalance(w1, this.token);
        await logBalance(w1, this.payments);
    });
});