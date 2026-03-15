// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract InlineAsmVault_9 {
    address public owner;

    constructor() { owner = msg.sender; }

    // BUG: return value of Yul call not validated
    function withdrawTo(address recipient, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        assembly {
            let success := call(gas(), recipient, amount, 0, 0, 0, 0)
            // success not used to conditionally revert
        }
    }

    receive() external payable {}
}