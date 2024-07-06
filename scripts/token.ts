// import hre from "hardhat";
import { ethers } from "hardhat";

async function main() {
    // const [signer] = await ethers.getSigners;
    // console.log(`Contract deploying from ${await signer.address}`);

    const Token = await ethers.getContractFactory("Token");
    console.log("------------here")
    const tokenInstance = await Token.deploy(10000000);

    await tokenInstance.deployed();

    console.log("Token deployed to:", await tokenInstance.address)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
