// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MilestoneContract_89 {
    uint256 public milestone = 10 ether;
    bool public reached;

    // BUG: milestone check uses balance which can be bypassed by coinbase/selfdestruct
    function checkMilestone() external {
        if (address(this).balance >= milestone) {
            reached = true;
            // Releases locked funds or triggers next phase
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    receive() external payable {}
}