// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Attack} from "../contracts_/Attack.sol";

contract AttackScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        Attack newAttack = new Attack();
        newAttack.attack();
    }
}