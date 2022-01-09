// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
 
/*
Contrat Choice
@author malattiya
*/
contract ERC20Token is ERC20  {  
    constructor(uint256 initialSupply) ERC20("ALYRA", "ALY") {
        _mint(msg.sender, initialSupply);
    }
}