// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error RoyaltySetOfNonexistentToken();

contract ERC721KV1 is ERC721Upgradeable, OwnableUpgradeable, ERC2981Upgradeable{
    string baseURI;
    string public baseExtension;
    bytes32 public merkleRoot;
    bool public onlyAllowlisted;
    mapping(address => uint256) public userMintedAmount;
    uint256 public cost;
    uint256 public maxSupply;
    AggregatorV3Interface public priceFeed;

    // counter for tokenId
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    // initialize updatable in openzeppelin
    function initialize(address priceFeedAddress) public initializer {
        // initialize ERC721
        __ERC721_init("ERC721K", "ERK");
        // Ownable（generate onlyOwner）
        __Ownable_init();
        __ERC2981_init();

        onlyAllowlisted = false;
        cost = 10000;
        maxSupply = 5;
        baseExtension = ".json";

        // ETH / USD
        priceFeed = AggregatorV3Interface(
            priceFeedAddress
        );

        setBaseURI("ipfs://QmV5QLUos6RtouSeAh12LGJH6qNN4GJ3zME4jYBKMqu44x/");
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract.");
        _;
    }

    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        // for ETH / USD price is scaled up by 10 ** 8
        return price / 1e8;
    }

    function mint(uint256 _maxMintAmount, bytes32[] calldata _merkleProof) public payable callerIsUser {
        require(cost <= msg.value, "insufficient funds");
        uint256 maxMintAmountPerAddress;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        if(onlyAllowlisted == true) {
            //Merkle tree
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _maxMintAmount));
            require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not allowlisted");
            maxMintAmountPerAddress = _maxMintAmount;
        } else {
            maxMintAmountPerAddress = 5;
        }

        require(maxMintAmountPerAddress - userMintedAmount[msg.sender] > 0 , "max NFT per address exceeded");

        userMintedAmount[msg.sender] ++;

        _safeMint(msg.sender, newTokenId);
    }

    function transfer(address from, address to, uint256 tokenId) public {
        _transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        return string(abi.encodePacked(super.tokenURI(_tokenId), baseExtension));
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setOnlyAllowlisted(bool _state) public onlyOwner {
        onlyAllowlisted = _state;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Upgradeable, ERC2981Upgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setTokenRoyalty(
        uint256 tokenId,
        address recipient,
        uint96 value
    ) external {
        require(_exists(tokenId), "not minted token");
        // TODO role
        _setTokenRoyalty(tokenId, recipient, value);
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }
}
