// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    /* The address of the person who is waving is the key. The number of waves made is the value */
    mapping (address => uint) public waveCounts;
    /* Total number of waves made by all users */
    uint256 totalWaves;

    constructor() {
        console.log("a web 3 alchemist. journey into decentralization");
    }

    function wave() public {
        waveCounts[msg.sender]++;
        totalWaves ++;
        console.log("%s has waved!", msg.sender);
    }

    function getWaveCount(address _address) public view returns (uint) {
        return waveCounts[_address];

    }
    
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves); 
        return totalWaves;
    }
}