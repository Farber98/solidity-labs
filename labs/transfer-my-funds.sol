//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

// Track different wallet funds.
// A wallet should only be able to withdraw their funds to any address.
// Checks Effect Interaction Pattern to prevent Reentrancy Attack. 

contract WalletFunds {

    mapping(address => uint) public walletsBalanceMap;

    modifier enoughFunds {
        require(walletsBalanceMap[msg.sender] >= msg.value, "Not enough funds.");
        _;
    }

    function getWalletBalance() public view returns(uint) {
        return walletsBalanceMap[msg.sender];
    }

    function deposit() public payable {
        walletsBalanceMap[msg.sender] += msg.value;
    }

    function withdrawToGivenAddress(address payable toAdd) public payable enoughFunds {
        walletsBalanceMap[msg.sender] -= msg.value;
        toAdd.transfer(msg.value);
    }

}
