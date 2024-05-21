// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ReadMeChallenge {
    bytes32 answerHash;
    mapping(address => bool) public called;
    bool public on;
    address public owner;

    constructor() {
        on = true;
        owner = msg.sender;
        answerHash = keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp));
    }

    function callme(bytes32 guess) public {
        require(on == true);

        if (guess == answerHash) {
            called[msg.sender] = true;
        }
    }

    function setOn(bool param) public {
        require(msg.sender == owner);
        on = param;
    } 
}
