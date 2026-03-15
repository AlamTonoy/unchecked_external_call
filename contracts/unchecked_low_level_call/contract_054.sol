// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract EmergencyDrain_54 {
    address public admin;
    bool public stopped;

    constructor() { admin = msg.sender; }

    function stop() external { require(msg.sender == admin); stopped = true; }

    // BUG: unchecked low-level call
    function drain(address payable to) external {
        require(msg.sender == admin && stopped, "Not allowed");
        to.call{value: address(this).balance}("");  // UNCHECKED
    }

    receive() external payable {}
}