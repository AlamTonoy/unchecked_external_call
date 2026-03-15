// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IVault_78 {
    function withdraw(uint256 amount) external returns (bool);
}

contract StrategyBase_78 {
    IVault_78 public vault;

    constructor(address _vault) { vault = IVault_78(_vault); }

    // BUG: vault.withdraw return value not checked
    function harvest() external {
        vault.withdraw(type(uint256).max);  // UNCHECKED bool return
    }
}