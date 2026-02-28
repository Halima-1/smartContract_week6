// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSig {
    address owner;
    address[] signers;
    uint required;
    uint totalTxn;

    struct Transaction {
        uint value;
        address receiver;
        bool approved;
        uint id;
        address txnCreator;
        bool isExecuted;
        uint8 signersCount;
    }

    function onlyValidSigner() private view {
        require(isValidSigner[msg.sender], "not valid signer");
    }

    mapping(address => bool) isValidSigner;
    mapping(address => uint) txnOwner;
    // mapping(uint => Transaction) txnToId;
    mapping(uint256 => mapping(address => bool)) hasSigned;
    mapping(uint => Transaction) idToTransaction;

    Transaction[] public transactions;
// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
    constructor(address[] memory _signer, uint8 _required)  payable {
        signers = _signer;
        required = _required;
        owner = msg.sender;

        for (uint i = 0; i < _signer.length; i++) {
            require(signers[i] != address(0), "invalid address");
            isValidSigner[signers[i]] = true;
        }
    }

    // function addSigners()
    // uint txnId;

    function submitTransaction(address _receiver, uint _value) external {
       uint txnId = totalTxn + 1;
        require(_value > 0, "Can't transfer zero value");
        require(_receiver != address(0), "invalid address");
        for (uint i; i < signers.length; i++) {
            if (msg.sender == signers[i]) {
                require(isValidSigner[msg.sender] == true, "not a signer");
                require((_receiver != address(0)), "address zero detected");
                // transactions.push(Transaction(_value, _receiver, false, txnId,  false);
                Transaction storage transaction = idToTransaction[txnId];
                transaction.id = txnId;
                transaction.value = _value;
                transaction.receiver = _receiver;
                transaction.approved = false;
                transaction.isExecuted = false;
                transaction.txnCreator = msg.sender;
                transaction.signersCount = transaction.signersCount + 1;

                transactions.push(transaction);
                hasSigned[txnId][msg.sender] = true;

                totalTxn = totalTxn + 1;
            }
        }
    }

    function approveTnx(uint _txnId) external {
        require(totalTxn > 0, "no transaction to approve");
        require(_txnId <= totalTxn, "transaction not found");

        // onlyValidSigner();
        Transaction storage transaction = transactions[_txnId];

        require(transaction.signersCount < required, "transaction has been approved");
        require(hasSigned[_txnId][msg.sender] == false, "Already signed ");
        require(isValidSigner[msg.sender] = true, "not a signer");
        require(transaction.value > 0, "Can't approve 0");
        require(
            address(this).balance >= transaction.value,
            "insufficient balance"
        );
        require(
            transaction.isExecuted == false,
            "transaction has been executed"
        );

        transaction.signersCount = transaction.signersCount + 1;

        if (transaction.signersCount == required) {
            (bool success, ) = payable(transaction.receiver).call{
                value: transaction.value
            }("");
            require(success, "Transaction failed");

            transaction.isExecuted = true;
        }
    }

    function cancelTxn(uint _txnId) external {
        Transaction storage transaction = transactions[_txnId];

        onlyValidSigner();
        require(_txnId <= totalTxn, "transaction not found");
        require(
            transaction.isExecuted == false,
            "Transaction has been executed"
        );
        require(
            msg.sender == transaction.txnCreator || msg.sender == owner,
            "unauthorized access"
        );
        // transactions[_txnId] = transactions[transactions.length - 1];
        // transactions.pop();
        transaction.isExecuted = true;
    }

    function getAllSigners() external view returns (address[] memory){
        return signers;
    }

     function getAllTransactions() external view returns (Transaction[] memory){
        return transactions;
    }

    function deposit () public payable{}

}
