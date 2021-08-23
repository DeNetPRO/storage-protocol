const hre = require('hardhat');
const { getChainId } = hre;

module.exports = async ({ deployments, getNamedAccounts }) => {
    console.log('running deploy script');
    console.log('network id ', await getChainId());

    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const PoS = await deploy('ProofOfStorage', {
        from: deployer,
    });

    console.log('ProofOfStorage deployed to:', PoS.address);

    if (await getChainId() !== '31337') {
        await hre.run('verify:verify', {
            address: PoS.address,
        });
    }
};

module.exports.skip = async () => true;
