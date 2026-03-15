// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VaultDeployer_123 {
    mapping(address => address) public userVaults;

    // BUG: new returns address(0) on revert in constructor, not checked
    function deployVault() external {
        SimpleVault_123 vault = new SimpleVault_123(msg.sender);
        userVaults[msg.sender] = address(vault);  // could be address(0) if OOG
    }
}

contract SimpleVault_123 {
    address public owner;
    constructor(address _owner) { owner = _owner; }
    receive() external payable {}
}