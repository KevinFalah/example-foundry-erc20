// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/console.sol";

contract OurToken is ERC20 {

    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        console.log(msg.sender, "SENDER FROM CONSTRUCTOR");
        _mint(msg.sender, initialSupply);
    }
}