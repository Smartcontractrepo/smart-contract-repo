async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with', deployer.address);

  const MyToken = await ethers.getContractFactory('MyToken');
  const token = await MyToken.deploy('MyToken', 'MTK', ethers.utils.parseUnits('1000000', 18));
  await token.deployed();
  console.log('MyToken deployed to', token.address);

  const TxVault = await ethers.getContractFactory('TxVault');
  const vault = await TxVault.deploy();
  await vault.deployed();
  console.log('TxVault deployed to', vault.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});+
