const { expect } = require("chai");
const hre = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("SOUPR4", function () {
  async function deploySoupr4AndMintTokenFixture() {
    const Soupr4 = await hre.ethers.getContractFactory("SOUPR4");
    const soupr4Instance = await Soupr4.deploy();

    const [owner, otherAccount] = await ethers.getSigners();
    await soupr4Instance.safeMint(otherAccount.address);
    return { soupr4Instance };
  }

  it("be able to mint a token", async function () {
    const { soupr4Instance } = await loadFixture(
      deploySoupr4AndMintTokenFixture
    );

    const [owner, otherAccount] = await ethers.getSigners();
    expect(await soupr4Instance.ownerOf(0)).to.equal(otherAccount.address);
  });

  it("fails to transfer tokens from the wrong address", async function () {
    const { soupr4Instance } = await loadFixture(
      deploySoupr4AndMintTokenFixture
    );

    const [owner, nftOwnerAccount, notNftOwnerAccount] =
      await ethers.getSigners();
    expect(await soupr4Instance.ownerOf(0)).to.equal(nftOwnerAccount.address);
    await expect(
      soupr4Instance
        .connect(notNftOwnerAccount)
        .transferFrom(nftOwnerAccount.address, notNftOwnerAccount.address, 0)
    ).to.be.revertedWith("ERC721: caller is not token owner nor approved");
  });
});
