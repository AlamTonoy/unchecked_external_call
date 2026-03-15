// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IVault_43 {
    function withdraw(uint256 amount) external returns (bool);
}

contract StrategyBase_43 {
    IVault_43 public vault;

    constructor(address _vault) { vault = IVault_43(_vault); }

    // BUG: vault.withdraw return value not checked
    function harvest() external {
        vault.withdraw(type(uint256).max);  // UNCHECKED bool return
    }
}