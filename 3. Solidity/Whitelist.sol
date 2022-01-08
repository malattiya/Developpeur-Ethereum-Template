// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/*
Contrat Whitelist
@author malattiya
*/
contract Whitelist {
    mapping (address=>bool) whitelist;

    event Authorized(address _address); // Event

    function authorize (address _address) public {
        whitelist[_address] = true; //add address in whitelist
        emit Authorized(_address); //raise event
    }
}