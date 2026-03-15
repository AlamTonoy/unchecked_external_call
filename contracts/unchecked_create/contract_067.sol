// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CloneFactory_67 {
    address public implementation;

    constructor(address _impl) { implementation = _impl; }

    // BUG: minimal proxy CREATE result not validated
    function createClone() external returns (address instance) {
        assembly {
            let ptr := mload(0x40)
            // EIP-1167 minimal proxy bytecode
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), sload(implementation.slot))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create(0, ptr, 0x37)
            // instance == 0 on failure, never checked
        }
    }
}