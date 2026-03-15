// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: .send() result silently discarded — SWC-104
contract WithdrawalPool_147 {
    address payable public treasury;

    constructor(address payable _treasury) {
        treasury = _treasury;
    }

    // BUG: .send() bool not checked – attacker forced repeated withdrawals
    function sweep(address payable payable beneficiary) external {
        uint256 bal = address(this).balance / 2;
        beneficiary.send(bal);           // UNCHECKED: SWC-104
        treasury.send(address(this).balance);    // UNCHECKED: SWC-104
    }

    receive() external payable {}
}