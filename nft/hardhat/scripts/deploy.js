(async () => {
  try {
    const Soupr4 = await hre.ethers.getContractFactory("SOUPR4");
    const soupr4Instance = await Soupr4.deploy();

    await soupr4Instance.deployed();

    console.log(`Deployed contract at ${soupr4Instance.address}`);
  } catch (err) {
    console.error(err);
    process.exitCode = 1;
  }
})();
