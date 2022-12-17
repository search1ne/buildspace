const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy();
    await waveContract.deployed();
  
    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
  
    await waveContract.getTotalWaves();
    
    const senderAddresses = []
    const firstWaveTxn = await waveContract.wave();
    senderAddresses.push(firstWaveTxn.sender);
    await firstWaveTxn.wait();

  
    await waveContract.getTotalWaves();
  
    const secondWaveTxn = await waveContract.connect(randomPerson).wave();
    senderAddresses.push(secondWaveTxn.sender);    
    await secondWaveTxn.wait();

    const waveCount = await waveContract.getWaveCount(owner.address);
    console.log(`Number of waves made by contract owner: ${waveCount}`)
  
    await waveContract.getTotalWaves();

  };

  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();