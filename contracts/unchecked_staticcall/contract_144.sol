// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: failed staticcall treated as zero — SWC-104
contract MultiCallReader_144 {
    // BUG: staticcall failure not checked — zero result accepted as valid
    function getBalance(address token, address user) external view returns (uint256 bal) {
        (bool ok, bytes memory data) = token.staticcall(
            abi.encodeWithSignature("balanceOf(address)", user)
        );
        // ok NOT checked — SWC-104
        if (data.length >= 32) {
            bal = abi.decode(data, (uint256));
        }
        // if staticcall failed, bal == 0 — exploited to bypass balance checks
    }
}