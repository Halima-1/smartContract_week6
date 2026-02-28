import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";


describe ("ERC20", function(){
    async function deployERC20(){
       const [owner] =await hre.ethers.getSigners();
       const ERC20 = await hre.ethers.getContractFactory("ERC20");
        const erc20 = await ERC20.deploy("MyToken", "MTK", 18, 1000000);

        return {erc20, owner};
    }
    describe("Deployment", function(){
        it("Should get token name", async function(){
            const {erc20} = await loadFixture(deployERC20);
            const name= await erc20.token_name();

            expect(name).to.equal("MyToken");
        })

        it("Should get token symbol", async function(){
            const {erc20} = await loadFixture(deployERC20);
            const symbol= await erc20.token_symbol();

            expect(symbol).to.equal("MTK");
        })

        it("Should get token decimal", async function(){
            const {erc20} = await loadFixture(deployERC20);
            const decimal= await erc20.decimal();

            expect(decimal).to.equal(18);
        })

        it("Should get token total supply", async function(){
            const {erc20} = await loadFixture(deployERC20);
            const totalSupply= await erc20.totalSupply();

            expect(totalSupply).to.equal(1000000);
        })

        it("Should get balance of the owner", async function(){
            const {erc20,owner} = await loadFixture(deployERC20);
            const balances= await erc20.balanceOf(owner);

            // expect(balances).to.equal(1000000);
        })
    })
});


describe("SaveAsset", function(){
    async function deploySaveAsset(){
        const [owner] = await hre.ethers.getSigners();

        const ERC20 =await hre.ethers.getContractFactory("ERC20");
        const erc20 = await ERC20.deploy("MyToken", "MTK", 18, 1000000);

        const SaveAsset =await hre.ethers.getContractFactory("SaveAsset");
        const saveAsset =await SaveAsset.deploy(erc20.target);

        return {saveAsset, owner, erc20};
    }

    describe("Deposit & withdraw ether", function(){
    it("Should deposit ether", async function(){   
    const {saveAsset} = await loadFixture(deploySaveAsset) ;
await saveAsset.depositEther({value: hre.ethers.parseEther("2")});
await saveAsset.withdraw(2000000000000000000n);
const balance = await saveAsset.getUserSavings();
expect(balance).to.equal(hre.ethers.parseEther("0"));
    })

    })

    describe("Deposit & withdraw ERC20 token", function(){
        it("Should deposit token", async function(){
            const {saveAsset, erc20} = await loadFixture(deploySaveAsset);
            await erc20.approval(saveAsset.target, 200);
            await saveAsset.depositERC20(200);
            const balance = await saveAsset.getErc20SavingsBalance();
            expect(balance).to.equal(200);

        })

        it("Should withdraw token", async function(){
            const {saveAsset, erc20} = await loadFixture(deploySaveAsset);
            await erc20.approval(saveAsset.target, 200);
            await saveAsset.depositERC20(200);
            await saveAsset.withdrawERC20(200);
            const balance = await saveAsset.getErc20SavingsBalance();
            expect(balance).to.equal(0);
        })

        it("Should revert withdraw if insufficient ffunds", async function(){
        const {saveAsset, erc20} = await loadFixture(deploySaveAsset);
        const withdraw = saveAsset.withdrawERC20(3000000000000000000n);
        await expect(withdraw).to.be.revertedWith("Not enough savings");
        })

    })
        
})


// });

