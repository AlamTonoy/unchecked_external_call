// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: address(0) from create not checked — SWC-104
contract ProxyFactory_142 {
    address[] public deployedClones;
    bytes public implementation;

    constructor(bytes memory _impl) { implementation = _impl; }

    // BUG: create result not checked for address(0)
    function deployClone() external returns (address clone) {
        bytes memory bytecode = implementation;
        assembly {
            clone := create(0, add(bytecode, 0x20), mload(bytecode))
            // clone == address(0) on failure — NEVER checked — SWC-104
        }
        deployedClones.push(clone);  // pushes address(0) silently on failure
    }
}