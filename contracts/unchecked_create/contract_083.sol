// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VaultDeployer_83 {
    mapping(address => address) public userVaults;

    // BUG: new returns address(0) on revert in constructor, not checked
    function deployVault() external {
        SimpleVault_83 vault = new SimpleVault_83(msg.sender);
        userVaults[msg.sender] = address(vault);  // could be address(0) if OOG
    }
}

contract SimpleVault_83 {
    address public owner;
    constructor(address _owner) { owner = _owner; }
    receive() external payable {}
}