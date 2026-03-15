// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IStaking_65 {
    function stake(uint256 amount) external returns (uint256 shares);
}

contract AutoCompounder_65 {
    IStaking_65 public stakingPool;

    constructor(address _pool) { stakingPool = IStaking_65(_pool); }

    // BUG: returned shares count not validated
    function compound(uint256 rewards) external {
        uint256 shares = stakingPool.stake(rewards);  // UNCHECKED return
        // shares could be 0 due to failure, not checked
    }
}