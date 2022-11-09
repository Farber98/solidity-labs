// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/*  
    REQUIREMENTS:

    * We can give users tokens for beers
    * The user can spend the beer token in his own name, or give it to someone else.
    * Beer tokens get burned when the user gets his beer. 

*/


contract BeerToken is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event BeerPurchased(address indexed receiver, address indexed buyer);


    constructor() ERC20("BeerToken", "BEER") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount * 10 ** decimals());
    }

    function buyOneBeer() public {
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit BeerPurchased(_msgSender(), _msgSender());
    }

    function buyOneBeerFrom(address account) public {
        _spendAllowance(account, _msgSender(), 1 * 10 ** decimals());
        _burn(account, 1 * 10 ** decimals());
        emit BeerPurchased(_msgSender(), account);
    }
}
