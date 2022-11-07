//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


/* Smart contract wallet. */

/* 

REQUIREMENTS: 

    1. The wallet has one owner
    2. The wallet should be able to receive funds, no matter what
    3. It is possible for the owner to spend funds on any kind of address, no matter if its a so-called Externally Owned Account (EOA - with a private key), or a Contract Address.
    4. It should be possible to allow certain people to spend up to a certain amount of funds.
    5. It should be possible to set the owner to a different address by a minimum of 3 guardians, in case funds are lost.

*/


contract ScWallet {

    uint constant votesForNewOwner = 3;

    address payable public owner;
    mapping(address => uint) public allowedFunds;
    mapping(address => bool) public allowedAdd;
    mapping(address => bool) public guardians;
    mapping(address => uint) public newOwnerVotes;
    mapping(address => bool) public guardianVoted;
    address [] private guardiansArr;



    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner.");
        _;
    }

    modifier onlyGuardianNotVoted {
        require(guardians[msg.sender] && !guardianVoted[msg.sender], "Only for guardians that didn't voted.");
        _;
    }

    modifier isAllowedOrIsOwner {
        require(msg.sender == owner || allowedAdd[msg.sender], "Address not allowed.");
        _;
    }

    modifier checkLimit {
        require(msg.sender == owner || allowedFunds[msg.sender] >= msg.value, "Limit reached.");
        _;
    }


    receive() external payable {

    }

    fallback() external payable {

    }

    function setGuardian(address guardian) external onlyOwner {
        guardians[guardian] = true;
        guardiansArr.push(guardian);
    }

    function resetGuardiansAddressesAndVotes() private {
        for (uint8 i=0; i< guardiansArr.length ; i++) {
            guardians[guardiansArr[i]] = false;
            guardianVoted[guardiansArr[i]] = false;
        }
    }

    function proposeNewOwner(address payable newOwner) external onlyGuardianNotVoted {
        newOwnerVotes[newOwner]++;
        guardianVoted[msg.sender] = true;

        if (newOwnerVotes[newOwner] == 3) {
            newOwnerVotes[newOwner] = 0;
            resetGuardiansAddressesAndVotes();
            owner = newOwner;
        }

    }

    function setAllowedFunds(address add, uint amount) external onlyOwner {
        require(allowedAdd[add],"Address not allowed.");
        allowedFunds[add] = amount;
        
        if(amount == 0) {
            allowedAdd[add] = false;
        }
    }

    function setAllowedAddress(address add) external {
        allowedAdd[add] = true;
    }

    function transfer(address payable toAdd, bytes memory payload) isAllowedOrIsOwner checkLimit external payable returns (bytes memory)  {
        allowedFunds[msg.sender] -= msg.value;
        (bool ok, bytes memory data) = toAdd.call{value: msg.value}(payload);
        require(ok, "Call not OK.");

        if(allowedFunds[msg.sender] == 0) {
            allowedAdd[msg.sender] = false;
        }

        return data;    
    }

}
