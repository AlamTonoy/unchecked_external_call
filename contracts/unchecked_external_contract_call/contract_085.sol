// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IStaking_85 {
    function stake(uint256 amount) external returns (uint256 shares);
}

contract AutoCompounder_85 {
    IStaking_85 public stakingPool;

    constructor(address _pool) { stakingPool = IStaking_85(_pool); }

    // BUG: returned shares count not validated
    function compound(uint256 rewards) external {
        uint256 shares = stakingPool.stake(rewards);  // UNCHECKED return
        // shares could be 0 due to failure, not checked
    }
}