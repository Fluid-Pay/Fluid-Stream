// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IFluid} from "./interfaces/IFluid.sol";
import {Struct} from "./libraries/Struct.sol";


contract Stream is IFluid,Ownable,ReentrancyGuard
{
   using SafeERC20 for IERC20;


   /**
   * @notice counter for  new streamIDs
    */

    uint256 nextStreamId;

    address _feeRecipient;
    address _autoClaimAccount;
    uint256 _autoClaimFeeForOnce;


      /* ============ MAPPINGS ============ */

    mapping(address => bool) private _tokenAllowed;
    mapping (address => uint256) private _tokenFeeRate;

    mapping(uint256=> Struct.Stream) private _streams;



 /* ============ MODIFIERS============ */

/** 
 *@dev throw  if the proivided StreamId does not exists or its not valid
 */

modifier streamExists(uint256 streamId){
  require(_streams[streamId].isEntity,"stream does not exist");
  _;
}





     /* ============ EVENTS============ */
    
    /**
      *@notice emits when an token is registered sucessfully
     */

    event tokenRegister(address indexed tokenAddress , uint256 feeRate);

    /**
    *@notice emits when a new stream is created
     */
    event CreateStream(

        uint256 indexed streamId,
        address indexed sender,
        address indexed recipient,
        uint256 deposit,
        address tokenAddress,
        uint256 startTime,
        uint256 stopTime,
        uint256 interval,
        uint256 cliffAmount,
        uint256 cliffTime,
        uint256 autoClaimInterval,
        bool autoClaim
    ); 


    /**
    *@notice emits when  the recipient of  a stream withdraws from the stream
     */

     event WithdrawFromStream(
      uint256 indexed streamId,
      address indexed operator,
      uint256 recipientBalance
     );


    /**
    *@notice emits  when a stream is closed
     */
     event CloseStream(
      uint256 streamId,
      address indexed operator,
      uint256 recipientBalance,
      uint256 senderBalance
     );


     /**
        *@notice emits when a stream is paused
      */

      event PauseStream(
        uint256 indexed streamId,
        address indexed operator,
        uint256 recipientBalance
      );

      /**
        *@notice when a  stream is resumed
       */
       event ResumeStream(
        uint256 indexed streamId,
        address indexed operator,
        uint256 duration
       );


       /**
     * @notice Emits when the recipient of a stream is successfully changed.
     */
      event setNewRecipient(
        uint256 streamId,
        address  operator,
        uint256 newRecipient
      );


   /* =========== Constructor ============ */
  constructor(
    address owner_,
    address feeRecipient_,
    address autoClaimAccount_,
    uint256 autoClaimFeeForOnce_
  )Ownable(owner_) 
  ReentrancyGuard() {
    transferOwnership(owner_);
    _feeRecipient = feeRecipient_;
    _autoClaimAccount = autoClaimAccount_;
    _autoClaimFeeForOnce = autoClaimFeeForOnce_;
    nextStreamId = 100000;
  }





     
     
     /* =========== View Functions  ============ */

    function tokenFeeRate(address tokenAddress) external view override returns(uint256){
     require(_tokenAllowed[tokenAddres],"token not registered");
      return _tokenFeeRate[tokenAddress];

    }


     function  autoClaimAccount() external view override returns(address){
      return _autoClaimAccount;
     }


     function autoClaimFeeForOnce() external veiw override returns(uint256){
      return _autoClaimFeeForOnce;
     }
  


     function feeRecipient() external view override returns(address){
      return  _feeRecipient;
     }
  
 
     function getStream(uint256 streamId) external view override returns(Struct.Stream memory){
      return _streams[streamId];
     }
  

     /* =========== Main Functions  ============ */


      function tokenRegister(address tokenAddress, uint256 feeRate) public onlyOwner returns(){

      }


      function deltaOf();





      function balanceOf();


      function createStream();

      function pauseStream();


      function resumeStream();

      function withdrawFromStream();

      function extendStream();

      function closeStream();





     /* ==========  Setter Functions  ============ */


      function setNewRecipient();

      

      function setAutoClaimAccount();



      function setAutoFeeForOnce()

 

    

     


}


