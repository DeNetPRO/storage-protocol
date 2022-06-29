require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-truffle5');
require('dotenv').config();
require('hardhat-deploy');
require('hardhat-gas-reporter');
require('solidity-coverage');
// require('hardhat-docgen');
require('solidity-docgen');

const networks = require('./hardhat.networks');

module.exports = {
    etherscan: {
        apiKey: process.env.ETHERSCAN_KEY,
    },
    docgen: {
        except: ['ERC20', 'IERC20', 'ERC20.sol'],
        only: ['./contracts/'],
        clear: true,
        runOnCompile: true,
    },
    gasReporter: {
        enable: true,
        currency: 'USD',
    },
    solidity: {
        settings: {
            optimizer: {
                enabled: true,
                runs: 1000000,
            },
        },
        version: '0.8.9',
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    networks,
};
