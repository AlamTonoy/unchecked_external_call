// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract YulCallBatch_88 {
    struct Call {
        address to;
        uint256 value;
        bytes data;
    }

    // BUG: batch of assembly calls, none checked for success
    function executeBatch(Call[] calldata calls) external payable {
        for (uint i = 0; i < calls.length; i++) {
            assembly {
                let callData := calldataload(calls.offset)
                // simplified: call each target
                let ok := call(
                    gas(),
                    calldataload(add(calls.offset, mul(i, 0x60))),
                    0,
                    0, 0, 0, 0
                )
                // ok discarded - all calls treated as successful
            }
        }
    }
}