// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FindNextChallenge {
    mapping(address => bool) public called;
    bool public on;
    address public owner;

    constructor() {
        on = true;
        owner = msg.sender;
    }

    function callme(uint8 guess) public {
        require(on == true);
        uint8 answer = uint8(uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        if (answer == guess) {
            called[tx.origin] = true;
        } 
    }

    function setOn(bool param) public {
        require(msg.sender == owner);
        on = param;
    } 
}