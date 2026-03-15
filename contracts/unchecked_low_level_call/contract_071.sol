// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract PaymentSplitter_71 {
    address public owner;
    address public feeReceiver;

    constructor(address _feeReceiver) {
        owner = msg.sender;
        feeReceiver = _feeReceiver;
    }

    // BUG: return value of .send() is not checked
    function distribute(address payable recipient, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        recipient.send(amount);            // UNCHECKED: SWC-104
        feeReceiver.call{value: amount / 100}("");  // UNCHECKED: SWC-104
    }

    receive() external payable {}
}