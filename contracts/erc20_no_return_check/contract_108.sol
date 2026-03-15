// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ILegacyToken_108 {
    function transfer(address _to, uint256 _value) external returns (bool success);
}

contract TokenVesting_108 {
    ILegacyToken_108 public token;
    mapping(address => uint256) public vested;

    constructor(address _token) { token = ILegacyToken_108(_token); }

    // BUG: bool from transfer discarded; beneficiary may not receive tokens
    function claim(uint256 amount) external {
        require(vested[msg.sender] >= amount, "Not enough vested");
        vested[msg.sender] -= amount;
        token.transfer(msg.sender, amount);  // RETURN VALUE IGNORED
    }
}