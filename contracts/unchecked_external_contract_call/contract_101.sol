// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IToken_101 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenDistributor_101 {
    IToken_101 public token;

    constructor(address _token) { token = IToken_101(_token); }

    // BUG: return value of external transfer not checked
    function distribute(address[] calldata users, uint256 amount) external {
        for (uint i = 0; i < users.length; i++) {
            token.transfer(users[i], amount);  // UNCHECKED
        }
    }
}