// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice Historical exploit: IERC20 on non-standard token caused ABI decode revert — SWC-104
contract NonStandardLiqPool_147 {
    IERC20 public token;

    constructor(address _token) { token = IERC20(_token); }

    // BUG: IERC20.transfer on USDT-like token reverts (no bool returned)
    // Attacker submitted BNB/USDT to trigger silent accounting mismatch
    function distribute(address[] calldata recipients, uint256 amount) external {
        for (uint i = 0; i < recipients.length; i++) {
            token.transfer(recipients[i], amount);  // UNCHECKED: SWC-104
        }
    }
}