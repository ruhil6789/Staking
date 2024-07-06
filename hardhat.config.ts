import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import { PRIVATE_KEY, API_URL } from "./secrets.json"
const config: HardhatUserConfig = {
  solidity: "0.8.0",
  networks: {
  
    hardhat: {},
    mumbai: {
      url: API_URL,
      accounts: [PRIVATE_KEY]
    }

  },
  etherscan: {
    apiKey: 'QHUS99GVXP1S4I3ETBYJ8P38X5PEVQ36D9'
  },
  sourcify: {
    enabled: true
  }
};

export default config;
