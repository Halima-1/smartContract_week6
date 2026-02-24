// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract HMS {

     IERC20 public immutable paymentToken;
    address tokenAddress ;

    error NOT_THE_OWNER();

    constructor (address _tokenAddress) {
        tokenAddress =_tokenAddress;

        paymentToken = IERC20(_tokenAddress);
    }

    struct Visits{
        uint visitDate;
        string symptom;
        string diagnosis;
        string treatment;
        string prescription;
        // string specialistOnDuty;
        // uint timestamp;
        // string nextAppointment;
        // string departmentVisited;
    }

    struct PatientDetails{
        string surname;
        // string middleName;
        // string lastName;
        string gender;
        uint8 age;
        address patientAddress;
        // Visits[] visits ; 
    }

    struct Specialists{
        string fullName;
        string department;
        address sAddress;
        bool paymentStatus;
        // string specialization;
        // string gender;
    }

    
    uint constant registrationFee = 10000;
    
    mapping (address => uint) patientAddressToId;
    mapping (address => uint) sAddressToId;
    mapping (uint => uint) patientIdToIndex;
    mapping (uint => uint) sIdToIndex;
    mapping (address => uint) balances;
    mapping (address => mapping(address => uint)) allowances;
    mapping (uint => PatientDetails) private patientss;
    mapping (uint => bool) patientExist;

    PatientDetails [] public patients;
    Specialists [] hSpecialists;

    uint patientId;
    function registerPatient(string memory _surname, string  memory _gender, uint8 _age,
     address _patientAddress) external  returns(bool){

require(_patientAddress != address(0), "Invalid address");
require (patientAddressToId [_patientAddress] == 0, "this address belongs to another patient");
// require(bytes_gender = "male" || _gender = "female", "input a gender and try again");
// require(balances[_patientAddress] >= registrationFee, "Insufficient balance for registration");
patientId =patientId + 1;

bool success = paymentToken.transferFrom(_patientAddress, address(this), registrationFee);
require(success, "payment failed");
PatientDetails memory patient = PatientDetails({
    surname: _surname, 
    gender: _gender, 
    age:_age, 
    patientAddress: _patientAddress
    // visits:
    });

        patientExist[patientId] =true;
        patientIdToIndex[patientId] = patients.length;
        // _patientAddress[patientId] = 
patients.push(patient);
    }

    function updatePatientVisit(uint _patiendId, string memory _symptom, string memory _diagnosis, 
    string memory _prescription, string memory _treatment, string memory _specialist )
     private returns(bool){
      require (_patiendId < patients.length, "Patient does not exist");
        Visits memory patientVisit =Visits({
            visitDate : block.timestamp,
            symptom: _symptom,
            diagnosis : _diagnosis,
            prescription : _prescription,
            treatment : _treatment
        });

        // patients[_patiendId].visits.push(patientVisit);
    }
    function addSpecialists (string memory _fullName, string memory _department, address _sAddress) private {
        require(_sAddress == address(0), "Invalid address");
        require (sAddressToId [_sAddress] ==0, "");
        // require (_fullName.length > 0, "Input a valid name");
        
        Specialists memory specialist = Specialists({
            fullName:_fullName,
            department: _department,
            sAddress:_sAddress,
            paymentStatus: false
        });

        hSpecialists.push(specialist);
    }
}
