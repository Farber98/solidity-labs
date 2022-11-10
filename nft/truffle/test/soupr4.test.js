const Soupr4 = artifacts.require("SOUPR4");
const truffleAssert = require("truffle-assertions");

contract("SOUPR4", (accounts) => {
  it("should credit an NFT to a specific account", async () => {
    const soupr4Instance = await Soupr4.deployed();
    let txResult = await soupr4Instance.safeMint(accounts[1], "soupr4.json");

    truffleAssert.eventEmitted(txResult, "Transfer", {
      from: "0x0000000000000000000000000000000000000000",
      to: accounts[1],
      tokenId: web3.utils.toBN("0"),
    });

    assert.equal(
      await soupr4Instance.ownerOf(0),
      accounts[1],
      "Owner of Token is the wrong address"
    );
  });
});
