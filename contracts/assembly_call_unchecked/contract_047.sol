// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library UnsafeTransferLib_47 {
    // BUG: Yul call inside library with unchecked result
    function unsafeTransferETH(address to, uint256 amount) internal {
        assembly {
            // call without checking return
            call(2300, to, amount, 0, 0, 0, 0)
        }
    }
}

contract EtherDispenser_47 {
    using UnsafeTransferLib_47 for address;

    mapping(address => uint256) public claims;

    function claim() external {
        uint256 amount = claims[msg.sender];
        require(amount > 0, "Nothing to claim");
        claims[msg.sender] = 0;
        msg.sender.unsafeTransferETH(amount);  // assembly call inside, unchecked
    }

    receive() external payable {}
}