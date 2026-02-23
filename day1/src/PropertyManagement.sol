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

        paymentToken = IERC20 (_tokenAddress);
    }

   struct  Properties {
    uint id;
    string apartmentType;
    string description;
    uint amount;
    address OwnerAddress;
    uint timeStamp;
    
   }

   mapping (uint  => uint) propertyIdToIndex;
   mapping (uint => Properties) propertyDetails;
   address owner = msg.sender;

   modifier  OnlyOwner (){
if (msg.sender != owner) {
    revert NOT_THE_OWNER();
}    _;
   }

   Properties [] public properties;
   uint propertyId;
   function buyProperty (string memory _apartmentType, uint _amount, string memory _description ) external returns (bool){
    propertyId =propertyId + 1;
    Properties memory property = Properties ({
        id: propertyId,
        apartmentType : _apartmentType,
        description: _description,
        amount : _amount,
        OwnerAddress: msg.sender,
        timeStamp : block.timestamp
    });
    properties.push(property);

    return true;
   }

   function buyProperty(uint _id) external {
    require(_id < properties.length, "Property not found");
   uint indexx = propertyIdToIndex[_id];
for (uint i; i < properties.length; i++){
    if(properties[i].id == _id){
    uint amountToPay = properties[i].amount;

    bool success = paymentToken.TransferFrom(msg.sender, address(this), amountToPay);
    require (success, "Transaction failed, please try again");

    }
}


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

   }

   function getAllProperties() external view returns (Properties [] memory){
    return properties;
   }

   function getPropertyById(uint _id) external view returns (Properties memory){
    require(_id < properties.length, "Property not found");
    return properties[_id];
   }

}
