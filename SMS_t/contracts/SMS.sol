// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import {IERC20} from "./IERC20.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SMS {
    IERC20 public paymentToken;

    struct StudentDetails {
        uint id;
        string studentFullname;
        string gender;
        uint level;
        uint fees;
        bool paymentStatus;
        uint timeStamp;
        bool suspended;
        address studentAddress;
    }
    //  staff struct
    struct StaffDetails {
        uint id;
        string staff_fullname;
        string gender;
        address staffAddress;
        bool paymentStatus;
        bool suspended;
    }

    //  STAFF_SALARY;
    uint constant STAFF_SALARY = 5000;

    // mapping (address => StudentDetails) student;

    mapping(address => uint) _balances;
    mapping(address => uint) _staffBalance;
    mapping(uint => uint) studentFees;
    mapping(uint => StudentDetails) students;
    mapping(address => uint) public addressToStudentId;
    mapping(uint => uint) studentIdToIndex;
    mapping(address => uint) public addressToStaffId;
    mapping(uint => uint) staffIdToIndex;

    // addressToStudentId[msg.sender] =id;

    address owner;

    constructor(address _tokenAddress) {
        studentFees[100] = 200000000000000000;
        studentFees[200] = 400000000000000000;
        studentFees[300] = 500000000000000000;
        studentFees[400] = 500000000000000000;
        studentFees[500] = 800000000000000000;

        paymentToken = IERC20(_tokenAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This action has been restricted to only owner"
        );
        _;
    }

    event studentPaymentReceived(string _name, uint _level);
    event staffPaid(string _name);
    event addedNewStaff(string _name);

    StudentDetails[] public studentDetails;
    StaffDetails[] public staffDetails;

    // to add new student
    uint256 studentId;

    // address user =msg.sender;
    //    user = msg.sender;
    function addStudent(
        string memory _studentname,
        string memory _gender,
        uint _level
    ) external {
        require(
            addressToStudentId[msg.sender] == 0,
            "A student has already registered with this address"
        );
        require(
            _level == 100 || _level == 200 || _level == 300 || _level == 400,
            "Kindly input a valid level, no fee specified for this level"
        );
        // require(_studentname && _gender && _level, "Kindly input ful details");
        studentId = studentId + 1;
        uint256 fee = studentFees[_level];

        require(fee > 0, "Fee not set for this level");
        bool success = paymentToken.transferFrom(
            msg.sender,
            address(this),
            fee
        );
        require(success, "Payment failed");

        StudentDetails memory student = (
            StudentDetails({
                id: studentId,
                studentFullname: _studentname,
                gender: _gender,
                level: _level,
                fees: fee,
                paymentStatus: true,
                timeStamp: block.timestamp,
                suspended: false,
                studentAddress: msg.sender
            })
        );

        studentIdToIndex[studentId] = studentDetails.length;
        addressToStudentId[msg.sender] = studentId;

        studentDetails.push(student);

        emit studentPaymentReceived(_studentname, _level);
    }

    // to add new staff
    uint staffId;

    function addStaff(
        address _staffAddress,
        string memory _staffname,
        string memory _gender
    ) external onlyOwner {
        require(_staffAddress != address(0), "Invalid address");
        require(
            addressToStaffId[_staffAddress] == 0,
            "This address already exist"
        );

        staffId = staffId + 1;

        StaffDetails memory staff = (
            StaffDetails({
                id: staffId,
                staffAddress: _staffAddress,
                staff_fullname: _staffname,
                gender: _gender,
                paymentStatus: false,
                suspended: false
            })
        );
        staffIdToIndex[staffId] = staffDetails.length;
        addressToStaffId[msg.sender] = staffId;

        staffDetails.push(staff);

        emit addedNewStaff(_staffname);
    }

    function getStudentById(
        uint256 _id
    ) public view returns (StudentDetails memory) {
        require(
            studentIdToIndex[_id] < staffDetails.length,
            "Student not found"
        );

        return studentDetails[_id];
    }

    // to get all students
    function getAllStudent() external view returns (StudentDetails[] memory) {
        return studentDetails;
    }

    // to get all staff;

    function getAllStaff() external view returns (StaffDetails[] memory) {
        return staffDetails;
    }

    // to pay staff
    // uint[] allStaffAccount ;
    function payStaff(uint256 _id) external onlyOwner returns (bool) {
        uint index = staffIdToIndex[_id];

        require(
            staffDetails[index].suspended == false,
            "Staff has been suspended"
        );
        require(
            staffDetails[index].paymentStatus == false,
            "Staff has been paid"
        );
        require(
            staffDetails[index].staffAddress != address(0),
            "Can't make payment to address zero"
        );
        require(
            paymentToken.balanceOf(address(this)) >= STAFF_SALARY,
            "Insufficient fund"
        );

        address StaffAccount = staffDetails[index].staffAddress;
        uint256 contractBalance = paymentToken.balanceOf(address(this));

        require(
            contractBalance >= STAFF_SALARY,
            "Insufficient contract token balance"
        );

        bool success = paymentToken.transfer(StaffAccount, STAFF_SALARY);
        require(success, "Transaction failed");
        staffDetails[index].paymentStatus = true;

        emit staffPaid(staffDetails[index].staff_fullname);
        return true;
    }

    // to suspend staff
    function suspendStaff(uint _id) external onlyOwner returns (bool) {
        // staffIdToIndex[_id] = staffDetails.length;
        uint index = staffIdToIndex[_id];

        require(staffIdToIndex[_id] < staffDetails.length, "Staff not found");
        require(
            (staffDetails[index].suspended == false),
            "Staff is currently on suspension"
        );
        staffDetails[index].suspended = true;
        return true;
    }

    // to suspend student

    function suspendStudent(uint _id) external onlyOwner returns (bool) {
        uint index = studentIdToIndex[_id];

        require(
            studentIdToIndex[_id] < studentDetails.length,
            "Student not found"
        );
        require(
            (studentDetails[index].suspended == false),
            "Student is currently on suspension"
        );

        studentDetails[index].suspended = true;

        return true;
    }

    // to remove student

    function removeStudent(uint256 _id) external onlyOwner returns (bool) {
        require(studentDetails.length > 0, "No students");
        require(
            studentIdToIndex[_id] < studentDetails.length,
            "Student not found"
        );

        uint256 indexToRemove = studentIdToIndex[_id];
        uint256 lastIndex = studentDetails.length - 1;

        if (indexToRemove != lastIndex) {
            StudentDetails memory lastStudent = studentDetails[lastIndex];
            studentDetails[indexToRemove] = lastStudent;
            studentIdToIndex[lastStudent.id] = indexToRemove;
        }

        // Remove last element
        studentDetails.pop();

        delete studentIdToIndex[_id];

        return true;
    }
}
