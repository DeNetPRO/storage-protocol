// const { expectEvent } = require('@openzeppelin/test-helpers');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');
const Reward = artifacts.require('Reward');
const amount100 = '100000000000000000000';

contract('Reward', async function ([_, w1, w2, w3]) {
    async function getBalance (self, address, callback) {
        const result = await self.payments.balanceOf(address);
        callback(result.toString());
    }
    beforeEach(async function () {
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000');
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await Payments.new(this.pos.address, 'Terabyte Years', 'TB/Year');
        this.reward = await Reward.new(this.payments.address);
        await this.payments.changeTokenAddress(this.token.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);
        
        await this.token.mint(w1, amount100);
        await this.token.mint(w2, amount100);
        await this.token.mint(w3, amount100);
    });

    it('should reward successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w3 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w3 });
        await getBalance(this, w3, (res) => { console.log('Balance ' + res); });
        const balance = await this.payments.balanceOf(w3);
        this.payments.transfer(this.reward.address, balance, { from: w3 });
        await getBalance(this, this.reward.address, (res) => { console.log('Balance ' + res); });
    });
});
