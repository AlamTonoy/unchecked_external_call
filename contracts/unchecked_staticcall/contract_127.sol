// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: staticcall revert treated as zero price — SWC-104
contract OracleCache_127 {
    address public priceOracle;

    constructor(address _oracle) { priceOracle = _oracle; }

    // BUG: staticcall bool ignored — reverted oracle treated as zero
    function fetchPrice(bytes4 selector, address asset)
        external view returns (uint256 price)
    {
        (, bytes memory data) = priceOracle.staticcall(
            abi.encodeWithSelector(selector, asset)
        );
        // success discarded — SWC-104 — attacker forced oracle to revert
        if (data.length >= 32) price = abi.decode(data, (uint256));
    }
}