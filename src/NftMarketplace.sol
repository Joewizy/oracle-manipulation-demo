// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IUniswap} from "./interfaces/IUniswap.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract NftMarketplace is ERC721 {
    IERC20 public cNGN;
    IUniswap public uniswap;

    uint256 private _tokenIdCounter;

    constructor(IERC20 _cNGN, IUniswap _uniswap) ERC721("JOE", "JOE") {
        cNGN = _cNGN;
        uniswap = _uniswap;
        _tokenIdCounter = 1;
    }

    // External functions
    function buyNftWithCngnToken(address to) public returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        uint256 priceOfNft = uniswap.getPriceInCngn();

        IERC20(cNGN).transferFrom(msg.sender, address(this), priceOfNft * 10);
        _tokenIdCounter++;
        _mint(to, tokenId);
        return tokenId;
    }

    function sellNftForCngnToken(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        uint256 priceOfNft = uniswap.getPriceInCngn();
        _burn(tokenId);
        IERC20(cNGN).transfer(msg.sender, priceOfNft * 10);
    }

    function mintNFT(address to) external returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _mint(to, tokenId);
        return tokenId;
    }

    function burnNFT(uint256 tokenId) external {
        _burn(tokenId);
    }

    // View functions
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
}
