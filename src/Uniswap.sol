// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IUniswap} from "./interfaces/IUniswap.sol";

contract Uniswap is IUniswap {
    IERC20 public cngnToken;
    IERC20 public usdtToken;

    uint256 public cngnReserves;
    uint256 public usdtReserves;
    uint256 private constant PRECISION = 1e18;

    constructor(address _cngnToken, address _usdtToken) {
        cngnToken = IERC20(_cngnToken);
        usdtToken = IERC20(_usdtToken);
    }

    function addLiquidity(uint256 cngnAmount, uint256 usdtAmount) external {
        require(cngnAmount > 0 && usdtAmount > 0, "Amounts must be greater than 0");

        cngnReserves += cngnAmount;
        usdtReserves += usdtAmount;

        cngnToken.transferFrom(msg.sender, address(this), cngnAmount);
        usdtToken.transferFrom(msg.sender, address(this), usdtAmount);
    }

    function swapCNGNForUSDT(uint256 cngnAmountIn) external {
        uint256 usdtAmountOut = getAmountOut(cngnAmountIn, cngnReserves, usdtReserves);

        require(cngnToken.transferFrom(msg.sender, address(this), cngnAmountIn), "Transfer failed");
        require(usdtToken.transfer(msg.sender, usdtAmountOut), "Transfer failed");

        cngnReserves += cngnAmountIn;
        usdtReserves -= usdtAmountOut;
    }

    function swapUSDTForCNGN(uint256 usdtAmountIn) external {
        uint256 cngnAmountOut = getAmountOut(usdtAmountIn, usdtReserves, cngnReserves);

        require(usdtToken.transferFrom(msg.sender, address(this), usdtAmountIn), "Transfer failed");
        require(cngnToken.transfer(msg.sender, cngnAmountOut), "Transfer failed");

        usdtReserves += usdtAmountIn;
        cngnReserves -= cngnAmountOut;
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        require(amountIn > 0, "Amounts must be greater than 0");
        require(reserveIn > 0 && reserveOut > 0, "Invalid reserves");

        // x * y = k --> (x + dx) * (y - dy) = k
        return (amountIn * reserveOut) / (reserveIn + amountIn);
    }

    function getPriceInUsdt() public view returns (uint256 priceInUsdt) {
        require(usdtReserves > 0, "No USDT liquidity");
        priceInUsdt = (cngnReserves * PRECISION) / usdtReserves;
    }

    function getPriceInCngn() public view returns (uint256 priceInCngn) {
        require(cngnReserves > 0, "No CNGN liquidity");
        priceInCngn = (usdtReserves * PRECISION) / cngnReserves;
    }
}
