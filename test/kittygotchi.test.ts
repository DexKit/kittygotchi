import { ethers, network } from "hardhat";
import { Signer, BigNumber } from "ethers";
import chai, { expect } from "chai";
import { solidity } from "ethereum-waffle";



chai.use(solidity);


const PRICE = BigNumber.from(100);
const PRICE_MAIN = BigNumber.from(11).mul(BigNumber.from(10).pow(18));

describe("Kittygotchi", function () {

  it("Should mint and feed gotchi", async function () {
    const Kitty = await ethers.getContractFactory("KittygotchiTest");
    const kitty = await Kitty.deploy();
    await kitty.deployed();
    const [owner, ...rest] = await ethers.getSigners();
    const pr = ethers.getDefaultProvider();
    console.log(kitty.address)
    let mint = await kitty.connect(owner).safeMint({value: PRICE});
    await mint.wait()
    mint = await kitty.connect(owner).safeMint({value: PRICE});
    await mint.wait()
    const balance3 = await pr.getBalance(kitty.address);
    console.log(balance3.toString());
    const feed = await kitty.connect(owner).feed(1);
    await feed.wait();
    /*console.log((await kitty._random(1)).toString())
    console.log((await kitty.randomRun(1)).toString())
    console.log((await kitty.getAttackOf(1)).toString())
    console.log((await kitty.getRunOf(1)).toString())
    console.log((await kitty.getDefenseOf(1)).toString())*/
    const balance = await pr.getBalance(kitty.address);
    console.log(balance.toString())
    const withdraw = await kitty.connect(owner).withdrawETH();
    await withdraw.wait();
    const balance2 = await pr.getBalance(kitty.address) as BigNumber;

    //expect(balance.toString()).to.be.eq(PRICE.add(PRICE).toString())
    //expect(balance2.toString()).to.be.eq(BigNumber.from(0).toString())


  });
  it("Should mint on mainnet", async function () {
    const Kitty = await ethers.getContractFactory("Kittygotchi");
    const kitty = await Kitty.deploy();
    await kitty.deployed();
    const [owner, ...rest] = await ethers.getSigners();


    let mint = await kitty.connect(owner).safeMint({value: PRICE_MAIN});
    await mint.wait()
    mint = await kitty.connect(owner).safeMint({value: PRICE_MAIN});
    await mint.wait()

    const feed = await kitty.connect(owner).feed(0);
    await feed.wait();
    console.log((await kitty.getAttackOf(1)).toString())
    console.log((await kitty.getRunOf(1)).toString())
    console.log((await kitty.getDefenseOf(1)).toString())
    //const withdraw = await kitty.connect(rest[0]).withdrawETH();
    const balance = await owner.getBalance();
    const withdraw = await kitty.connect(owner).withdrawETH();
    await withdraw.wait();
    const balance2 = await owner.getBalance() as BigNumber;

    //expect(balance).to.be.eq(balance2.add(PRICE).add(PRICE))


  });


});
