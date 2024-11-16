// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LotusBeaconContract = buildModule("LotusBeaconContract", (m) => {

  const LotusBeaconContract = m.contract("LotusBeaconContract", [], {});
  return { LotusBeaconContract };
});

export default LotusBeaconContract;