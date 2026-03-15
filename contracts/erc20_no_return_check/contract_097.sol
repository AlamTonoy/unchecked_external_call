// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC20Unsafe_97 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract LiquidityPool_97 {
    IERC20Unsafe_97 public token;

    constructor(address _token) { token = IERC20Unsafe_97(_token); }

    // BUG: ERC20 transfer return value ignored (token may be USDT/BNB style)
    function removeLiquidity(address to, uint256 amount) external {
        token.transfer(to, amount);  // UNCHECKED bool
    }

    function addLiquidity(uint256 amount) external {
        token.approve(address(this), amount);  // UNCHECKED bool
    }
}