const { expectEvent } = require('@openzeppelin/test-helpers');

const PoS = artifacts.require('ProofOfStorage');

describe('ProofOfStorage', async function () {
    beforeEach(async function () {
        this.contract = await PoS.new();
    });

    it('should be ok', async function () {
        const receipt = await this.contract.getBlockNumber();
        expectEvent(receipt);
    });
});
