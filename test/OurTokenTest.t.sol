// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address public bobby = makeAddr("bobby");
    address public jax = makeAddr("jax");
    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant TRANSFER_AMOUNT = 10 ether;
    uint256 public constant APPROVAL_AMOUNT = 500 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bobby, STARTING_BALANCE);
    }

    function testUserOneBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bobby));
    }

    function testAllowancesWorks() public {
        uint256 initialSpending = 1000;

        // Bobby allow jax spenders tokens on her behalf
        vm.prank(bobby);
        ourToken.approve(jax, initialSpending);

        uint256 transferFrom = 500;
        vm.prank(jax);
        ourToken.transferFrom(bobby, jax, transferFrom);

        assertEq(ourToken.balanceOf(bobby), STARTING_BALANCE - transferFrom);
        assertEq(ourToken.balanceOf(jax), transferFrom);
    }

    // Test users can't mint additional tokens
    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    function testAllowance() public {
        uint256 initialSpending = 1000;

        // Bobby allow jax spenders tokens on her behalf
        vm.prank(bobby);
        ourToken.approve(jax, initialSpending);

        assertEq(ourToken.allowance(bobby, jax), initialSpending);
    }

    function testTransferBetweenUsers() public {
        uint256 balanceBefore = ourToken.balanceOf(jax);

        vm.prank(bobby);
        ourToken.transfer(jax, TRANSFER_AMOUNT);

        assertEq(ourToken.balanceOf(jax), balanceBefore + TRANSFER_AMOUNT);
    }
}
