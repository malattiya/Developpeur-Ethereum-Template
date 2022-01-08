// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat Time
@author malattiya
*/
contract Time {
    
    function getTime() view public returns (uint){
        return (block.timestamp);
    }
}