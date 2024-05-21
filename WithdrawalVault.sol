// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NumberLib {
    uint public base;
    uint public currentNumber;

    //set the base
    function setBase(uint _base) public {
        base = _base;
    }

    //compute base + offset
    function getNumber(uint offset) public {
        currentNumber = base + offset;
    }
}

contract WithdrawalVault {
    address public numberLibrary; 
    
    // the current number to withdraw
    uint public currentNumber; 
    
    // the starting offset - zero initialized
    uint public offsetCounter; 
    
    // the function selector
    bytes4 constant seqSig = bytes4(keccak256("getNumber(uint256)"));

    address owner;

    // constructor - loads the contract with ether
    constructor(address _numberLibrary) payable {
        numberLibrary = _numberLibrary;
        owner = msg.sender;
    }

    //this function withdraws money 
    function withdraw() public {
        if(msg.sender == owner) {
            offsetCounter += 1;    
            (bool status,) = numberLibrary.delegatecall(abi.encodePacked(seqSig, offsetCounter));
            payable(msg.sender).transfer(currentNumber * 1 ether);
        }
    }
    
    // allow users to call other number library functions if necessary
    fallback() external {
        (bool status,) = numberLibrary.delegatecall(msg.data);
    }
}