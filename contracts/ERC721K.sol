// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/metatx/MinimalForwarder.sol";
// import "./MinimalForwarderK.sol";

contract ERC721K is ERC721, ERC2771Context{
    constructor(MinimalForwarder forwarder) ERC721("ERC721K", "ERK")
        ERC2771Context(address(forwarder))
    {
        console.log("forwarder:", address(forwarder));
    }

    function hoge() public view returns (string memory) {
        console.log("fuga");
        return "hoge";
    }

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId, "");
    }

    function transfer(address from, address to, uint256 tokenId) public {
        _transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    // TODO Context?
    function _msgSender()
        internal
        view
        override(Context, ERC2771Context)
        returns (address sender)
    {
        return ERC2771Context._msgSender();
    }

    function _msgData()
        internal
        view
        override(Context, ERC2771Context)
        returns (bytes calldata)
    {
        return ERC2771Context._msgData();
    }
}
