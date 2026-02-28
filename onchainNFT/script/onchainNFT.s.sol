// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {onchainNFT} from "../src/onchainNFT.sol";

contract onchainNFTScript is Script {
    onchainNFT public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new onchainNFT();

        vm.stopBroadcast();
    }
}
