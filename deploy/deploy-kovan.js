const hre = require('hardhat');
const { getChainId } = hre;

const POS_ADDRESS = '0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B';
const OLD_PAYMENT_ADDRESS = '0xA260B0aD50fB996cEffa614bAb75846E06991622';
const NAME = 'DeNet Terabyte Years';
const TICKER = 'TB/Year';
const AUTO_MIGRATION_PERIOD = 60 * 60 * 24 * 30 + new Date().getTime() / 1000; // 30 days from NOW

module.exports = async ({ getNamedAccounts, deployments }) => {
    console.log('running deploy script');
    console.log('network id ', await getChainId());

    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const payments = await deploy('Payments', {
        args: [POS_ADDRESS, OLD_PAYMENT_ADDRESS, NAME, TICKER, AUTO_MIGRATION_PERIOD],
        from: deployer,
        skipIfAlreadyDeployed: true,
    });

    console.log('Payments deployed to:', payments.address);
};

module.exports.skip = async () => true;
