// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Roulette {
    uint256 public pastBlockTime;

    constructor() payable {}

    function spin() external payable {
        require(msg.value == 10 ether); // must send 10 ether to play
        require(block.timestamp != pastBlockTime); // only 1 transaction per block

        pastBlockTime = block.timestamp;

        if (block.timestamp % 15 == 0) {
            (bool sent,) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}