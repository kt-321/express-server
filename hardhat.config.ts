import { HardhatUserConfig } from "hardhat/config";
// import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
// import "@nomiclabs/hardhat-waffle";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "hardhat",
};

export default config;
