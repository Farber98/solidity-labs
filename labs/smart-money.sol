//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

// Write a smart contract that allows for:
// Deposits from everyone.
// Withdraw all balance to the address that sent the tx.
// Withdraw all balance to given address (not necessarily the one that sent the tx).

contract SmartMoney {
    
    constructor() {
    }

    receive() external payable {
    
    }

    fallback() external payable {
    
    }

    function withdrawToSender() external payable {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawToAddress(address toAdd) external payable {
        payable(toAdd).transfer(address(this).balance);
    }

    function contractBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() external payable {
        payable(address(this)).transfer(msg.value);
    }

}
