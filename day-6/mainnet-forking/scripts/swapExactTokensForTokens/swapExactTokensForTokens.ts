const helpers = require("@nomicfoundation/hardhat-network-helpers");
import { ethers } from "hardhat";

const main = async () => {
    const USDCAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
  const DAIAddress = "0x6B175474E89094C44Da98b954EedeAC495271d0F";  
  const UNIRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const TokenHolder = "0xf584f8728b874a6a5c7a8d4d387c9aae9172d621";

  await helpers.impersonateAccount(TokenHolder);
  const impersonatedSigner = await ethers.getSigner(TokenHolder);

  const USDC = await ethers.getContractAt(
    "IERC20",
    USDCAddress,
    impersonatedSigner
  );

  const DAI = await ethers.getContractAt(
    "IERC20",
    DAIAddress,
    impersonatedSigner,
  );

  const UniRouterContract = await ethers.getContractAt(
    "IUniswapV2Router",
    UNIRouter,
    impersonatedSigner);

 const amountIn = ethers.parseUnits("1000", 6);

  const amountOutMin = ethers.parseUnits("990", 18);

  const path = [USDCAddress, DAIAddress];

  const deadline = Math.floor(Date.now() / 1000) + 60 * 10;

  const usdcBalanceBefore = await USDC.balanceOf(impersonatedSigner);

  const daiBalanceBefore = await DAI.balanceOf(impersonatedSigner.address);
  await USDC.approve(UNIRouter, amountIn);

  console.log("=======Before============");

  console.log("daia balance before", Number(daiBalanceBefore));
  console.log("usdc balance before", Number(usdcBalanceBefore));

  const transaction = await UniRouterContract.swapExactTokensForTokens(
    amountIn,
    amountOutMin,
    path,
    impersonatedSigner.address,
    deadline,
  );

   await transaction.wait();

  console.log("=======After============");
  const usdcBalanceAfter = await USDC.balanceOf(impersonatedSigner);
  const daiBalanceAfter = await DAI.balanceOf(impersonatedSigner);
  console.log("dai balance after", Number(daiBalanceAfter));
  console.log("usdc balance after", Number(usdcBalanceAfter));

  console.log("=========Difference==========");
  const newUsdcValue = Number(usdcBalanceBefore - usdcBalanceAfter );
  const newWdaiaValue = daiBalanceAfter - daiBalanceBefore ;
  console.log("NEW USDC BALANCE: ", ethers.formatUnits(newUsdcValue, 6));
  console.log("NEW DAIA BALANCE: ", await DAI.balanceOf(impersonatedSigner.address));
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



    