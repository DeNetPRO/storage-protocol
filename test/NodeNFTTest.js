// const { expectEvent } = require('@openzeppelin/test-helpers');

const { artifacts } = require('hardhat');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');
const Reward = artifacts.require('Reward');
const NodeNFT = artifacts.require('DeNetNodeNFT');
const amount100 = '100000000000000000000';
function getRandomInt (max) {
    return Math.floor(Math.random() * max);
}

contract('DeNetNodeNFT', async function ([_, w1, w2, w3]) {
    beforeEach(async function () {
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000', '10000000');
        this.nodeNFT = await NodeNFT.new('DeNet Storage Node', 'DEN', this.pos.address, 10);
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await Payments.new(this.pos.address, 'Terabyte Years', 'TB/Year');
        this.reward = await Reward.new(this.payments.address);
        await this.payments.changeTokenAddress(this.token.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);
        
        await this.token.mint(w1, amount100);
        await this.token.mint(w2, amount100);
        await this.token.mint(w3, amount100);
    });
    it('should node create successfully', async function () {
        // Creating nodes for all addresses
        const nodeList = [w1, w2, w3];
        for (let j = 0; j < nodeList.length; j++) {
            const ip = [];
            const naddress = nodeList[j];
            for (let i = 0; i < 4; i++) {
                ip.push(getRandomInt(255));
            }
            await this.nodeNFT.createNode(ip, getRandomInt(65554), { from: naddress });
            // const NodeID = await this.nodeNFT.totalSupply();
        }
    });

    it('should node update successfully', async function () {
        // Creating nodes for all addresses
        const nodeList = [w1, w2, w3];
        for (let j = 0; j < nodeList.length; j++) {
            const ip = [];
            const naddress = nodeList[j];
            for (let i = 0; i < 4; i++) {
                ip.push(getRandomInt(255));
            }
            await this.nodeNFT.createNode(ip, getRandomInt(65554), { from: naddress });
            // const NodeID = await this.nodeNFT.totalSupply();
        }
        
        // Try to Update
        for (let j = 0; j < nodeList.length; j++) {
            const ip = [];
            const naddress = nodeList[j];
            for (let i = 0; i < 4; i++) {
                ip.push(getRandomInt(255));
            }
            let nodeId = await this.nodeNFT.getNodeIDByAddress(naddress);
            nodeId = nodeId.toString();
            // const oldInfo = await this.nodeNFT.nodeInfo(nodeId);
            await this.nodeNFT.updateNode(nodeId, ip, getRandomInt(65554), { from: naddress });
            // const newInfo = await this.nodeNFT.nodeInfo(nodeId);
        }
    });
    it('should reward successfully', async function () {
        await this.token.approve(this.payments.address, amount100, { from: w3 });
        await this.pos.makeDeposit(this.token.address, amount100, { from: w3 });
        const balance = await this.payments.balanceOf(w3);
        this.payments.transfer(this.reward.address, balance, { from: w3 });
    });
});
