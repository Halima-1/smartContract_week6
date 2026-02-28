// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;
import {MultiSig} from "../src/MultiSig.sol";

contract MultiSfactoryContract{
    address[] factoryInstances;

    function createMultiSigChild (address[] memory _signers, uint8 _required) external returns (address){
    MultiSig multiSig = new MultiSig(_signers, _required);
    factoryInstances.push(address(multiSig));
        return address(multiSig);

    }

    function getFactoryInstances() public view returns(address[] memory){
        return factoryInstances;
    }

}