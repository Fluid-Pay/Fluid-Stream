// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {IERC20} from "../contracts/interfaces/IERC20.sol";
import {Fluid} from "../contracts/Fluid.sol";
import {Struct} from "../contracts/libraries/Struct.sol";
import {ERC20} from "./ERC20Mock.sol";

contract FluidTest is Test{
    Fluid fluid;

    ERC20 token;
    address receiver=address(0xabc);
    address autoClaimAcc= address(668);


    function setUp() public {
        fluid = new Fluid(address(this), receiver, autoClaimAcc, 1);
        token = new ERC20("TOKEN", "TKN", 18, 100e18);
    }

    function createStreamm() internal {
        token.mint(address(this), 100e18);
        fluid.tokenRegister(address(token),1);

       Struct.CreateStreamParams memory newStream = Struct.CreateStreamParams({
            recipient: receiver,
            sender: address(this),
            deposit: 40e18,
            tokenAddress: address(token),
            startTime: block.timestamp,
            stopTime: block.timestamp + 10 days,
            interval: 10 days,
            autoClaim: false,
            autoClaimInterval: 2 days,
            cliffTime: 5 days,
            cliffAmount: 20e18,
            cliffDone: false,
            createAt: block.timestamp,
            isEntity: true,
            isPaused: false,
            closed: false
        });

        fluid.createStream(newStream);
    }

    function testRegisterToken() public {
        fluid.tokenRegister(address(token),55);
        assertEq(fluid.tokenFeeRate(address(token)),55);
    }

    function testCreateStream() public {
        token.mint(address(this), 100e18);
        fluid.tokenRegister(address(token),1);

       Struct.CreateStreamParams memory newStream = Struct.CreateStreamParams({
            recipient: receiver,
            sender: address(this),
            deposit: 40e18,
            tokenAddress: address(token),
            startTime: block.timestamp,
            stopTime: block.timestamp + 10 days,
            interval: 10 days,
            autoClaim: false,
            autoClaimInterval: 2 days,
            cliffTime: 5 days,
            cliffAmount: 20e18,
            cliffDone: false,
            createAt: block.timestamp,
            isEntity: true,
            isPaused: false,
            closed: false
        });

        fluid.createStream(newStream);
        uint256 _streamid = fluid.nextStreamId()-1;
        (address _sender, uint256 _deposit) = fluid.streamInfo(_streamid);

        assertNotEq(_sender, address(0));
        assertEq(_deposit, 40e18);
    }

    function testPauseStream() public {
        createStreamm();

        uint256 _streamId = fluid.nextStreamId()-1;
        fluid.pauseStream(_streamId);

        assertTrue(fluid.getPauseStatus(_streamId));
    }

    function testResumeStream() public {
        ///// pausing the stream
        createStreamm();

        uint256 _streamId = fluid.nextStreamId()-1;
        fluid.pauseStream(_streamId);
        console2.log("Is stream paused? : ", fluid.getPauseStatus(_streamId));

        ///// unpausing the stream 
        fluid.resumeStream(_streamId);
        console2.log("Is stream paused? : ", fluid.getPauseStatus(_streamId));
        assertFalse(fluid.getPauseStatus(_streamId));
    }

    function testWithdrawStream() public {
        createStreamm();

        uint256 _streamId = fluid.nextStreamId()-1;

        vm.warp(8 days);
        
        fluid.withdrawFromStream(_streamId, 20e18);

        (,uint256 baldeposit)=fluid.streamInfo(_streamId);
        assertEq(baldeposit, 20e18);

        uint256 receiverBal = token.balanceOf(receiver);
        assertEq(receiverBal,20e18);
    }

    function testExtendStream() public {
        createStreamm();

        uint256 _streamId = fluid.nextStreamId()-1;

        fluid.extendStream(_streamId, 30 days);

        assertEq(fluid.getStopTime(_streamId), 30 days);
    }

    function testCloseStream() public {
        createStreamm();
        uint256 _streamId = fluid.nextStreamId()-1;

        fluid.closeStream(_streamId);

        (bool close, bool entity) = fluid.getStreamClose(_streamId);
        assertTrue(close);
        assertFalse(entity);

        uint256 balReceiver = token.balanceOf(receiver);
        assertEq(balReceiver,40e18);

    }

    function testChangeReceipient() public {
        createStreamm();
        address newReceipient = address(0xFFFF);
        uint256 _streamId = fluid.nextStreamId()-1;

        fluid.setNewRecipient(_streamId, newReceipient);

        address currentReceipient = fluid.getStream(_streamId).recipient;

        assertEq(currentReceipient, newReceipient);

    }
}