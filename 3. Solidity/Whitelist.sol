// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat Whitelist
@author malattiya
*/
contract Whitelist {
    mapping (address=>bool) whitelist;

    event Authorized(address _address); // Event

    /*
    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
    */

    //structure Person (string, uint)
    struct Person {
        string name;
        uint age;
    }

    //Methode addPerson pour ajouter en memoire un struct 
    //
    function addPersonne(string memory _name,uint  _age) public pure {
       Person memory person;
       person.name = _name;
       person.age= _age; 
    }
}