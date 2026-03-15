// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IVault_38 {
    function withdraw(uint256 amount) external returns (bool);
}

contract StrategyBase_38 {
    IVault_38 public vault;

    constructor(address _vault) { vault = IVault_38(_vault); }

    // BUG: vault.withdraw return value not checked
    function harvest() external {
        vault.withdraw(type(uint256).max);  // UNCHECKED bool return
    }
}