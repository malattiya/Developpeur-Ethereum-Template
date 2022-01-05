// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat ArrayOfPerson
@author malattiya
*/
contract ArrayOfPerson {

    //struct Person (string, uint)
    struct Person {
        string name;
        uint age;
    }

    //Tableau dynamique de type Person
    Person[] public people;

    //Methode add pour ajouter une personne au tableau people 
    function add(string memory _name,uint  _age) public {
       Person memory person;
       person.name = _name;
       person.age= _age; 
       people.push(person);
    }

    //Methode remove pour supprimer la dernière personne du tableau people 
    function remove() public {
       people.pop();
    }
}