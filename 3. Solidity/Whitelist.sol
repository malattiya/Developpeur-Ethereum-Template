// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat Whitelist
@author malattiya
*/
contract Whitelist {
    mapping (address=>bool) whitelist;

    //structure Person (string, uint)
    struct Person {
        string name;
        uint age;
    }

    //Methode addPerson pour ajouter en memoire un struct 
    function addPersonne(string memory _name,uint  _age) public {
       Person memory person;
       person.name = _name;
       person.age= _age; 
    }
}