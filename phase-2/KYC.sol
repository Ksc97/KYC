// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.14;

contract Kyc{


    struct Customer {
        string userName;   
        string data;
        bool kycStatus;
        uint downVotes;
        uint upVotes;  
        address bank;
    }
    
    struct Bank {
        string name;
        address ethAddress;
        uint compliantsReported;
        uint kyc_Count;
        bool isAllowedToVote;
        string regNumber;
    }

    address admin;

    struct kyc_Request {
        string userName;
        address bank;
        string data;
    }


    mapping(string => Customer) customers;
    

    mapping(address => Bank) banks;
    

    mapping(string =>kyc_Request) kycRequests;
    
    

    mapping(string=>mapping(address=>uint256)) upVotes;

    //msg.sender as admin while deploying smart contracts
    constructor()  {
        admin = msg.sender;

    }

      //modifier to check for admin functionalities
    modifier isAdmin(address _senderAddress){
      require(_senderAddress == admin,"only for admin");
      _;
    }

   
    //////////////////////////////////bank interface///////////////////////////////////////////////////////////


    
    //this function is to add request for the customer
    function addRequest (string memory _userName, string memory _customerData) public  {
        require(customers[_userName].bank!= address(0),"customer is  not present in the list");
        kycRequests[_userName].userName= _userName;
        kycRequests[_customerData].data = _customerData;
        kycRequests[_userName].bank= msg.sender;
        banks[msg.sender].kyc_Count++;
    }

    //this function is for adding the new customer in to the list with the kyc status of the customer
    function addCustomer(string memory _userName, string memory _customerData) public {
        require(customers[_userName].bank == address(0), "Customer is already present, please call modifyCustomer to edit the customer data");
        customers[_userName].userName = _userName;
        customers[_userName].data = _customerData;
        customers[_userName].bank = msg.sender;

        //phase2 adding upvote and downvote and kyc status 
        customers[_userName].kycStatus= false;
        customers[_userName].upVotes=0;
        customers[_userName].downVotes=0;

    }
    //remove request for the customer if the customer name is available in the data
    function removeRequest (string memory _userName) public  {
        require(kycRequests[_userName].bank!= address(0),"customer is not available");
        delete kycRequests[_userName];     
    }
    
    //function allows a bank to view the customer details
    function viewCustomer(string memory _userName) public view returns (string memory, string memory, address,bool,uint,uint) {
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        return (customers[_userName].userName, customers[_userName].data, customers[_userName].bank,customers[_userName].kycStatus,
         customers[_userName].upVotes,customers[_userName].downVotes);
    }

   
  //function allows a bank to upvote for a customer only when the customer data is present in the bank
   function upVote_Customers(string memory _userName) public {
       require(customers[_userName].bank == address(0),"customer is present in the bank");
       customers[_userName].upVotes++;
   }

   //function allows a bank to downvote for a customer only when the customer data is present in the bank
   function downVote_Customers(string memory _userName) public {
       require(customers[_userName].bank== address(0),"customer is present in the bank");
       customers[_userName].downVotes++;
       
   }

     
    //this function allows a bank to modify data
    function modifyCustomer(string memory _userName, string memory _newcustomerData) public {
        require(customers[_userName].bank != address(0), "Customer is not present in the database");
        customers[_userName].data = _newcustomerData;
    }    
    
    //function is used to fetch bank complaints friom the smart contracts
    function getBankCompliants(address _bankAddress)public view returns(uint){
        return banks[_bankAddress].compliantsReported;
    }

    //function is used to fetch the bank details
    function viewBankDetails(address _bankAddress) public  view returns ( string memory , address, uint, bool, string memory,uint) {
        require(banks[_bankAddress].ethAddress != address(0),"the bank is not available");
        return (banks[_bankAddress].name, banks[_bankAddress].ethAddress,banks[_bankAddress].compliantsReported,banks[_bankAddress].isAllowedToVote,
        banks[_bankAddress].regNumber,banks[_bankAddress].kyc_Count);
    }

    //this function is used to report any bank in the network
    function reportBank(address _bankAddress) public {
        if(banks[_bankAddress].compliantsReported > 3){
            banks[_bankAddress].isAllowedToVote = false;
        }

        banks[_bankAddress].compliantsReported++;
    }
     ////////////////////admin interface//////////////////
      
      //function to addBank only by the admin to the kyc contract
    function addBank(string memory _name,address _bankAddress,string memory _regNumber) public   isAdmin(msg.sender) {
        banks[_bankAddress].name = _name;
        banks[_bankAddress].ethAddress = _bankAddress;
        banks[_bankAddress].regNumber = _regNumber;
    //setting the compliantsReported , kyc permissions as allowed/true;
        banks[_bankAddress].compliantsReported = 0;
        banks[_bankAddress].isAllowedToVote = true;
        banks[_bankAddress].kyc_Count=0;
    }
    
    //this function can only be used to chnage the status of voting by the bank
    function modifyBank_isAllowedToVote(address _bankAddress, bool _voteStatus) public isAdmin(msg.sender){
        banks[_bankAddress].isAllowedToVote = _voteStatus;
    }

    //this function is used by the admin to remove a bank from the kyc contract
    function removeBank(address _bankAddress) public isAdmin(msg.sender){
        require(banks[_bankAddress].ethAddress == address(0),"bank available");

        delete banks[_bankAddress];
    }
    
}