// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "./ERC721KV1.sol";

contract ERC721KV2 is ERC721KV1{
    // string private greetingV2 = "Hello, V2!";

    // // initialize updatable in openzeppelin
    // function initializeV2() public initializer {
    //     require(!initializedV2, "V2 has initialized");
    //     initializedV2 = true;
    //     greetingV2 = "Hello, V2!";
    // }

    function helloV2() public pure returns(string memory) {
        return "hello";
    }
}
