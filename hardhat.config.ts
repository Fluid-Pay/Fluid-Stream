import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
import { network } from "hardhat";
import "hardhat-deploy";

require("@nomicfoundation/hardhat-foundry");

dotenv.config();


const config: HardhatUserConfig = {
  solidity: {
    compilers:[
      {
      version: "0.8.28",
      settings:{
        evmVersion:"paris",
        optimizer: {
          enabled:true,
          runs:200
      }
      }
    }
    ],
  },

  networks:{
    hardhat: {
      allowUnlimitedContractSize:true,
  },


    //op-bnb 
    "op-bnb":{
      url:"https://opbnb-testnet-rpc.bnbchain.org",
      accounts:[process.env.PRIVATE_KEY as string],
      chainId:5611,
    }

  },  
  etherscan:{
    apiKey: {
      testnet:
        process.env.ETHERSCAN_TESTNET_API_KEY ||
        "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
    },

    customChains:[
    {
      network:"op-bnb",
      chainId:5611,
      urls:{
        apiURL:"https://opbnb-testnet-rpc.bnbchain.org",
        browserURL:"http://testnet.opbnbscan.com/",
      }
    }
    ]
    
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    deploy: "./deploy",
    artifacts: "./artifacts",
  },

  
};

export default config;
