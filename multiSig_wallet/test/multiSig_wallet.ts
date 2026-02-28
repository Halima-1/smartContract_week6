import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe ("MultiSig", function(){
async function deploymultiSig_wallet(){
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const multiSig_wallet = await hre.ethers.getContractFactory("MultiSig");
    const multiSigwallet = await multiSig_wallet.deploy();

    return {multiSig_wallet, owner, otherAccount};
}
}) 