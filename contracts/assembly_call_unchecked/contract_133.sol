// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: iszero check present but branch never reverts — SWC-104
contract GasOptimisedVault_133 {
    event TransferFailed(address indexed target, uint256 value);

    // BUG: iszero branch emits event but never reverts — attacker drained silently
    function bulkSend(address[] calldata targets, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < targets.length; i++) {
            address t = targets[i];
            uint256 v = amounts[i];
            assembly {
                let ok := call(21000, t, v, 0, 0, 0, 0)
                if iszero(ok) {
                    // missing: revert(0,0)   — exploit vector — SWC-104
                }
            }
        }
    }

    receive() external payable {}
}