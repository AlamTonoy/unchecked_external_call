// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStrategy_137 {
    function harvest() external returns (uint256 harvested);
    function withdraw(uint256 amount) external returns (bool);
}

/// @notice Historical exploit: ignored withdraw() return allowed double-withdrawal — SWC-104
contract StrategyVault_137 {
    IStrategy_137 public strategy;
    address public vault;

    constructor(address _strategy, address _vault) {
        strategy = IStrategy_137(_strategy);
        vault = _vault;
    }

    // BUG: withdraw return not checked
    function rebalance(uint256 amount) external {
        require(msg.sender == vault);
        strategy.withdraw(amount);  // UNCHECKED: SWC-104
        strategy.harvest();         // UNCHECKED: SWC-104
    }
}