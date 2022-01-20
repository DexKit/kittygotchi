import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";

import * as dotenv from 'dotenv';


dotenv.config();


const { ALCHEMY_API, PRIVATE_KEY } = process.env;
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 export default {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.6.0",
        settings: {},
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
       // url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API}`,
        url: `https://polygon-rpc.com/`,
        blockNumber: 20247827
      }
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      gasPrice: 8000000000,
      accounts: [PRIVATE_KEY],
    },
    matic: {
      url: `https://polygon-rpc.com/`,
      accounts: [PRIVATE_KEY],
      gasPrice: 8000000000,
    },
    bsc: {
      url: `https://bsc-dataseed.binance.org/`,
      accounts: [PRIVATE_KEY],
    },
  },
  gasReporter: {
    enabled: true
  }
};