// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CREATE2Registry_24 {
    event Deployed(address indexed addr, bytes32 salt);

    // BUG: create2 assembly result not validated before use
    function deploy(bytes memory bytecode, bytes32 salt) external returns (address addr) {
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        // addr may be 0 on failure; emitting event with zero address
        emit Deployed(addr, salt);
    }
}