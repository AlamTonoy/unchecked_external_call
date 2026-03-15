// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract EtherSplit_8 {
    address public partyA;
    address public partyB;
    bool public settled;

    constructor(address _a, address _b) {
        partyA = _a;
        partyB = _b;
    }

    // BUG: relies on address(this).balance for exact split
    // Force-feeding breaks the 50/50 assumption
    function settle() external {
        require(!settled, "Already settled");
        settled = true;
        uint256 half = address(this).balance / 2;
        payable(partyA).transfer(half);
        payable(partyB).transfer(address(this).balance);  // second gets remainder incl force-fed
    }

    receive() external payable {}
}