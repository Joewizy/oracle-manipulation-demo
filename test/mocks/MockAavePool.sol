// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockAavePool {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoanSimple(
        address receiver,
        address asset,
        uint256 amount,
        bytes calldata params,
        uint16 referralCode
    ) external {
        uint256 fee = (amount * 9) / 10000; // 0.09% fee
        token.transfer(receiver, amount);
        (bool success,) = receiver.call(
            abi.encodeWithSignature(
                "executeOperation(address,uint256,uint256,address,bytes)", asset, amount, fee, msg.sender, params
            )
        );
        require(success, "Flash loan execution failed");
        require(token.transferFrom(receiver, address(this), amount + fee), "Repayment failed");
    }

    // Add this function to satisfy IPoolAddressesProvider
    function getPool() external view returns (address) {
        return address(this);
    }
}
