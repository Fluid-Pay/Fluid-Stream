// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IFluid} from "./interfaces/IFluid.sol";
import {Struct} from "./libraries/Struct.sol";
import {Helpers} from "./libraries/Helpers.sol";

contract Fluid is Ownable, ReentrancyGuard, IFluid {
    using SafeERC20 for IERC20;

    uint256 public nextStreamId;
    address public _feeRecipient;
    address public _autoClaimAccount;
    uint256 public _autoClaimFeeForOnce;


     /* =========== MAPPING ============ */


    mapping(address => bool) private _tokenAllowed;
    mapping(address => uint256) private _tokenFeeRate;
    mapping(uint256 => Struct.Stream) private _streams;



     /* =========== MODIFIERS ============ */
    modifier streamExists(uint256 streamId) {
        require(_streams[streamId].isEntity, "Stream does not exist");
        _;
    }

    modifier onlyStreamOwner(uint256 streamId) {
        require(msg.sender == _streams[streamId].sender, "Only the stream owner can call this function");
        _;
    }


     /* =========== EVENTS ============ */

    event TokenRegistered(address indexed tokenAddress, uint256 feeRate);
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
    event WithdrawFromStream(
        uint256 indexed streamId,
        address indexed operator,
        uint256 recipientBalance
    );
    event CloseStream(
        uint256 streamId,
        address indexed operator,
        uint256 recipientBalance,
        uint256 senderBalance
    );
    event PauseStream(
        uint256 indexed streamId,
        address indexed operator,
        bool paused
    );
    event ResumeStream(
        uint256 indexed streamId,
        address indexed operator,
        bool paused
    );
    event SetNewRecipient(
        uint256 streamId,
        address operator,
        address newRecipient
    );


     /* =========== Constructor ============ */

    constructor(
        address owner_,
        address feeRecipient_,
        address autoClaimAccount_,
        uint256 autoClaimFeeForOnce_
    ) Ownable(owner_) ReentrancyGuard() {
        transferOwnership(owner_);
        _feeRecipient = feeRecipient_;
        _autoClaimAccount = autoClaimAccount_;
        _autoClaimFeeForOnce = autoClaimFeeForOnce_;
        nextStreamId = 100000;
    }


     /* =========== VIEW FUNCTIONS ============ */

    function tokenFeeRate(
        address tokenAddress
    ) external view returns (uint256) {
        require(_tokenAllowed[tokenAddress], "Token not registered");
        return _tokenFeeRate[tokenAddress];
    }

    function autoClaimAccount() external view override returns (address) {
        return _autoClaimAccount;
    }

    function autoClaimFeeForOnce() external view override returns (uint256) {
        return _autoClaimFeeForOnce;
    }

    function feeRecipient() external view override returns (address) {
        return _feeRecipient;
    }

    function getStream(
        uint256 streamId
    ) external view override returns (Struct.Stream memory) {
        return _streams[streamId];
    }



     /* =========== MAIN FUNCTIONS ============ */

    function tokenRegister(
        address tokenAddress,
        uint256 feeRate
    ) public onlyOwner {
        require(!_tokenAllowed[tokenAddress], "Token already registered");
        _tokenAllowed[tokenAddress] = true;
        _tokenFeeRate[tokenAddress] = feeRate;
        emit TokenRegistered(tokenAddress, feeRate);
    }

    
  

    function deltaOf(uint256 streamId) public view streamExists(streamId) returns(uint256 delta){
         Struct.Stream memory stream = _streams[streamId];

         if(block.timestamp <  stream.startTime){
            return 0;
         }

         //calculate the time elapsed since the startTime 
         uint256 timeElapsed = block.timestamp - stream.startTime;

        //calculate the total duration of the stream 
        uint256 totalDuration = stream.stopTime - stream.startTime;


    // Calculate delta based on intervals
        if (timeElapsed > totalDuration) {
            delta = totalDuration / stream.interval;
        } else {
            delta = timeElapsed / stream.interval;
        }
        }


    // why is this function payable?
    // is there any internal storage variable tracking streamId
    function createStream(
    Struct.CreateStreamParams calldata createParams
) external payable  nonReentrant {
    require(_tokenAllowed[createParams.tokenAddress], "Token not registered");
    require(createParams.stopTime > createParams.startTime, "Stop time must be after start time");
    require(createParams.deposit > 0, "Deposit must be greater than 0");
    
    uint256 streamId = nextStreamId++;

    IERC20 token = IERC20(createParams.tokenAddress);

    //check if the sender has enough balance
    require(token.balanceOf(msg.sender) >= createParams.deposit ,"balance of the sender is  not enough");

    //transfer tokens to the contract 
    token.transferFrom(msg.sender, address(this), createParams.deposit);
    
        _streams[streamId] = Struct.Stream({
            sender: createParams.sender,
            recipient: createParams.recipient,
            deposit: createParams.deposit,
            tokenAddress: createParams.tokenAddress,
            startTime: createParams.startTime,
            stopTime: createParams.stopTime,
            interval: createParams.interval,
            cliffTime : createParams.cliffTime,
            cliffAmount: createParams.cliffAmount,
            cliffDone: false,
            autoClaimInterval: createParams.autoClaimInterval,
            createdAt: block.timestamp,
            autoClaim: createParams.autoClaim,
            isEntity : true,
            closed :false ,
            isPaused : false
         


            });
            

    emit CreateStream(
        streamId,
        msg.sender,
        createParams.recipient,
        createParams.deposit,
        createParams.tokenAddress,
        createParams.startTime,
        createParams.stopTime,
        createParams.interval,
        createParams.cliffAmount,
        createParams.cliffTime,
        createParams.autoClaimInterval,
        createParams.autoClaim
    );
}




    function pauseStream(uint256 streamId) public streamExists(streamId) onlyStreamOwner(streamId) {
        _streams[streamId].isPaused= true;
        emit PauseStream(
            streamId,
            msg.sender,
           true
        );
    }

    function resumeStream(uint256 streamId) public streamExists(streamId) onlyStreamOwner(streamId) {
        _streams[streamId].isPaused= false;
        emit ResumeStream(streamId, msg.sender, false);
    }

    function withdrawFromStream( uint256 streamId , uint256 amount  ) public streamExists(streamId) onlyStreamOwner(streamId) {
        Struct.Stream storage stream = _streams[streamId];
        require(!stream.isPaused,"Stream is paused");
        require(block.timestamp >= stream.startTime,"Stream has not started");       
        require(block.timestamp <= stream.stopTime,"Stream has ended");

       
        uint256 deltaIntervals = deltaOf(streamId); 

        uint256 withdrawableAmount = Helpers.calculateWithdrawableAmount(stream, deltaIntervals);

        require(amount <= withdrawableAmount, "Amount exceeds what can be withdrawn");

        // Update the stream's deposit
        stream.deposit -= amount;

        // Transfer tokens to the recipient
        IERC20(stream.tokenAddress).safeTransfer(stream.recipient, amount);
        
        // Update cliffDone if necessary
        if (block.timestamp >= stream.cliffTime && !stream.cliffDone) {
            stream.cliffDone = true;
        }

        emit WithdrawFromStream(streamId, msg.sender, amount);
        

    }



    function extendStream(
        uint256 streamId,
        uint256 newStopTime
    ) public streamExists(streamId) onlyStreamOwner(streamId) {
        _streams[streamId].stopTime = newStopTime;
    }


            
    function closeStream(uint256 streamId) public streamExists(streamId) onlyStreamOwner(streamId) {
        Struct.Stream storage stream = _streams[streamId];

        uint256 deltaIntervals = deltaOf(streamId);
        uint256 remainingAmount = Helpers.calculateRemainingAmount(stream, deltaIntervals);

        // why not deduct from deposit before sending as you did in withdrawal | closed streams do not hold any balance

        // Transfer remaining tokens to recipient
        IERC20(stream.tokenAddress).safeTransfer(stream.recipient, remainingAmount);

        // Reset stream
        stream.isEntity = false;
        // set CLosed to true
        emit CloseStream(streamId, msg.sender, remainingAmount, 0); // Assuming sender gets nothing on close

       
    }

    function setNewRecipient(
        uint256 streamId,
        address newRecipient
    ) public streamExists(streamId) onlyStreamOwner(streamId) {
        _streams[streamId].recipient = newRecipient;
        emit SetNewRecipient(streamId, msg.sender, newRecipient);
    }

    function setAutoClaimAccount(address newAutoClaimAccount) public onlyOwner {
        _autoClaimAccount = newAutoClaimAccount;
    }

    function setAutoFeeForOnce(uint256 newAutoFeeForOnce) public onlyOwner {
        _autoClaimFeeForOnce = newAutoFeeForOnce;
    }

    function streamInfo(uint256 streaId) external view returns(address, uint256){
        address sender = _streams[streaId].sender;
        uint256 deposited = _streams[streaId].deposit;

        return (sender, deposited);
    }

    function getPauseStatus(uint256 streaId) external view returns(bool status){
         status = _streams[streaId].isPaused;
    }

    function getStopTime(uint256 streaId) external view returns(uint stopTime){
        stopTime = _streams[streaId].stopTime;
    }

    function getStreamClose(uint256 streaId) external view returns(bool close, bool entity){
        close = _streams[streaId].closed;
        entity = _streams[streaId].isEntity;
    }
}