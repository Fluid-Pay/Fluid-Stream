// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IFluid} from "./interfaces/IFluid.sol";
import {Struct} from "./libraries/Struct.sol";

contract Fluid is Ownable, ReentrancyGuard, IFluid {
    using SafeERC20 for IERC20;

    uint256 public nextStreamId;
    address public _feeRecipient;
    address public _autoClaimAccount;
    uint256 public _autoClaimFeeForOnce;

    mapping(address => bool) private _tokenAllowed;
    mapping(address => uint256) private _tokenFeeRate;
    mapping(uint256 => Struct.Stream) private _streams;

    modifier streamExists(uint256 streamId) {
        require(_streams[streamId].isEntity, "Stream does not exist");
        _;
    }

    modifier onlyStreamOwner(uint256 streamId) {
        require(msg.sender == _streams[streamId].sender, "Only the stream owner can call this function");
        _;
    }

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

    function tokenRegister(
        address tokenAddress,
        uint256 feeRate
    ) public onlyOwner {
        require(!_tokenAllowed[tokenAddress], "Token already registered");
        _tokenAllowed[tokenAddress] = true;
        _tokenFeeRate[tokenAddress] = feeRate;
        emit TokenRegistered(tokenAddress, feeRate);
    }

    function createStream(
    Struct.CreateStreamParams calldata createParams
) external payable  nonReentrant {
    require(_tokenAllowed[createParams.tokenAddress], "Token not registered");
    uint256 streamId = nextStreamId++;
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

            // to be implemented
    function withdrawFromStream(
        uint256 streamId , uint256 amount
    ) public streamExists(streamId) onlyStreamOwner(streamId) {
        // uint256 recipientBalance = _streams[streamId].recipientBalance;
        // _streams[streamId].recipientBalance = 0;
        // emit WithdrawFromStream(streamId, msg.sender, recipientBalance);
    }

    function extendStream(
        uint256 streamId,
        uint256 newStopTime
    ) public streamExists(streamId) onlyStreamOwner(streamId) {
        _streams[streamId].stopTime = newStopTime;
    }


            
    function closeStream(uint256 streamId) public streamExists(streamId) onlyStreamOwner(streamId) {
        // uint256 recipientBalance = _streams[streamId].recipientBalance;
        // uint256 senderBalance = _streams[streamId].senderBalance;
        // _streams[streamId].isEntity = false;
        // emit CloseStream(streamId, msg.sender, recipientBalance, senderBalance);
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
}