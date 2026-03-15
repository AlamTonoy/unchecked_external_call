// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

// Non-standard ERC-20 (like USDT) — transfer/transferFrom return void
interface ILegacyToken_132 {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function balanceOf(address who) external view returns (uint256);
}

/// @notice Historical exploit: no return check on USDT-style transfer — SWC-104
contract NonStandardLiqPool_132 {
    ILegacyToken_132 public token;

    constructor(address _token) { token = ILegacyToken_132(_token); }

    // BUG: non-standard token has no return value — silent failure exploited
    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount); // UNCHECKED
    }

    function withdraw(address to, uint256 amount) external {
        token.transfer(to, amount); // UNCHECKED — SWC-104
    }
}