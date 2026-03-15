// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: miner coinbase reward forced ETH disrupted invariant — CWE-670
contract EthMilestone_131 {
    uint256 public lockedUntil;
    address public beneficiary;

    constructor(address _beneficiary, uint256 _lockDays) {
        beneficiary = _beneficiary;
        lockedUntil = block.timestamp + _lockDays * 1 days;
    }

    // BUG: balance check used as invariant — bypassed via forced ETH
    function release() external {
        require(block.timestamp >= lockedUntil, "Still locked");
        // Attacker forced extra ETH, doubling payout assumption
        payable(beneficiary).transfer(address(this).balance); // UNCHECKED: SWC-104
    }

    receive() external payable {
        // Only regular ETH captured here; selfdestruct bypasses this
    }
}