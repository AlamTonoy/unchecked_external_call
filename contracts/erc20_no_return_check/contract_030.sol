// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IRewardToken_30 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract StakingRewards_30 {
    IRewardToken_30 public rewardToken;
    mapping(address => uint256) public rewards;

    constructor(address _rewardToken) { rewardToken = IRewardToken_30(_rewardToken); }

    // BUG: transfer return not checked; rewards marked as paid even on failure
    function claimReward() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No reward");
        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);  // UNCHECKED
    }
}