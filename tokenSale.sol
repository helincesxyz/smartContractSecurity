pragma solidity ^0.5.0;

contract TokenSale {
    //can you increase your balance more than it needs to be
    mapping(address => uint256) public balanceOf;

    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() public payable {}

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        balanceOf[msg.sender] -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}

