//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

// In this project, you are going to implement a simple messenger functionality in a Smart Contract.
// Through the constructor make sure you write the address that deployed the contract to a variable
// Create a message-variable of the type string, that only the deployer-address can update
// Create a counter, to see how many times the variable was updated.

contract Messenger {

    address private owner;
    string public message;
    uint8 public counter;
    
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Sender not authorized.");
        _;
    }

    function updateMessage(string memory updatedMessage) public onlyOwner {
        message = updatedMessage;
        counter++;
    }
}


