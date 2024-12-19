// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;



library Struct{


 struct Stream{

    address sender;
    address recipient;
    uint256 deposit;
    uint256 startTime;
    uint256 stopTime;
    address tokenAddress;
    uint256 interval;
    uint256 createAt;
    bool isEntity;
    bool closed;
    address onBehalfOf;

 }

 struct CreateStreamParams{
   address recipient;
   address sender;
   uint256 deposit;
   address tokenAdddress;
   uint256 startTime;
   uint256 stopTime;
   uint256 interval;
   uint256 cliffTime;
   uint256 cliffAmount;

}


}