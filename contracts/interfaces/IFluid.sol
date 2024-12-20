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
     */
    function createStream() external payable;

    /**
     * @notice Withdraws funds from a stream
     */
    function withdrawFromStream() external;

    /**
     * @notice Closes a stream
     */
    function closeStream() external;

    /**
     * @notice Pauses a stream
     */
    function pauseStream() external;

    /**
     * @notice Resumes a stream
     */
    function resumeStream() external;

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
     * @return The fee amount
     */
    function tokenFeeRate(address tokenAddress, uint256 feeRate) external view returns(uint256);

}