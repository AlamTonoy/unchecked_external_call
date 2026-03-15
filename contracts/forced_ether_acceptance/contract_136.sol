// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: selfdestruct forced ETH bypassed milestone gate — CWE-670
contract EthMilestone_136 {
    uint256 public constant MILESTONE = 10 ether;
    bool public milestoneReached;
    address public owner;

    constructor() { owner = msg.sender; }

    // BUG: relies on balance == MILESTONE but selfdestruct bypasses receive()
    function checkMilestone() external {
        // Attacker used selfdestruct to push balance past MILESTONE
        if (address(this).balance >= MILESTONE) {
            milestoneReached = true;  // exploited — forced early unlock
        }
    }

    function withdraw() external {
        require(msg.sender == owner);
        require(milestoneReached, "Not reached");
        payable(owner).transfer(address(this).balance);
    }

    // receive() only catches regular sends — not selfdestruct
    receive() external payable {
        require(address(this).balance <= MILESTONE, "Milestone overflow");
    }
}