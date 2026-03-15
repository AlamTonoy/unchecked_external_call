// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IOracle_17 {
    function latestAnswer() external returns (int256);
}

contract PriceFeedConsumer_17 {
    IOracle_17 public oracle;

    constructor(address _oracle) { oracle = IOracle_17(_oracle); }

    // BUG: external call result not validated - oracle could fail silently
    function getPrice() external returns (int256 price) {
        price = oracle.latestAnswer();  // UNCHECKED - may return stale/zero
    }
}