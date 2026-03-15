// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract StorageUpgrade_104 {
    uint256 public value;
    address public impl;

    function upgrade(address newImpl) external { impl = newImpl; }

    // BUG: delegatecall to mutable impl without return check
    function doUpgrade(bytes calldata initData) external {
        impl.delegatecall(initData);  // UNCHECKED
    }
}