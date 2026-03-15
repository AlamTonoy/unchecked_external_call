// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: assembly call result ignored — SWC-104
contract AssemblyForwarder_136 {
    // BUG: success from assembly call never acted upon
    function forward(address target, bytes calldata payload) external payable {
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, payload.offset, payload.length)
            let success := call(gas(), target, callvalue(), ptr, payload.length, 0, 0)
            // success NOT checked with iszero / revert — SWC-104
            let retSize := returndatasize()
            returndatacopy(ptr, 0, retSize)
            // returns without verifying success
            return(ptr, retSize)
        }
    }
}