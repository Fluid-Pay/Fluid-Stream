// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;


import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract mockUSDC is ERC20 , ERC20Permit{
    constructor() ERC20("Mock USDC", "mockUSDC") ERC20Permit("mockUSDC"){
    _mint(_msgSender(), 1_000_000 * 1e18);
    }

}