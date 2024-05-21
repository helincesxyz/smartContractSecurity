// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FindMeChallenge {
    mapping(address => bool) public called;
    bool public on;
    address public owner;
    bytes32 answerHash = 0x8b73219eaab4833eb74d922f09161346d037946654ef1129e7854e8edb1df9a3;

    constructor() {
        on = true;
        owner = msg.sender;
    }

    function callme(uint8 guess) public {
        require(on == true);
        bytes memory guess_b = abi.encodePacked(guess);

        if (keccak256(guess_b) == answerHash) {
            called[msg.sender] = true;
        }
    }

    function setOn(bool param) public {
        require(msg.sender == owner);
        on = param;
    } 
}
