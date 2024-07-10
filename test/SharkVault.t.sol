// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import the necessary libraries and contracts
import {Test, console} from "forge-std/Test.sol";
import "../contracts_/SharkVault.sol";
import "../contracts_/Attack.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TestSharkVault is Test {
    // Declare the SharkVault contract instance
    SharkVault sharkVault;
    address gold;
    address seaGold;
    Attack attack;

    address user = makeAddr("user");
    // Set up the contract instance before each test
    function setUp() public {
        sharkVault = SharkVault(0xdD88C9B924824f0e21DaFe866B11a24D393992D1);
        vm.label(address(sharkVault), "SharkVault");
        gold = address(sharkVault.gold());
        vm.label(address(gold), "Gold");
        seaGold = address(sharkVault.seagold());
        vm.label(address(seaGold), "SeaGold");
        attack = new Attack();
        vm.label(address(attack), "Attack");
    }

    // Write your tests here
    function testAttack() public {
        attack.attack();
        assertEq(IERC20(seaGold).balanceOf(address(attack)), 3000e18);
        assertEq(IERC20(seaGold).balanceOf(address(sharkVault)), 0);
    }

    // ...
}

