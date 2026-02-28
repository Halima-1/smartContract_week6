// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

contract multiSig_wallet {
    address[] public owners;
    uint required;

    struct Transaction {
        address to;
        uint value;
        bool approve;
    }

    Transaction[] transactions;

    constructor(
        address signer_one,
        address signer_two,
        address signer_three,
        uint _required
    ) payable{
        owners.push(signer_one);
        owners.push(signer_two);
        owners.push(signer_three);
        required = _required;

        //   require(owners.length ==3, "3 signers are required");
    }

    mapping(uint => mapping(address => bool)) public confirmations;
    mapping(address => uint) balances;

    modifier onlySigners() {
        for (uint i; i < owners.length; i++) {
            require(msg.sender == owners[i], "Not a signer");

            _;
        }
    }

    function submitTransaction(address _to, uint _value) public {
        bool ownerFound;
        for (uint i; i < owners.length; i++) {
            // require(msg.sender == owners[i], "Not a signer");
            if (msg.sender == owners[i]) ownerFound = true;
        }
        require(ownerFound == true, "Not a signer i");
        // Transaction[] memory transaction = Transaction({to:_to, value: _value, approve:false});
        transactions.push(Transaction(_to, _value, false));
        confirmations[transactions.length - 1][msg.sender] = true;
    }

    function confirmDeposit(uint _txIndex) public {
        bool ownerFound = false;
        uint confirms = 0;
        for (uint i; i < owners.length; i++) {
            if (msg.sender == owners[i]) {
                ownerFound = true;
                confirmations[_txIndex][msg.sender] = true;
            }
            if (confirmations[_txIndex][owners[i]] == true) confirms++;
        }
        require(ownerFound == true, "Not an owner");
        if (confirms >= required && transactions[_txIndex].approve == false) {
            transactions[_txIndex].approve = true;
            (bool sent, ) = transactions[_txIndex].to.call{value: transactions[_txIndex].value}("");
            require(sent, "Transaction failed");
         
        }
    }

    receive() external payable {}
}
