# Fluid Smart Contract

A Solidity smart contract for managing token streaming with features like cliff vesting, auto-claiming, and stream management.

## Features

- Token streaming with customizable intervals
- Cliff vesting support
- Pause/resume functionality
- Auto-claim capability
- Stream ownership and recipient management
- Fee system for registered tokens

## Key Functions

- `createStream`: Create a new token stream with specified parameters
- `withdrawFromStream`: Withdraw available tokens from an active stream
- `pauseStream`/`resumeStream`: Pause and resume token streaming
- `closeStream`: Terminate a stream and settle remaining balances
- `extendStream`: Modify stream end time
- `setNewRecipient`: Update stream recipient

## Security Features

- ReentrancyGuard implementation
- Ownable access control
- SafeERC20 usage for token transfers
- Stream existence validation
- Owner-only stream management

## Requirements

- Solidity ^0.8.28
- OpenZeppelin contracts for:
  - Access control
  - Reentrancy protection
  - SafeERC20 operations

## Dependencies

- `@openzeppelin/contracts/access/Ownable.sol`
- `@openzeppelin/contracts/utils/ReentrancyGuard.sol`
- `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`
- `@openzeppelin/contracts/token/ERC20/IERC20.sol`
