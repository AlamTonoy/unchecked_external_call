// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiCallReader_75 {
    struct Call {
        address target;
        bytes data;
    }

    // BUG: batch staticcalls, none of the success booleans validated
    function aggregate(Call[] calldata calls) external view
        returns (bytes[] memory results)
    {
        results = new bytes[](calls.length);
        for (uint i = 0; i < calls.length; i++) {
            (, bytes memory ret) = calls[i].target.staticcall(calls[i].data);
            results[i] = ret;   // success ignored on each call
        }
    }
}