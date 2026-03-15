// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Historical exploit: unchecked delegatecall allowed storage manipulation — SWC-112
contract UpgradeableProxy_136 {
    address public implementation;
    address public admin;

    constructor(address _impl) {
        implementation = _impl;
        admin = msg.sender;
    }

    // BUG: delegatecall result not checked — exploited to hijack storage layout
    fallback() external payable {
        address impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            // result NEVER validated — SWC-112
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { } // silent failure — exploit vector
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}