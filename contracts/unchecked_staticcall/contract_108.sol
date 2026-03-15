// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CachedOracle_108 {
    mapping(address => uint256) public cache;
    uint256 public lastUpdate;

    // BUG: staticcall failure not detected; cache retains stale value
    function refresh(address oracle, bytes4 sig) external {
        (, bytes memory data) = oracle.staticcall(abi.encodeWithSelector(sig));
        if (data.length >= 32) {
            cache[oracle] = abi.decode(data, (uint256));
            lastUpdate = block.timestamp;
        }
        // No require(success) - silently retains stale if call failed
    }
}