// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BalanceReliant_6 {
    uint256 public constant ENTRY_FEE = 1 ether;

    // BUG: logic depends on exact address(this).balance which can be
    // manipulated via selfdestruct force-feeding ETH
    function join() external payable {
        require(msg.value == ENTRY_FEE, "Wrong fee");
        require(address(this).balance % ENTRY_FEE == 0, "Balance invariant broken");
        // Game logic that assumed balance is always a multiple of ENTRY_FEE
    }

    function prizePool() external view returns (uint256) {
        return address(this).balance;   // can be inflated by force-feed
    }
}