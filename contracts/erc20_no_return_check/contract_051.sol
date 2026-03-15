// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Non-standard token interface (like USDT on Ethereum) - no bool return
interface INonStandardToken_51 {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
}

contract USDTLikeSwap_51 {
    INonStandardToken_51 public usdt;

    constructor(address _usdt) { usdt = INonStandardToken_51(_usdt); }

    // BUG: no return value to check since INonStandardToken has void transfer
    function swap(address to, uint256 amount) external {
        usdt.transferFrom(msg.sender, address(this), amount);  // no return check possible
        // process swap...
        usdt.transfer(to, amount);  // UNCHECKED
    }
}