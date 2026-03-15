// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract UncheckedStaticRead_111 {
    address public priceOracle;

    constructor(address _oracle) { priceOracle = _oracle; }

    // BUG: staticcall return value not checked
    function readPrice(bytes4 selector) external view returns (bytes memory result) {
        (bool ok, bytes memory data) = priceOracle.staticcall(
            abi.encodeWithSelector(selector)
        );
        // ok not checked - silent failure possible
        result = data;
    }
}