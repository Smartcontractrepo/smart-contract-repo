const { expect } = require('chai');

describe('Simple integration', function () {
  it('deploys token and vault', async function () {
    const [owner, user] = await ethers.getSigners();

    const MyToken = await ethers.getContractFactory('MyToken');
    const token = await MyToken.deploy('MyToken', 'MTK', ethers.utils.parseUnits('1000', 18));
    await token.deployed();

    const TxVault = await ethers.getContractFactory('TxVault');
    const vault = await TxVault.deploy();
    await vault.deployed();

    // deposit to vault
    await vault.connect(user).deposit('0xdeadbeef', 'sample metadata', { value: ethers.utils.parseEther('0.01') });
    const count = await vault.getTxCount();
    expect(count).to.equal(1);

    const t = await vault.getTx(0);
    expect(t.txid).to.equal('0xdeadbeef');
  });
});+
