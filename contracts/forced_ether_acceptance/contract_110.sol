// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract FlashLoanGuard_110 {
    uint256 private _balanceBefore;

    modifier noFlashLoan() {
        _balanceBefore = address(this).balance;
        _;
        // BUG: force-fed ETH makes this check unreliable
        require(address(this).balance >= _balanceBefore, "Balance decreased");
    }

    function sensitiveOp() external noFlashLoan {
        // Critical operation relying on ETH balance guard
    }

    receive() external payable {}
}