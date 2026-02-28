import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("PropertyManagement", function () {
  
  async function deployPropertyManagement() {
    // Contracts are deployed using the first signer/account by default
    const [owner, user1, user2] = await hre.ethers.getSigners();

    const ERC20 = await hre.ethers.getContractFactory("ERC20");
    const erc20 = await ERC20.deploy("MyToken", "MTK", 18, 100000000000000000000000n);

    const PropertyManagement = await hre.ethers.getContractFactory("PropertyManagement");
    const property_Management = await PropertyManagement.deploy(erc20.target);
// const studentFullname: string = "";

    return { property_Management, erc20, owner, user1, user2 };
  }

  describe("Deployment", function () {
      it("Should create new student", async function () {
        const { property_Management } = await loadFixture(deployPropertyManagement);
    await property_Management.addProperty("Car", 100, "yyyy");
        const properties = await property_Management.getAllProperties();
        // expect(properties[0].propertyType).to.equal("Car");
        expect(properties[0].amount).to.equal(100);
        expect(properties.length).to.equal(1);
        expect(properties[0].id).to.equal(1);
      });

      it("Should get all properties", async function(){
        const { property_Management } = await loadFixture(deployPropertyManagement);
        let students: any = await property_Management.getAllProperties();

      })


    //   it("Should get all staff", async function(){
    //     const { property_Management } = await loadFixture(deployPropertyManagement);
    //     const staff: any =await property_Management.getAllStaff()

    //   })

      it("Should remove properties", async function(){
      const { property_Management,owner, erc20 } = await loadFixture(deployPropertyManagement);
      await property_Management.addProperty("car", 100, "hh");
      let properties = await property_Management.getAllProperties();
            expect(properties.length).to.equal(1);
      await property_Management.connect(owner).removeProperty(1);
         properties = await property_Management.getAllProperties();
      expect(properties.length).to.equal(0);
      })

      it ("Should buy property", async function(){
      const { property_Management,owner, user1,erc20 } = await loadFixture(deployPropertyManagement);
        await erc20.approval(property_Management.target, 200000000000000000000n)
        await property_Management.addProperty("car", 100, "hh");
      let property = await property_Management.getAllProperties();
      await property_Management.buyProperty(1);
       property = await property_Management.getAllProperties();
      expect(property[0].soldOut).to.equal(true);

      })
  });
})