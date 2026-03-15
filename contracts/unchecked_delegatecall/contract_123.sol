// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract UserControlledDelegatecall_123 {
    // BUG: user controls target of delegatecall
    function execute(address target, bytes calldata data) external {
        target.delegatecall(data);   // UNCHECKED + arbitrary target
    }
}