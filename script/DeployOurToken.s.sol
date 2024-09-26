// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {OurToken} from "src/OurToken.sol";

contract DeployOurToken is Script {
    uint256 public constant INTIAL_SUPPLY = 1000 ether;
    
    function run() external returns(OurToken) {
        vm.startBroadcast();
        OurToken ourToken = new OurToken(INTIAL_SUPPLY);
        vm.stopBroadcast();
        // console.log()
        return ourToken;
    }
}