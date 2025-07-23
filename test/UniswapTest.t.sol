// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Uniswap} from "../src/Uniswap.sol";
import {cNGN} from "./mocks/cNGN.sol";
import {USDT} from "./mocks/USDt.sol";

contract UniswapTest is Test {
    cNGN public usdt;
    USDT public cngn;
    Uniswap public uniswap;
    address public user;

    uint256 private constant INITIAL_MINT_BALANCE = 100_000e18;
    uint256 private constant PRECISION = 1e18;

    function setUp() public {
        user = makeAddr("user");

        // Deploy mock tokens
        usdt = new cNGN(INITIAL_MINT_BALANCE);
        cngn = new USDT(INITIAL_MINT_BALANCE);

        // Deploy Uniswap pool
        uniswap = new Uniswap(address(cngn), address(usdt));

        // Mint tokens user
        usdt.transfer(user, 900e18);

        // Approve Uniswap to pull from this contract and user
        usdt.approve(address(uniswap), type(uint256).max);
        cngn.approve(address(uniswap), type(uint256).max);

        vm.prank(user);
        usdt.approve(address(uniswap), type(uint256).max);
        cngn.approve(address(uniswap), type(uint256).max);

        // Add initial liquidity: 100 USDT, 10 CNGN
        uniswap.addLiquidity(10e18, 100e18);
    }

    function testUserSwapsUSDTForCNGN() public {
        // Log the price of USDT to CNGN
        console.log("1 USDT ==", uniswap.getPriceInCngn() / PRECISION);
        console.log("1 CNGN ==", uniswap.getPriceInUsdt() / PRECISION);

        // Simulate user swapping 900 USDT for CNGN
        vm.prank(user);
        uniswap.swapUSDTForCNGN(900e18);

        // Log reserves after
        console.log("Price after swap of 1 USDT ==", uniswap.getPriceInCngn() / PRECISION);
        console.log("Price after swap of 1 CNGN ==", uniswap.getPriceInUsdt() / PRECISION);

        console.log("Final CNGN Reserves:", uniswap.cngnReserves() / PRECISION);
        console.log("Final USDT Reserves:", uniswap.usdtReserves() / PRECISION);
        console.log("User USDT Balance After:", usdt.balanceOf(user) / PRECISION);
        console.log("User CNGN Balance After:", cngn.balanceOf(user) / PRECISION);
    }
}
