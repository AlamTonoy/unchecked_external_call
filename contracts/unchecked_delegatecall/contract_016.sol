// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract UnsafeProxy_16 {
    address public implementation;
    address public owner;

    constructor(address _impl) {
        implementation = _impl;
        owner = msg.sender;
    }

    // BUG: delegatecall return value not checked
    fallback() external payable {
        address impl = implementation;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            // result never checked - SWC-112
            returndatacopy(ptr, 0, returndatasize())
            return(ptr, returndatasize())
        }
    }
}