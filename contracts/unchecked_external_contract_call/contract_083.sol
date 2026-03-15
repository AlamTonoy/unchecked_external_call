// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IVault_83 {
    function withdraw(uint256 amount) external returns (bool);
}

contract StrategyBase_83 {
    IVault_83 public vault;

    constructor(address _vault) { vault = IVault_83(_vault); }

    // BUG: vault.withdraw return value not checked
    function harvest() external {
        vault.withdraw(type(uint256).max);  // UNCHECKED bool return
    }
}