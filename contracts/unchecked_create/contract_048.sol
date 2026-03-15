// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VaultDeployer_48 {
    mapping(address => address) public userVaults;

    // BUG: new returns address(0) on revert in constructor, not checked
    function deployVault() external {
        SimpleVault_48 vault = new SimpleVault_48(msg.sender);
        userVaults[msg.sender] = address(vault);  // could be address(0) if OOG
    }
}

contract SimpleVault_48 {
    address public owner;
    constructor(address _owner) { owner = _owner; }
    receive() external payable {}
}