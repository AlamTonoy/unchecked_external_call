// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ViewCallConsumer_82 {
    // BUG: inline assembly staticcall without success check
    function queryExternal(address target, bytes calldata payload)
        external view returns (bytes memory)
    {
        bytes memory result;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, payload.offset, payload.length)
            let success := staticcall(gas(), target, ptr, payload.length, 0, 0)
            // success never checked
            let size := returndatasize()
            result := mload(0x40)
            mstore(result, size)
            returndatacopy(add(result, 0x20), 0, size)
        }
        return result;
    }
}