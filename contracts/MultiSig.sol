// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;


contract MultiSig {

    address[] public owners;
    uint256 public required;
    mapping(uint => mapping(address => bool)) public confirmations;

    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    Transaction [] public transactions;

    constructor(address[] memory _owners, uint256 _confirmations){
        require(_owners.length > 0, "Cannot be zero");
        require(_confirmations > 0, "Cannot be zero");
        require(_confirmations <= _owners.length, "Cannot be more than owners length");
        owners = _owners;
        required = _confirmations;
    }

    function transactionCount () public view returns (uint256) {
        return transactions.length;
    }

    function addTransaction(address destination, uint256 value, bytes memory data) internal returns (uint256)  {
        transactions.push(Transaction(destination, value, false, data));
        return transactions.length -1;
    }

    function  confirmTransaction(uint256 txId) public {
        bool isOwner = false;
           for(uint i = 0; i<owners.length;i++){
               if(msg.sender == owners[i]){
                   isOwner = true;
                   break;
               }
           }
           require(isOwner == true, "Only owner can make this call");
        confirmations[txId][msg.sender] = true;
        if(isConfirmed(txId)){
                  executeTransaction(txId);
        }
    }

    function getConfirmationsCount(uint transactionId) public view returns(uint256) {
       uint count = 0;

       for(uint i = 0; i<owners.length;i++){
           if(confirmations[transactionId][owners[i]]){
               count++;
           }
       }
        return count;
    }

    function submitTransaction(address destination, uint value, bytes memory data) external {
       uint id = addTransaction(destination, value, data);
        confirmTransaction(id);
    }

     receive() external payable {

    }

    function isConfirmed (uint transactionId) public view  returns (bool) {
            uint toBeConfirmedNumber = (owners.length/ 2) + 1;

            uint confimedNumber = getConfirmationsCount(transactionId);

            if(confimedNumber >= toBeConfirmedNumber){
                return true;
            }else{
                return false;
            }

    }

    function executeTransaction (uint transactionId) public {
        Transaction storage _tx  = transactions[transactionId];
            require(isConfirmed(transactionId) == true, "not confirmed");
           (bool s,) =  _tx.destination.call{value:_tx.value }(_tx.data);
           require(s);
            _tx.executed = true;
    }
}


