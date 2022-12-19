// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    /* The address of the person who is waving is the key. The number of waves made is the value */
    mapping (address => uint) public waveCounts;
    /* Total number of waves made by all users */
    uint256 totalWaves;
    // Generate a random number
    uint256 private seed;

    // an event is a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen.
    event NewWave(address indexed from, uint256 timestamp, string message);

    // a Struct is a custom datatype that you can define
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }
    // an array of Waves to hold all the waves sent to the contract
    Wave[] waves;

    // store the address of the last time the user waved using a mapping
    mapping (address => uint) public lastWavedAt;

    constructor() payable {
        console.log("An alchemist journey into web3");

        // set the seed to the current block timestamp
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        // require that the current timestamp is at least 15-minutes bigger than the last timestamp we stored
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15m");

        // update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        // generate a new seed for the next wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", seed);

        // give 50% chance that the user wins the prize
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            // generate a random amount of money to send back to the user
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    // returns the entire array of waves from the front-end
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;    
    }

    function getWaveCount(address _address) public view returns (uint) {
        console.log("%s has waved %d times!", _address, waveCounts[_address]);
        return waveCounts[_address];
    }
    
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves); 
        return totalWaves;
    }
}