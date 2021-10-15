import { ethers, network } from "hardhat";
import { Signer, BigNumber } from "ethers";
import chai, { expect } from "chai";
import { solidity } from "ethereum-waffle";



chai.use(solidity);


const PRICE = BigNumber.from(100);

describe("Kittygotchi", function () {

  it("Should mint and feed gotchi", async function () {
    const Kitty = await ethers.getContractFactory("KittygotchiTest");
    const kitty = await Kitty.deploy();
    await kitty.deployed();
    const [owner, ...rest] = await ethers.getSigners();


    let mint = await kitty.connect(owner).safeMint({value: PRICE});
    await mint.wait()
    mint = await kitty.connect(owner).safeMint({value: PRICE});
    await mint.wait()

    const feed = await kitty.connect(owner).feed(1);
    await feed.wait();
    console.log((await kitty._random(1)).toString())
    console.log((await kitty.randomRun(1)).toString())
    console.log((await kitty.getAttackOf(1)).toString())
    console.log((await kitty.getRunOf(1)).toString())
    console.log((await kitty.getDefenseOf(1)).toString())
    
  });



});
