// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import hre  from "hardhat";
async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');


  const Kitty = await hre.ethers.getContractFactory("KittygotchiMumbai");
  
  const kitty = await Kitty.attach("0xbdd0C521aBb19fA863917e2C807f327957D239ff");

  const claim = await kitty.withdrawETH();
  await claim.wait();
  console.log("Kittygotchi deployed to:", kitty.address);
 
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
