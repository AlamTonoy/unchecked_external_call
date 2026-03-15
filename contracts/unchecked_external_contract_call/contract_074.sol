// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ICallback_74 {
    function onReceive(address from, uint256 amount) external;
}

contract CallbackDispatcher_74 {
    mapping(address => bool) public registered;

    function register() external { registered[msg.sender] = true; }

    // BUG: external call to unvalidated callback
    function dispatch(address target, address from, uint256 amount) external {
        require(registered[target], "Not registered");
        ICallback_74(target).onReceive(from, amount);  // UNCHECKED - can fail silently
    }
}