// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TestDAOModule = buildModule("TestDAOModule", (m) => {
  const testDAO = m.contract("TestDAO");

  return { testDAO };
});

export default TestDAOModule;
