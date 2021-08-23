const { expectEvent } = require('@openzeppelin/test-helpers');

const PoS = artifacts.require('ProofOfStorage');

describe('Example', async function () {
    beforeEach(async function () {
        this.contract = await Example.new();
    });

    it('should be ok', async function () {
        const receipt = await this.contract.func(1);
        expectEvent(receipt, 'Log', '1');
    });
});
