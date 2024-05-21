// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract CallMeChallenge {
    mapping(address => bool) public called;
    bool public on;
    address public owner;

    constructor() {
        on = true;
        owner = msg.sender;
    }

    function callme() public {
        require(on == true);
        called[msg.sender] = true;
    }

    function setOn(bool param) public {
        require(msg.sender == owner);
        on = param;
    } 
}
