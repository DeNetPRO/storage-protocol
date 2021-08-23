const { expectEvent } = require('@openzeppelin/test-helpers');

const PoS = artifacts.require('ProofOfStorage');

describe('ProofOfStorage', async function () {
    beforeEach(async function () {
        this.contract = await PoS.new(["0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "10000000"]);
    });

    it('should be ok', async function () {
        const receipt = await this.contract.getBlockNumber();
        return 1;
    });
});
