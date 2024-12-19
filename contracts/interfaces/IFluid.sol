// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;


import {Struct} from "../libraries/Struct.sol";

interface IFluid{
    
    function createStream() external payable;


    function withdrawFromStream() external;


    function closeStream() external;



    function pauseStream() external;


    function resumeStream() external;



    function getStream(uint256 streamId)external view returns (Struct.Stream memory);

    function feeRecipient()  external view returns (address);


    function autoClaimAccount() external view returns(address);


    function autoClaimFeeForOnce() external view returns(uint256);

}