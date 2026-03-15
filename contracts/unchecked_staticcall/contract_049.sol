// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BalanceChecker_49 {
    // BUG: staticcall to check balance, success ignored
    function getTokenBalance(address token, address account)
        external view returns (uint256)
    {
        (bool success, bytes memory data) = token.staticcall(
            abi.encodeWithSignature("balanceOf(address)", account)
        );
        // success not checked; may return 0 on failure masking real balance
        if (data.length >= 32) return abi.decode(data, (uint256));
        return 0;
    }
}