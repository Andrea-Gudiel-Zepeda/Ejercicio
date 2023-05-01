// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tienda", function () {
  it("test initial value", async function () {
    const Tienda = await ethers.getContractFactory("Tienda");
    const tienda = await Tienda.deploy();
    await tienda.deployed();
    console.log('tienda desplegada como:'+ tienda.address)
    expect((await tienda.retrieve()).toNumber()).to.equal(0);
  });
   it("test updating and retrieving updated value", async function () {
    const Tienda = await ethers.getContractFactory("Tienda");
    const tienda = await Tienda.deploy();
    await tienda.deployed();
    const tienda2 = await ethers.getContractAt("Tienda", tienda.address);
    const setValue = await tienda2.comprar(56);
    await setValue.wait();
    expect((await tienda2.retrieve()).toNumber()).to.equal(56);
  });
});