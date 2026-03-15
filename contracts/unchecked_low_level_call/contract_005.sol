// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract TipJar_5 {
    event TipSent(address indexed from, address indexed to, uint256 amount);

    // BUG: .send not checked
    function tip(address payable creator) external payable {
        require(msg.value > 0, "Zero tip");
        bool ok = creator.send(msg.value);  // RESULT IGNORED after this line
        emit TipSent(msg.sender, creator, msg.value);
        // ok is declared but never used for require/revert
        _ = ok;
    }
}