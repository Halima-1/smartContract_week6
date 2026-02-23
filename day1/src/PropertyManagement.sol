  // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
contract PropertyManagement {
    // using SafeERC20 for IERC20;

    IERC20 public paymentToken;

   struct  Properties {
    uint id;
    string apartmentType;
    uint amount;
    address OwnerAddress;
   }

   mapping (uint  => uint) propertyIdToIndex;
   mapping (uint => Properties) propertyDetails;
   address owner = msg.sender;
   modifier  OnlyOwner (){
    require(msg.sender == owner, "This action has been restricted to only owner");
    _;
   }
   Properties [] public properties;
   uint propertyId;
   function addProperty (string memory _apartmentType, uint _amount ) external returns (bool){
    propertyId =propertyId + 1;
    Properties memory property = Properties ({
        id: propertyId,
        apartmentType : _apartmentType,
        amount : _amount,
        OwnerAddress: msg.sender
    });
    properties.push(property);

    return true;
   }

   function makePayment(uint _id) external {
    require(_id < properties.length, "Property not found");
    index = propertyIdToIndex[_id];
    selectedProp = properties[index] ;
    uint amountToPay = selectedProp.amount;

    bool success = Transfer(msg.sender, address(this), amountToPay);
    require (success, "Transaction failed, please try again");

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

   function getAllProperties() external returns (Properties [] memory){
    return properties;
   }

   function getPropertyById(uint _id) external returns (Properties memory){
    require(_id < properties.length, "Property not found");
    return properties[_id];
   }

}
