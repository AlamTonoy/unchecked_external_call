// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IToken_56 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenDistributor_56 {
    IToken_56 public token;

    constructor(address _token) { token = IToken_56(_token); }

    // BUG: return value of external transfer not checked
    function distribute(address[] calldata users, uint256 amount) external {
        for (uint i = 0; i < users.length; i++) {
            token.transfer(users[i], amount);  // UNCHECKED
        }
    }
}