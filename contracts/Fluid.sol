// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IFluid} from "./interfaces/IFluid.sol";


contract Stream is IFluid,Ownable,ReentrancyGuard
{

   /**
   * @notice counter for  new streamIDs
    */

    uint256 nextStreamId;

    address _feeRecipient;
    address _autoWithdrawAccount;
    uint256 _autoWithdrawFeeForOnce;


      /* ============ MAPPINGS ============ */

    mapping(address => bool) private _tokenAllowed;
    mapping (address => uint256) private _tokenFeeRate;

    mapping(uint256=> Struct.Stream) private _streams;





       /* ============ EVENTS============ */

       event 


   /* =========== Constructor ============ */
  constructor(
    address owner_,
    address feeRecipient_,
    address autoWithdrawAccount_,
    uint256 autoWithdrawFeeForOnce_
  )Ownable(owner_) 
  ReentrancyGuard() {
    transferOwnership(owner_);
    _feeRecipient = feeRecipient_;
    _autoWithdrawAccount = autoWithdrawAccount_;
    _autoWithdrawFeeForOnce = autoWithdrawFeeForOnce_
    nextStreamId = 100000;
  }

     /* =========== View Functions  ============ */

    function tokenFeeRate(address tokenAddress) external view override returns(uint256){
     require(_tokenAllowed[tokenAddres],"token not registered");
      returns _tokenFeeRate[tokenAddress];

    }


     function  autoWithdrawAccount() external view override returns(address){
      return _autoWithdrawAccount;
     }


     function autowithdrawFeeForOnce() external veiw override returns(uint256){
      return _autoWithdrawFeeForOnce;
     }
  


     function feeRecipient() external view override returns(address){
      return  _feeRecipient;
     }
  

     function getStream(uint256 streamId) external view override returns(Struct.Stream memory){
      returns _streams[Struct.Stream];
     }




}


