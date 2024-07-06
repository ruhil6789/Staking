import { run } from "hardhat";


const tokenAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
const amount = 100000000;

async function main() {
    await run("token contract verify", {
        address: tokenAddress,
        contract: "contract/Token.sol:Token",
        constructorArguments: [amount]
    })
    // await run ("",{
    //     tokenAddress:"",
    //     contract:"",
    //     constructorArguments:[]
    // })
}


main()
    .then(() => process.exit(0))
    .catch((error: any) => {
        console.log(error, "error");
        process.exit()
    })