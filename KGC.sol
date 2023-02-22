// SPDX-License-Identifier: LGPL-3.0-only


pragma solidity 0.8.2;

//Registration
//GetAll
//Check if they exist
//ReceiveFee
//submissions are encrrypted 

//Finabocci, signing, blocktimestamp 
import "./VehiclePayment.sol";
import "./VehicleContract.sol";


contract KGCContract is  VehiclePayment, VehicleContract
 {
        
        struct KGC {      
        address  kgcaddress;  
        string  kgcname;     
        uint256  numberoffeedbacks;   
        bool active;      
      }
         

      KGC KGCnode;
      KGC[] public KGCstores;
    //  string [][] public multiwalletlist ;
    //  string[] public safeaddressarray;

       struct feedbacks {      
        uint256  feedbackid;  
          
        string  feedbackreason; 
        address  persontoberemoved;
        address submitter;
        address intendedVIP;  
        
      }
        uint256 randNonce =0;
       uint256 modulus =0;
   
      feedbacks feedbacknode;
      feedbacks[] public feedbackstores;


mapping(address => address) public registeredkgcaddress;
mapping(uint256 =>  uint256 ) public  feedbackidgenerated;

mapping(address => mapping(uint256 => uint256)) paidpeople;
mapping(address =>  string ) public  updatedpeoplelist;
 mapping(address => KGC) public KGClist;
  mapping(uint256 => feedbacks) public proplist;

 string[] allkgcaddresses;
 string[] allfeedbackadddresses;
 string[][] KGCandfeedbackaddress;

event KGCEvent(address indexed kgcaddress, string indexed  kgcname, uint256 indexed  numberoffeedback);

event feedbackEvent( uint256  feedbackid, string  feedbackreason, address  persontoberemoved, address submitter, address intendedVIP );




    function KGCRegistration (address _kgcaddress, string memory _kgcname ) external returns (address, string memory  ) {
      uint256 index=0;
      
      // We set it amoong the registered hashmaps
      registeredkgcaddress[_kgcaddress]=_kgcaddress;
     
    
    // multiwalletlist.push ([addressstring,safestring]);
 

   //  listofownersafe = OwnerSafeHere(walletaddress,safestring );
      // We store the vehicle nodes on the blockchain and set it as registered with details
   

    KGCnode =KGC(_kgcaddress,_kgcname, 0 , true);
     KGClist[_kgcaddress].kgcaddress=_kgcaddress;
     KGClist[_kgcaddress].kgcname=_kgcname;
     KGClist[_kgcaddress].numberoffeedbacks=0;
     KGClist[_kgcaddress].active=true;
  
     
        bytes memory mykgcaddresstobestringed = abi.encodePacked(_kgcaddress);
        string memory stringedKGC = bytesToString(mykgcaddresstobestringed);
     
     
     
     // allpseudonymstring.push ([stringifiedaddressforvehicle,fibonaccistring]);

      
      KGCstores.push(KGCnode);
    
      allkgcaddresses[index]=stringedKGC;

      // Events logged on the blockchain
      emit KGCEvent( _kgcaddress,_kgcname, index);
     // We increase the number of vehicles registered count
      index++;
      
    return ( _kgcaddress,_kgcname);
   
   
    }
 
function Sendfeedback  ( string memory feedbackreason, address persontoberemoved, address submitter,
        address  intendedVIP ) external returns (uint256 _feedbackid,   string memory _feedbackreason, address  _persontoberemoved,  address _submitter,   address  _intendedVIP ) {
 
   uint256 feedbackindex =0;

// We set a shuffler to generate a random number    
uint256 shuffler = 0;
shuffler= 100000000;

// We set a random number, well there has to be a better way of doing this thing
randNonce++; 
uint256 feedbackidgiven =     uint256(keccak256(abi.encodePacked(block.timestamp,
msg.sender,
randNonce))) % 
shuffler; 

    
    feedbackidgenerated[feedbackidgiven]==feedbackidgiven;
   

feedbacknode = feedbacks(feedbackidgiven, feedbackreason,persontoberemoved, submitter, intendedVIP );
   uint256  myfeedbackid = proplist[feedbackidgiven].feedbackid;
   
    string memory  myfeedbackreason = proplist[feedbackidgiven].feedbackreason;
     address  mypersontoberemoved = proplist[feedbackidgiven].persontoberemoved;
    address mysubmitter=  proplist[feedbackidgiven].submitter;
    address myintendedVIP= proplist[feedbackidgiven].intendedVIP;
     
             
  
       feedbackstores.push(feedbacknode);

      emit feedbackEvent(myfeedbackid,myfeedbackreason, mypersontoberemoved, mysubmitter,myintendedVIP);
 feedbackindex++;
      
    return (myfeedbackid,myfeedbackreason, mypersontoberemoved, mysubmitter,myintendedVIP );
   
   
    }





//Revoke
//

function CheckIfKGCExists (address _kgcaddress) external returns (bool existent ) {
      require (registeredkgcaddress[_kgcaddress]==_kgcaddress,  "Address is not registered, try registering");
    bool  _existent = true;   
      
    return (_existent);
   
   
    }


   //revokerepvehicle
// register vehiclke
// function payment
    function  revokeReportedVehicle(address _reportedvehicle  )  public returns (bool) {
    address receivedrevokedvehicle =    VehicleContract.revokebyaddress (_reportedvehicle);
      require (receivedrevokedvehicle ==_reportedvehicle );
      return true; 
    }
 function compare(string memory _a, string memory _b) public override  returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
       
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
  
    function equal(string memory _a, string memory _b) public override returns (bool) {
        return compare(_a, _b) == 0;
    }

function bytesToString(bytes memory byteCode) public override pure returns(string memory stringData)
{
    uint256 blank = 0; 
    uint256 length = byteCode.length;

    uint cycles = byteCode.length / 0x20;
    uint requiredAlloc = length;

    if (length % 0x20 > 0) //optimise copying the final part of the bytes - to avoid looping with single byte writes
    {
        cycles++;
        requiredAlloc += 0x20; //expand memory to allow end blank, so we don't smack the next stack entry
    }

    stringData = new string(requiredAlloc);

    //copy data in 32 byte blocks
    assembly {
        let cycle := 0

        for
        {
            let mc := add(stringData, 0x20) //pointer into bytes we're writing to
            let cc := add(byteCode, 0x20)   //pointer to where we're reading from
        } lt(cycle, cycles) {
            mc := add(mc, 0x20)
            cc := add(cc, 0x20)
            cycle := add(cycle, 0x01)
        } {
            mstore(mc, mload(cc))
        }
    }

    //finally blank final bytes and shrink size (part of the optimisation to avoid looping adding blank bytes1)
    if (length % 0x20 > 0)
    {
        uint offsetStart = 0x20 + length;
        assembly
        {
            let mc := add(stringData, offsetStart)
            mstore(mc, mload(add(blank, 0x20)))
            //now shrink the memory back so the returned object is the correct size
            mstore(stringData, length)
        }
    }
}
}
