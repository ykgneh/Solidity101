// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {SimpleStorage} from "./SimpleStorage.sol";

contract AddSix is SimpleStorage {

    //same function name + overide (child)
    //same function name + virtual (parent)
    function store(uint256 _added) public override  {
      FavoriteNumber = _added + 6;
    }
        
}