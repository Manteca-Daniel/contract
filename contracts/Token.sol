// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title NFT Contract with Custom Authorization
contract NFT is ERC721, Ownable {
    /// @notice Struct to store additional data for each token
    struct TokenData {
        address authorized;
        uint256 orderId;
    }

    mapping(uint256 => TokenData) private tokenData;
    mapping(uint256 => string) private metadataURI;

    event AuthorizationTransferred(uint256 orderId, uint256 tokenId, address newAuthorized);
    event TokenBurned(uint256 tokenId);

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC721(name, symbol)
        Ownable(initialOwner)
    {}

    function mint(address to, uint256 tokenId, uint256 orderId, string memory metadataUrl) public onlyOwner {
        _mint(to, tokenId);
        tokenData[tokenId] = TokenData({authorized: to, orderId: orderId});
        metadataURI[tokenId] = metadataUrl;
    }

    function transferAuthorization(uint256 tokenId, address newAuthorized) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");
        tokenData[tokenId].authorized = newAuthorized;
        emit AuthorizationTransferred(tokenData[tokenId].orderId, tokenId, newAuthorized);
    }

    function burnToken(uint256 tokenId) public {
        require(
            msg.sender == ownerOf(tokenId) || msg.sender == tokenData[tokenId].authorized,
            "Caller is not authorized"
        );
        _burn(tokenId);
        delete tokenData[tokenId];
        emit TokenBurned(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        return metadataURI[tokenId];
    }

    function getAuthorized(uint256 tokenId) public view returns (address) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        return tokenData[tokenId].authorized;
    }
}