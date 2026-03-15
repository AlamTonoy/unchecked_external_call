// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: unchecked .call() allowed silent drain — SWC-104
contract MultiRecipientSplitter_136 {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() { owner = msg.sender; }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // BUG: return value of .call() not checked
    function split(address payable recipient, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        require(balances[address(this)] >= amount, "Low balance");
        // UNCHECKED: SWC-104 – silent failure exploited in historical attack
        recipient.call{value: amount}("");
        balances[address(this)] -= amount;
    }

    receive() external payable {}
}