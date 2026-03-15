// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IVault_58 {
    function withdraw(uint256 amount) external returns (bool);
}

contract StrategyBase_58 {
    IVault_58 public vault;

    constructor(address _vault) { vault = IVault_58(_vault); }

    // BUG: vault.withdraw return value not checked
    function harvest() external {
        vault.withdraw(type(uint256).max);  // UNCHECKED bool return
    }
}