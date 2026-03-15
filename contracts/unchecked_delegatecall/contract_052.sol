// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ILogic_52 {
    function execute(bytes calldata data) external returns (bool);
}

contract UpgradeableProxy_52 {
    address public logic;
    address public admin;

    constructor(address _logic) {
        logic = _logic;
        admin = msg.sender;
    }

    // BUG: bool result from delegatecall is discarded
    function relay(bytes calldata _data) external {
        (bool success,) = logic.delegatecall(_data);  // UNCHECKED: success ignored
    }
}