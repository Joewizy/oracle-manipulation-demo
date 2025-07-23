// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title INftMarketplace
/// @notice Interface for interacting with a tokenized NFT marketplace that accepts cNGN tokens as payments for an NFT
interface INftMarketplace {
    /**
     * @notice Buys an NFT using cNGN tokens uses Uniswap for pricing.
     * @param to The recipient address to mint the NFT to.
     * @return tokenId The ID of the newly minted NFT.
     */
    function buyNftWithCngnToken(address to) external returns (uint256);

    /**
     * @notice Sells an owned NFT back to the contract and receives cNGN tokens in exchange.
     * @param tokenId The ID of the NFT being sold.
     */
    function sellNftForCngnToken(uint256 tokenId) external;

    /**
     * @notice Mints a new NFT to a specified address.
     * @param to The address to receive the NFT.
     * @return tokenId The ID of the minted NFT.
     */
    function mintNFT(address to) external returns (uint256);

    /**
     * @notice Burns a specific NFT (admin or owner function).
     * @param tokenId The ID of the NFT to burn.
     */
    function burnNFT(uint256 tokenId) external;

    /**
     * @notice Returns the total number of NFTs ever minted.
     * @return totalSupply The current token counter (note: includes burned tokens).
     */
    function totalSupply() external view returns (uint256);
}
