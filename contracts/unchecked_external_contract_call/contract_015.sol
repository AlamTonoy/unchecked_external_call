// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IStaking_15 {
    function stake(uint256 amount) external returns (uint256 shares);
}

contract AutoCompounder_15 {
    IStaking_15 public stakingPool;

    constructor(address _pool) { stakingPool = IStaking_15(_pool); }

    // BUG: returned shares count not validated
    function compound(uint256 rewards) external {
        uint256 shares = stakingPool.stake(rewards);  // UNCHECKED return
        // shares could be 0 due to failure, not checked
    }
}