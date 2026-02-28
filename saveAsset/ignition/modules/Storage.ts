// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://v2.hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const JAN_1ST_2030 = 1893456000;
const ONE_GWEI: bigint = 1_000_000_000n;

const StorageModule = buildModule("StorageModule", (m) => {
  const storageTime = m.getParameter("storageTime", JAN_1ST_2030);
  const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  const storage = m.contract("Storage", [storageTime], {
    value: lockedAmount,
  });

  return { storage };
});

export default StorageModule;
