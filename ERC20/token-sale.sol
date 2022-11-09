//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

interface IERC20 {
    function transferFrom(address from, address to, uint amount) external;
    function decimals() external view returns(uint);
}


/*  
    REQUIREMENTS:

    * Use the BeerToken created.
    * Let another contract take control of some of the tokens through an allowance functionality. 

*/

contract BeerTokenSale {
    uint unitaryPrice = 1 ether;

    IERC20 token;
    address public tokenOwner;

    constructor(address _token) {
        tokenOwner = msg.sender;
        token = IERC20(_token);
    }

    modifier notEnough {
        require(msg.value >= unitaryPrice, "Not enough money sent");
        _;
    }

    function purchaseBeer() public payable notEnough {
        uint tokensBought = msg.value / unitaryPrice;
        uint remainder = msg.value - tokensBought * unitaryPrice;
        token.transferFrom(tokenOwner, msg.sender, tokensBought * 10 ** token.decimals());
        payable(msg.sender).transfer(remainder);
    }
}
