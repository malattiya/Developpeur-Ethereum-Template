// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat HelloWorld
@author malattiya
*/
contract HelloWorld {
    string str = "Hello World !";

    function hello() public view returns (string memory) {
        return str;
    }
}
