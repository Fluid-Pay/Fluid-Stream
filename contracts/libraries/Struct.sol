// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

library Struct {

    /**
     *@notice Defines the roles an operator can have in relation to a stream.
   */
    // enum StreamOperatorRole {
    //     None,       
    //     Sender,
    //     Recipient,
    //     Both
    // }

    /**
     * @notice Defines the settings for stream features, including who can pause, close, or modify the recipient of a stream.
     */
    // struct StreamFeature {
    //     StreamOperatorRole pauseable;
    //     StreamOperatorRole closeable;
    //     StreamOperatorRole recipientModifiable;
    // }

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
        bool autoClaim;
        // StreamFeature features;
        uint256 cliffTime;
        uint256 cliffAmount;
        bool cliffDone;
        bool isPaused;
        uint256 autoClaimInterval;

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
        bool autoClaim;
        uint256 autoClaimInterval;
        // StreamFeature features;
        uint256 cliffTime;
        uint256 cliffAmount;
        bool cliffDone;
        uint256 createAt;
        bool isEntity;
        bool isPaused;
        bool closed;
    
    }

    // struct CliffInfo{
    //     uint256 cliffTime;
    //     uint256 cliffAmount;
    //     bool cliffDone;
    // }
}