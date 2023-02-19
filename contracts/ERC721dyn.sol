// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "hardhat/console.sol";
import "erc721a/contracts/ERC721A.sol";

contract ERC721dyn is ERC721A{
    string baseURI;
    string public baseExtension;

    constructor() ERC721A("ERC721dyn", "DYN")
    {
        console.log("constructor");
    }

    // function mint(address to, uint256 tokenId) public {
    //     _safeMint(to, tokenId, "");
    // }

    // function transfer(address from, address to, uint256 tokenId) public {
    //     _transfer(from, to, tokenId);
    // }

    // function burn(uint256 tokenId) public {
    //     _burn(tokenId);
    // }
}
