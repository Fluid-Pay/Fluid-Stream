// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Struct.sol";

library Helpers {
    /**
     * @notice Calculates the amount that can be withdrawn from the stream at the current time.
     * @dev Takes into account cliff time, intervals, and whether the cliff has been reached.
     * @param stream The stream structure from which to calculate the withdrawable amount.
     * @param deltaIntervals The number of intervals that have passed.
     * @return withdrawableAmount The amount of tokens that can be withdrawn now.
     */
    function calculateWithdrawableAmount(Struct.Stream memory stream, uint256 deltaIntervals) internal view returns (uint256 withdrawableAmount) {
        if (block.timestamp < stream.startTime) {
            return 0; // Stream hasn't started yet
        }

        uint256 totalAmount = stream.deposit;
        
        // Check if cliff has passed
        if (block.timestamp < stream.cliffTime) {
            return 0; // Before cliff time, nothing can be withdrawn
        } else if (!stream.cliffDone) {
            // If cliff has just passed, allow withdrawal of cliff amount plus normal amount
            totalAmount = stream.cliffAmount + (stream.deposit - stream.cliffAmount);
            
        }

        uint256 elapsedIntervals = deltaIntervals;

        // Calculate how much can be withdrawn based on intervals passed
        if (stream.stopTime <= block.timestamp) {
            // If stream has ended, allow withdrawal of everything
            withdrawableAmount = totalAmount;
        } else {
            uint256 totalIntervals = (stream.stopTime - stream.startTime) / stream.interval;
            uint256 perIntervalAmount = (totalAmount - stream.cliffAmount) / totalIntervals; // Assuming cliff amount is not included in regular intervals
            withdrawableAmount = stream.cliffAmount + (perIntervalAmount * elapsedIntervals);
        }

        // Ensure withdrawable amount doesn't exceed total deposit
        withdrawableAmount = withdrawableAmount > stream.deposit ? stream.deposit : withdrawableAmount;
    }

    /**
     * @notice Calculates the amount left in the stream when it's being closed.
     * @dev This function determines what should be left for the recipient if the stream ends or is closed prematurely.
     * @param stream The stream structure to calculate remaining amount for.
     * @param deltaIntervals The number of intervals that have passed.
     * @return remainingAmount The amount of tokens left for the recipient.
     */
    function calculateRemainingAmount(Struct.Stream memory stream, uint256 deltaIntervals) internal view returns (uint256 remainingAmount) {
        uint256 withdrawableAmount = calculateWithdrawableAmount(stream, deltaIntervals);
        remainingAmount = withdrawableAmount;

        // If the stream hasn't ended or if there's still deposit left after withdrawal, adjust accordingly
        if (stream.stopTime > block.timestamp && withdrawableAmount < stream.deposit) {
          
            remainingAmount = stream.deposit;
        }

        // If we've passed the stop time but haven't withdrawn everything yet
        if (stream.stopTime <= block.timestamp && withdrawableAmount < stream.deposit) {
            remainingAmount = stream.deposit - withdrawableAmount;
        }
    }
}