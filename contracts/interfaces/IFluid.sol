// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Struct} from "../libraries/Struct.sol";

/**
 * @title IFluid
 * @notice Interface for the Fluid contract
 */
interface IFluid  {
    /**
     * @notice Creates a new stream
     * @dev This function is payable to allow for initial funding of the stream
     * @param sender The address of the sender
     * @param recipient The address of the recipient
     * @param amount The amount of tokens to be streamed
     */
    function createStream(address sender, address recipient, uint256 amount) external payable;

    /**
     * @notice Withdraws funds from a stream
     * @param streamId The ID of the stream to withdraw from
     * @param amount The amount of tokens to withdraw
     */
    function withdrawFromStream(uint256 streamId, uint256 amount) external;

    /**
     * @notice Closes a stream
     * @param streamId The ID of the stream to close
     */
    function closeStream(uint256 streamId) external;

    /**
     * @notice Pauses a stream
     * @param streamId The ID of the stream to pause
     */
    function pauseStream(uint256 streamId) external;

    /**
     * @notice Resumes a stream
     * @param streamId The ID of the stream to resume
     */
    function resumeStream(uint256 streamId) external;

    /**
     * @notice Retrieves information about a stream
     * @param streamId The ID of the stream to retrieve information about
     * @return The stream information
     */
    function getStream(uint256 streamId) external view returns (Struct.Stream memory);

    /**
     * @notice Retrieves the recipient of fees
     * @return The address of the fee recipient
     */
    function feeRecipient() external view returns (address);

    /**
     * @notice Retrieves the account used for auto-claiming
     * @return The address of the auto-claim account
     */
    function autoClaimAccount() external view returns (address);

    /**
     * @notice Retrieves the fee for auto-claiming
     * @return The fee amount
     */
    function autoClaimFeeForOnce() external view returns (uint256);

    /**
     * @notice Retrieves the fee of the token
     * @param tokenAddress The address of the token
     * @return The fee amount
     */
    function tokenFeeRate(address tokenAddress) external view returns(uint256);

}