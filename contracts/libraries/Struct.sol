// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

library Struct {

    /**
     *@notice  Represents a stream of funds.
     */
    struct Stream {
        address sender;
        address recipient;
        uint256 deposit;
        uint256 startTime;
        uint256 stopTime;
        address tokenAddress;
        uint256 interval;
        uint256 createdAt;
        bool isEntity;
        bool closed;
        address onBehalfOf;
        bool autoClaim;
    }

    /**
     * @notice Parameters for creating a new stream.
     */
    struct CreateStreamParams {
        address recipient;
        address sender;
        uint256 deposit;
        address tokenAddress;
        uint256 startTime;
        uint256 stopTime;
        uint256 interval;
        uint256 cliffTime;
        uint256 cliffAmount;
    }
}