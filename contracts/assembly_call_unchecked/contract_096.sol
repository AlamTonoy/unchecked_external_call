// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract AssemblyRouter_96 {
    // BUG: assembly call return value not checked
    function forwardCall(address target, bytes calldata data)
        external returns (bytes memory result)
    {
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, data.offset, data.length)
            let success := call(gas(), target, 0, ptr, data.length, 0, 0)
            // success NEVER checked - SWC-104 via assembly
            let size := returndatasize()
            result := mload(0x40)
            mstore(result, size)
            returndatacopy(add(result, 0x20), 0, size)
            mstore(0x40, add(result, add(0x20, size)))
        }
    }
}