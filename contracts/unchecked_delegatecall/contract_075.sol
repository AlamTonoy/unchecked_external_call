// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract LibraryProxy_75 {
    address public lib;

    constructor(address _lib) { lib = _lib; }

    function callLib(bytes4 selector, bytes calldata args) external returns (bytes memory) {
        (bool ok, bytes memory ret) = lib.delegatecall(abi.encodePacked(selector, args));
        // BUG: 'ok' is not used to revert on failure
        return ret;
    }
}