  // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PropertyManagement {
    // using SafeERC20 for IERC20;

    IERC20 public immutable paymentToken;
    address tokenAddress ;

    error NOT_THE_OWNER();

    constructor (address _tokenAddress) {
        tokenAddress =_tokenAddress;

        paymentToken = IERC20(_tokenAddress);
    }

   struct  Properties {
    uint id;
    string apartmentType;
    string description;
    uint amount;
    address OwnerAddress;
    uint timeStamp;
    bool soldOut;
   }

   mapping (uint  => uint) propertyIdToIndex;
   mapping (uint => Properties) propertyDetails;
   mapping (address => uint) _balances;
   address owner = msg.sender;

   modifier  OnlyOwner (){
if (msg.sender != owner) {
    revert NOT_THE_OWNER();
}    _;
   }

   Properties [] public properties;
   uint propertyId;
   function addProperty (string memory _apartmentType, uint _amount, string memory _description ) external returns (bool){
    propertyId =propertyId + 1;
    Properties memory property = Properties ({
        id: propertyId,
        apartmentType : _apartmentType,
        description: _description,
        amount : _amount,
        OwnerAddress: msg.sender,
        timeStamp : block.timestamp,
        soldOut: false
    });
    propertyIdToIndex[propertyId] = properties.length;
    properties.push(property);

    return true;
   }

   function buyProperty(uint _id) external returns(uint){
       uint index= propertyIdToIndex[_id];
           require(index < properties.length, "Property not found");
           require(properties[index].id == _id, "Invalid property");

//    address seller =properties[index].OwnerAddress;
    // if(properties[index].id == _id){
    require(!properties[index].soldOut, "This property is no longer available");
    uint amountToPay = properties[index].amount;
 address OwnerAddress = properties[index].OwnerAddress;
// 2000000000000000000
   bool success = paymentToken.transferFrom(msg.sender,OwnerAddress,amountToPay);
require(success, "Transaction failed");
properties[index].soldOut = true;
return amountToPay;
    
   }

   function removeProperty(uint _id) external OnlyOwner {
    uint indexToRemove = propertyIdToIndex[_id];
    uint lastIndex = properties.length -1;
    require(propertyIdToIndex[_id] < properties.length);
    
    if(indexToRemove != lastIndex){
        Properties memory lastProperty = properties[lastIndex];
                properties[indexToRemove] = lastProperty;

        propertyIdToIndex[lastProperty.id] = indexToRemove;
    }
    properties.pop();
    delete propertyIdToIndex[_id];

    // return _

   }

   function getAllProperties() external view returns (Properties [] memory){
    return properties;
   }

   function getPropertyById(uint _id) external view returns (Properties memory){
    require(_id < properties.length, "Property not found");
    return properties[_id];
   }

}
