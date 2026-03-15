// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract GasOptimizedSender_100 {
    // BUG: attempts gas-optimized send via assembly but skips return check
    function sendValue(address payable recipient, uint256 weiAmount) external {
        assembly {
            // Solidity's Address.sendValue pattern WITHOUT the require check
            let success := call(gas(), recipient, weiAmount, 0, 0, 0, 0)
            // Deliberately omitting: if iszero(success) { revert(0, 0) }
        }
    }

    receive() external payable {}
}