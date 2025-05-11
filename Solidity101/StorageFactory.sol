// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

SimpleStorage[] public groupsOFSimpleStorage;

function deploy () public {
    SimpleStorage simpleStorage = new SimpleStorage();
    groupsOFSimpleStorage.push(simpleStorage);
}
function fsStore(uint256 index, uint256 myNum) public {
   //SimpleStorage myStorage = groupsOFSimpleStorage[index];  bikin variabel myStorage = array index
   groupsOFSimpleStorage[index].store(myNum); // manggil function store pada contract simple storage dan masukin my num ke index mystorage
}
function fsGet(uint256 index) public view returns(uint256){
    //SimpleStorage myStorage =  groupsOFSimpleStorage[index];  bikin variabel myStorage = array index
    return groupsOFSimpleStorage[index].retrieve(); // manggil function retrieve pada contract simple storage dan nampilin my num ke index mystorage
}
}



