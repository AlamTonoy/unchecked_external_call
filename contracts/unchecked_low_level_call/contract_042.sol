// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract UnsafeWithdraw_42 {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // BUG: .call return value ignored
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient");
        balances[msg.sender] -= amount;
        payable(msg.sender).call{value: amount}("");  // UNCHECKED
    }
}