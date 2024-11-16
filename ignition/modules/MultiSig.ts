// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const MultiSigModule = buildModule("MultiSigModule", (m) => {
  const Owners = ['0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199','0xdD2FD4581271e230360230F9337D5c0430Bf44C0','0xbDA5747bFD65F08deb54cb465eB87D40e51B197E'];
  const confirmations = 2;
  const multiSig = m.contract("MultiSig", [Owners, confirmations]);

  return { multiSig };
});

export default MultiSigModule;
