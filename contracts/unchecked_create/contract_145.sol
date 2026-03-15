// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: create2 zero address stored in registry — SWC-104
contract Create2Factory_145 {
    mapping(bytes32 => address) public registry;

    // BUG: create2 result not validated
    function deploy(bytes32 salt, bytes calldata initCode) external returns (address addr) {
        assembly {
            addr := create2(0, add(initCode.offset, 0), initCode.length, salt)
            // addr == address(0) means failure — NEVER checked — SWC-104
        }
        registry[salt] = addr;  // silently registers address(0)
    }
}