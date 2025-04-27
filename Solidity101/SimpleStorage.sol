// Types:

// boolean: true/false (default = false)
// uint: unsigned (+) whole numbers, up to 256 bits (default = uint256)
//       You can specify smaller sizes like uint128, uint64, etc.
// int: signed (+/-) whole numbers, same as uint but supports negatives
// string: a set of characters (text)
// address: a 20-byte value representing an Ethereum address
// bytes32: fixed-size (32 bytes) raw data (useful for hashes, identifiers, etc.)

// Visibility (for functions and variables):

// public: accessible from outside and inside the contract
//         - For variables: automatically creates a getter
// external: accessible only from outside the contract
// internal: accessible only inside the contract and by contracts that inherit from it
// private: accessible only within the current contract

// State Variable Visibility:

// public: same as above
// internal: same as above
// private: same as above

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// Contract name
contract SimpleStorage {
    // Declaring a state variable
    // type visibility name
    uint256 public FavoriteNumber; // default = 0

    // Function to store a number
    // function name (type1 param1, type2 param2, etc) visibility
    function store(uint256 _favoriteNumber) public virtual{
        FavoriteNumber = _favoriteNumber;
    }
    // (Changing the blockchain = no need to return)

    // View
    // - Can read state variables (global)
    // - Cannot write state variables
    // Pure
    // - Cannot read or write state variables
    // - Only works with function parameters and local variables

    // Function to retrieve the number
    // func name visibility view returns (type)
    function retrieve() public view returns (uint256) {
        return FavoriteNumber;
    }

    // Structs: Creating a new type
    struct Person {
        string name;
        uint256 personFavNum;
    }

    // Arrays
    // type[] visibility name;
    // Example (static array): uint256[] listOfFavoriteNumbers = [0, 78, 90];

    // Dynamic array of struct Person
    Person[] public listOfPeople;

    // Mapping
    // mapping (key => value) visibility name;
    // Like a dictionary: search key -> get value
    mapping(string => uint256) public nameToFavoriteNumber;

    // Memory, calldata, storage
    // Memory = temporary and editable (strings, arrays)
    // Calldata = temporary and read-only (function inputs that are not modified)
    // Storage = permanent
    // string, array, and struct → need memory or calldata
    // Outside function = storage by default
    // Inside function (parameters) = you must specify memory or calldata

    // Adding a new person
    function addPerson(string memory _name, uint256 _personFavNum) public {
        listOfPeople.push(Person(_name, _personFavNum));
        nameToFavoriteNumber[_name] = _personFavNum;
         }
    }
