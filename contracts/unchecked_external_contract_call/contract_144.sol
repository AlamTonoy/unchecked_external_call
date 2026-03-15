// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracle_144 {
    function getPrice(address asset) external returns (uint256);
}

/// @notice Historical exploit: ignored oracle return allowed price manipulation — SWC-104
contract PriceAggregator_144 {
    IOracle_144 public oracle;
    mapping(address => uint256) public cachedPrices;

    constructor(address _oracle) { oracle = IOracle_144(_oracle); }

    // BUG: return value of oracle.getPrice() discarded
    function updatePrice(address asset) external {
        oracle.getPrice(asset);   // UNCHECKED: return value ignored — SWC-104
        // price never actually stored; stale price exploited
    }

    function liquidate(address user, address asset) external {
        uint256 price = cachedPrices[asset]; // stale; attacker manipulated
        require(price > 0, "No price");
        // liquidation logic omitted
    }
}