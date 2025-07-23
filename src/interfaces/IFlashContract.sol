// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/// @title IFlashContract
/// @notice Interface for interacting with a flash loan-enabled contract using Aave V3
interface IFlashContract {
    /**
     * @notice Requests a flash loan from the Aave V3 pool.
     * @param _token The address of the ERC20 token to borrow.
     * @param _amount The amount of the token to borrow.
     */
    function fn_RequestFlashLoan(address _token, uint256 _amount) external;

    /**
     * @notice This function is called by Aave after the contract receives the flash loan.
     *         You must implement your custom logic here (e.g., arbitrage, liquidation, manipulation).
     *         The loan plus premium must be repaid before this function ends.
     * @param asset The address of the borrowed token.
     * @param amount The amount of the token borrowed.
     * @param premium The fee to be paid back along with the borrowed amount.
     * @param initiator The address that initiated the flash loan.
     * @param params Extra parameters passed from the `flashLoanSimple` call.
     * @return Returns true if the operation is successful.
     */
    function executeOperation(address asset, uint256 amount, uint256 premium, address initiator, bytes calldata params)
        external
        returns (bool);
}
