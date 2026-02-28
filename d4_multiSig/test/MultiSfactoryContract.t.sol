// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MultiSfactoryContract} from "../src/MultiSfactoryContract.sol";
import {MultiSig} from "../src/MultiSfactoryContract.sol";

contract MultiSfactoryContractTest is Test {
    MultiSfactoryContract public factory;
    MultiSig public multiSig;

    address internal ganiyat;
    address internal halima;
    address internal isaac;
    address internal feyi;


    function setUp() public{
        ganiyat = makeAddr("ganiyat");
        halima = makeAddr("halima");
        isaac = makeAddr("isaac");


        address[] memory signers = new address[](3);
        signers[0] = ganiyat;
        signers[1] = halima;
        signers[2] = isaac;

        uint8 requiredSigner =2;

        factory = new MultiSfactoryContract();
        address multisigChild = factory.createMultiSigChild(signers, requiredSigner);
        multiSig = MultiSig(payable(multisigChild));
        vm.deal(address(multiSig), 3 ether);
    }

    function test_submitTransaction() public{
        address _receiver = makeAddr ("receiver");
        uint256 _value = 1 ether;

        vm.prank(ganiyat);
        multiSig.submitTransaction(_receiver, _value);
        (uint value, address receiver, bool approved, uint id, address txnCreator, bool isExecuted, uint signerCount) =multiSig.transactions(0);
        assertEq(value, _value);
        assertEq(receiver, _receiver);
        assertEq(approved, false);
        assertEq(id, 1);
        assertEq(txnCreator, ganiyat);
        assertEq(isExecuted, false);
        assertEq(signerCount, 1);

    }

    function test_approveTransaction() public{
  address _receiver = makeAddr ("receiver");
    uint256 _value = 1 ether;

    vm.prank(ganiyat);
        multiSig.submitTransaction(_receiver, _value);
        (uint value, address receiver, bool approved, uint id, address txnCreator, bool isExecuted, uint signerCount) =multiSig.transactions(0);
        assertEq(value, _value);
        assertEq(receiver, _receiver);
        assertEq(approved, false);
        assertEq(id, 1);
        assertEq(txnCreator, ganiyat);
        assertEq(isExecuted, false);
        assertEq(signerCount, 1);

    vm.prank(isaac);
    multiSig.approveTnx(0);

        }

function test_cancelTransaction() public{
  address _receiver = makeAddr ("receiver");
    uint256 _value = 1 ether;

    vm.prank(ganiyat);
        multiSig.submitTransaction(_receiver, _value);
        (uint value, address receiver, bool approved, uint id, address txnCreator, bool isExecuted, uint signerCount) =multiSig.transactions(0);
        assertEq(value, _value);
        assertEq(receiver, _receiver);
        assertEq(approved, false);
        assertEq(id, 1);
        assertEq(txnCreator, ganiyat);
        assertEq(isExecuted, false);
        assertEq(signerCount, 1);

    vm.prank(ganiyat);
    multiSig.cancelTxn(0);

        }


    function test_getAllTransaction() public{
  address _receiver = makeAddr ("receiver");
    uint256 _value = 1 ether;

    vm.prank(ganiyat);
        multiSig.submitTransaction(_receiver, _value);
        (uint value, address receiver, bool approved, uint id, address txnCreator, bool isExecuted, uint signerCount) =multiSig.transactions(0);
        assertEq(value, _value);
        assertEq(receiver, _receiver);
        assertEq(approved, false);
        assertEq(id, 1);
        assertEq(txnCreator, ganiyat);
        assertEq(isExecuted, false);
        assertEq(signerCount, 1);

    vm.prank(isaac);
    multiSig.getAllTransactions();
        }
        

            function test_getAllSigners() public{
    vm.prank(isaac);
    multiSig.getAllTransactions();
        }

}
