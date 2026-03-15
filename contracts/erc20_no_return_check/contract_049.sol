// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IWrappedToken_49 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract TokenBridge_49 {
    IWrappedToken_49 public wrappedToken;
    mapping(bytes32 => bool) public processed;

    constructor(address _token) { wrappedToken = IWrappedToken_49(_token); }

    // BUG: transferFrom return value not checked; bridge state updated regardless
    function deposit(uint256 amount, bytes32 destChainTxId) external {
        wrappedToken.transferFrom(msg.sender, address(this), amount);  // UNCHECKED
        processed[destChainTxId] = true;
    }
}