// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {HMS} from "../src/HMS.sol";

contract HMSScript is Script {
    HMS public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new HMS();

        vm.stopBroadcast();
    }
}
