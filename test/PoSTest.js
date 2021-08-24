// const { expectEvent } = require('@openzeppelin/test-helpers');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');

contract('ProofOfStorage', async function ([_, w1, w2, w3]) {
    beforeEach(async function () {
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000', '10000000');
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await Payments.new('DeNet Payments', this.pos.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);

        await this.token.mint(w1, 1000);
        await this.token.mint(w2, 1000);
    });

    it('should deposit successfully', async function () {
        await this.token.approve(this.payments.address, '1000', { from: w1 });
        const result = await this.pos.makeDeposit(this.token.address, 1000, { from: w1 });
        // expectEvent(result, 'Transfer', { from: w1, to: this.payments.address, value: '1000'});
    });

    it('should withdraw successfully', async function () {
        await this.token.approve(this.payments.address, '1000', { from: w1 });
        const result1 = await this.pos.makeDeposit(this.token.address, 1000, { from: w1 });
        // expectEvent(result1, 'Transfer', { from: w1, to: this.payments.address, value: '1000'});

        const result2 = await this.pos.closeDeposit(this.token.address, { from: w1 });
        // expectEvent(result2, 'Transfer', { from: this.payments.address, to: w1, value: '1000'});
    });
});
