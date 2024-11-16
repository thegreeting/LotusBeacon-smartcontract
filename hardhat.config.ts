import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as ethernal from "hardhat-ethernal";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.27",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
      viaIR: true,
    },
  },
  networks: {
    hardhat: {
      accounts: {
        mnemonic: process.env.DEPLOYER_MNEMONIC,
        count: 50,
      },
    },
    sepolia: {
      url: process.env.SEPOLIA_URL,
      chainId: 11155111,
      accounts: [process.env.DEPLOYER_PK as string],
    },
    mainnet: {
      url: process.env.MAINNET_URL,
      chainId: 1,
      accounts: [process.env.DEPLOYER_PK as string],
    },
  },
  etherscan: {
    apiKey: {
      // mainnet: process.env.ETHERSCAN_API_KEY as string,
      sepolia: process.env.ETHERSCAN_API_KEY as string,
    },
  },
  ethernal: {
    apiToken: process.env.ETHERNAL_API_TOKEN,
    disableSync: false,
    disableTrace: false,
    uploadAst: true,
    verbose: true,
    disabled: false,
  }
};

export default config;
