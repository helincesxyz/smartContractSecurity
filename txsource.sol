// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint256 _amount) public {
        require(tx.origin == owner, "Not owner");
        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}
