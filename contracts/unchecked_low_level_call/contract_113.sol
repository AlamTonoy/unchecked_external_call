// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiForward_113 {
    address[] public recipients;

    function addRecipient(address r) external {
        recipients.push(r);
    }

    // BUG: none of the .call results are verified
    function broadcast() external payable {
        uint256 share = msg.value / recipients.length;
        for (uint i = 0; i < recipients.length; i++) {
            recipients[i].call{value: share}("");  // UNCHECKED
        }
    }
}