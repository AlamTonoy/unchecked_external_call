// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IOracle_107 {
    function latestAnswer() external returns (int256);
}

contract PriceFeedConsumer_107 {
    IOracle_107 public oracle;

    constructor(address _oracle) { oracle = IOracle_107(_oracle); }

    // BUG: external call result not validated - oracle could fail silently
    function getPrice() external returns (int256 price) {
        price = oracle.latestAnswer();  // UNCHECKED - may return stale/zero
    }
}