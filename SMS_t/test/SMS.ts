import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { erc20 } from "../typechain-types/@openzeppelin/contracts/token";

describe("SMS", function () {
  
  async function deploySMS() {
    // Contracts are deployed using the first signer/account by default
    const [owner, user1, user2] = await hre.ethers.getSigners();

    const ERC20 = await hre.ethers.getContractFactory("ERC20");
    const erc20 = await ERC20.deploy("MyToken", "MTK", 18, 100000000000000000000000n);

    const SMS = await hre.ethers.getContractFactory("SMS");
    const sms = await SMS.deploy(erc20.target);
// const studentFullname: string = "";

    return { sms, erc20, owner, user1, user2 };
  }

  describe("Deployment", function () {
      it("Should add new student", async function () {
        const { sms, erc20 } = await loadFixture(deploySMS);
        await erc20.approval(sms.target, 200000000000000000000n)
    await sms.addStudent("Samuel", "m", 100);
        const students = await sms.getAllStudent();
        expect(students[0].studentFullname).to.equal("Samuel");
        expect(students[0].gender).to.equal("m");
        expect(students.length).to.equal(1);
        expect(students[0].id).to.equal(1);
      });

      it("Should get all student", async function(){
        const { sms } = await loadFixture(deploySMS);
        let students: any = await sms.getAllStudent();

      })

      it ("Should add new staff", async function(){
         const { sms, user1 } = await loadFixture(deploySMS);
    await sms.addStaff(user1.address, "Mary", "F");
    const staff = await sms.getAllStaff();
    expect(staff[0].staff_fullname).to.equal("Mary")
    expect(staff[0].staffAddress).to.equal(user1.address)
    expect(staff[0].gender).to.equal("F")
      }) 

      it("Should get all staff", async function(){
        const { sms } = await loadFixture(deploySMS);
        const staff: any =await sms.getAllStaff()

      })

      it("Should remove student", async function(){
      const { sms,owner, erc20 } = await loadFixture(deploySMS);
        await erc20.approval(sms.target, 200000000000000000000n)
      await sms.addStudent("Daniel", "M", 100);
      let students = await sms.getAllStudent();
            expect(students.length).to.equal(1);
      await sms.connect(owner).removeStudent(1);
         students = await sms.getAllStudent();
      expect(students.length).to.equal(0);
      })

      it("Should suspend student", async function(){
         const { sms,owner, erc20 } = await loadFixture(deploySMS);
        await erc20.approval(sms.target, 200000000000000000000n)
      await sms.addStudent("Daniel", "M", 100);
      let students = await sms.getAllStudent();
            expect(students.length).to.equal(1);
      await sms.connect(owner).suspendStudent(1);
         students = await sms.getAllStudent();
      expect(students[0].suspended).to.equal(true);
      })

      it("Should suspend staff", async function(){
         const { sms,owner, user1,user2 } = await loadFixture(deploySMS);
      await sms.addStaff(user1.address, "Mary", "F");
      let staff = await sms.getAllStaff();
            expect(staff.length).to.equal(1);
      await sms.connect(owner).suspendStaff(1);
         staff = await sms.getAllStaff();
      expect(staff[0].suspended).to.equal(true);
      })

      it ("Should pay staff", async function(){

        const STAFF_SALARY=5000;
      const { sms,owner, erc20,user2 } = await loadFixture(deploySMS);
        await erc20.mint(sms.target, STAFF_SALARY);
      await sms.connect(owner).payStaff(1);
      const staff = await sms.getAllStaff();
      expect(staff[0].paymentStatus).to.equal(true);

      })
  });
})