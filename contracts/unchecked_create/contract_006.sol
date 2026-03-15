// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ChildFactory_6 {
    address[] public children;

    // BUG: 'new' can silently return address(0) on OOG; not checked
    function deploy(bytes32 salt, uint256 value) external payable {
        address child;
        bytes memory bytecode = type(Child_6).creationCode;
        assembly {
            child := create2(value, add(bytecode, 0x20), mload(bytecode), salt)
            // create2 returns 0 on failure - never checked here
        }
        children.push(child);  // may push address(0)
    }
}

contract Child_6 {
    uint256 public x;
    constructor() { x = 42; }
}