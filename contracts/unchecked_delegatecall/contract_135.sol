// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: user-controlled delegatecall target — SWC-112
contract AdminProxy_135 {
    mapping(bytes4 => address) public handlers;
    address public owner;

    constructor() { owner = msg.sender; }

    function setHandler(bytes4 sig, address impl) external {
        require(msg.sender == owner);
        handlers[sig] = impl;
    }

    // BUG: return not checked, attacker registered malicious handler
    function execute(bytes calldata data) external payable {
        address handler = handlers[bytes4(data[:4])];
        require(handler != address(0), "No handler");
        handler.delegatecall(data);  // UNCHECKED: SWC-112
    }
}