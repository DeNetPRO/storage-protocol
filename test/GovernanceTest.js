// const { expectEvent } = require('@openzeppelin/test-helpers');

const { artifacts } = require('hardhat');

const Governance = artifacts.require('Governance');
const TokenMock = artifacts.require('TokenMock');
const amount100 = '100000000000000000000';

contract('Governance', async function ([_, w1, w2, w3]) {
    beforeEach(async function () {
        this.token = await TokenMock.new('Token', 'TKN');
        this.governance = await Governance.new(this.token.address);

        await this.token.mint(w1, amount100);
        await this.token.mint(w2, amount100);
        await this.token.mint(w3, amount100);
    });

    it('should deposit successfully', async function () {
        await this.token.approve(this.governance.address, amount100, { from: w1 });
        await this.governance.depositToken(amount100, { from: w1 });
    });
});
