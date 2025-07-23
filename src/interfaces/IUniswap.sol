// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IUniswap
/// @notice interface of a Dex insipired from Uniswap (v1) 
interface IUniswap {
    /**
     * @notice Adds liquidity to the CNGN/USDT pool.
     * @param cngnAmount The amount of CNGN tokens to add.
     * @param usdtAmount The amount of USDT tokens to add.
     */
    function addLiquidity(uint256 cngnAmount, uint256 usdtAmount) external;

    /**
     * @notice Swaps a specified amount of CNGN tokens for USDT.
     * @param cngnAmountIn The amount of CNGN tokens to swap.
     */
    function swapCNGNForUSDT(uint256 cngnAmountIn) external;

    /**
     * @notice Swaps a specified amount of USDT tokens for CNGN.
     * @param usdtAmountIn The amount of USDT tokens to swap.
     */
    function swapUSDTForCNGN(uint256 usdtAmountIn) external;

    /**
     * @notice Calculates the output amount based on input amount and pool reserves.
     * @param amountIn The input token amount.
     * @param reserveIn The reserve of the input token.
     * @param reserveOut The reserve of the output token.
     * @return The output token amount.
     */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256);

    /**
     * @notice Returns the price of 1 CNGN in USDT, scaled by 1e18.
     * @return priceInUsdt The CNGN price in USDT.
     */
    function getPriceInUsdt() external view returns (uint256 priceInUsdt);

    /**
     * @notice Returns the price of 1 USDT in CNGN, scaled by 1e18.
     * @return priceInCngn The USDT price in CNGN.
     */
    function getPriceInCngn() external view returns (uint256 priceInCngn);
}
