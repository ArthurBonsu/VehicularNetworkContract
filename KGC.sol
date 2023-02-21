// SPDX-License-Identifier: LGPL-3.0-only


pragma solidity 0.8.2;

//Registration
//GetAll
//Check if they exist
//ReceiveFee

//Finabocci, signing, blocktimestamp 
import "./VehiclePayment.sol";
import "./VehicleContract.sol";


contract KGCContract is  VehiclePayment
 {
        
        struct KGC {      
        address  kgcaddress;  
        string  kgcname;     
        uint256  numberofproposals;   
        bool active;      
      }
         

      KGC KGCnode;
      KGC[] public KGCstores;
    //  string [][] public multiwalletlist ;
    //  string[] public safeaddressarray;

       struct Proposals {      
        uint256  proposalid;  
        string  proposalname;     
        string  proposalreason; 
        address  persontoberemoved;
        address submitter;
        address intendedKGC;  
        
      }
        uint256 randNonce =0;
       uint256 modulus =0;
   
      Proposals Proposalnode;
      Proposals[] public Proposalstores;


mapping(address => address) public registeredkgcaddress;
mapping(uint256 =>  uint256 ) public  proposalidgenerated;

mapping(address => mapping(uint256 => uint256)) paidpeople;
mapping(address =>  string ) public  updatedpeoplelist;
 mapping(address => KGC) public KGClist;
  mapping(uint256 => Proposals) public proplist;

 string[] allkgcaddresses;
 string[] allproposaladddresses;
 string[][] KGCandproposaladdress;

event KGCEvent(address indexed kgcaddress, string indexed  kgcname, uint256 indexed  numberofproposal);

event ProposalEvent( uint256  proposalid,string  proposalname, string  proposalreason, address  persontoberemoved, address submitter, address intendedKGC );
event GetAllPseudonymAddressEvent (address[] indexed allpseudonymnstrings);
event GetAllAddressesEvent(address[] indexed vehicleaddresses);



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
     KGClist[_kgcaddress].numberofproposals=0;
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
 
function SendProposal  (string memory  proposalname, string memory proposalreason, address persontoberemoved, address submitter,
        address  intendedKGC ) external returns (uint256 _proposalid, string memory  _proposalname,  string memory _proposalreason, address  _persontoberemoved,  address _submitter,   address  _intendedKGC ) {
 
   uint256 proposalindex =0;

// We set a shuffler to generate a random number    
uint256 shuffler = 0;
shuffler= 100000000;

// We set a random number, well there has to be a better way of doing this thing
randNonce++; 
uint256 proposalidgiven =     uint256(keccak256(abi.encodePacked(block.timestamp,
msg.sender,
randNonce))) % 
shuffler; 

    
    proposalidgenerated[proposalidgiven]==proposalidgiven;
   

Proposalnode = Proposals(proposalidgiven, proposalname,proposalreason,persontoberemoved, submitter, intendedKGC );
   uint256  myproposalid = proplist[proposalidgiven].proposalid;
    string memory myproposalname = proplist[proposalidgiven].proposalname;
    string memory  myproposalreason = proplist[proposalidgiven].proposalreason;
     address  mypersontoberemoved = proplist[proposalidgiven].persontoberemoved;
    address mysubmitter=  proplist[proposalidgiven].submitter;
    address myintendedKGC= proplist[proposalidgiven].intendedKGC;
     
             
  
       Proposalstores.push(Proposalnode);

      emit ProposalEvent(myproposalid,myproposalname,myproposalreason, mypersontoberemoved, mysubmitter,myintendedKGC);
 proposalindex++;
      
    return (myproposalid,myproposalname,myproposalreason, mypersontoberemoved, mysubmitter,myintendedKGC );
   
   
    }



function NotifyKCC (address _kcc) external returns (address, bool) {
  
      bool notified = true;
    return (_kcc, notified);
 
      }

function Payfees (address KGC, address _vehicle, uint256 _amountpaid  ) external returns (address, address,uint256, uint256) {
     uint256 recordeddate = block.timestamp; 
      paidpeople[_vehicle][recordeddate]=_amountpaid; 
    return (KGC,_vehicle,recordeddate,  _amountpaid );
 
     }

//Revoke
//

function CheckIfKGCExists (address _kgcaddress) external returns (bool existent ) {
      require (registeredkgcaddress[_kgcaddress]==_kgcaddress,  "Address is not registered, try registering");
    bool  _existent = true;   
      
    return (_existent);
   
   
    }
function CheckIfProposalExists (uint256 _proposalid) external returns (bool existent ) {
      
bool  _existent=false;
      //   bytes memory yourpseudonym = abi.encodePacked(_pseudorandomnum);
    // string memory _yourpseudonym = bytesToString(yourpseudonym);

      //    bytes memory myamazingpseudonym = abi.encodePacked(registeredentitiespseudonymlist[_pseudorandomnum]);
   //  string memory superpseudonym = bytesToString(myamazingpseudonym);
require (proposalidgenerated[_proposalid] == _proposalid) ;
              
             

     _existent = true;   
 
    return (_existent);
   
   
    }

   //revokerepvehicle
// register vehiclke
// function payment
    function  revokeReportedVehicle(address  )  public returns (int) {
   

    }
 function compare(string memory _a, string memory _b) public returns (int) {
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
  
    function equal(string memory _a, string memory _b) public returns (bool) {
        return compare(_a, _b) == 0;
    }

function bytesToString(bytes memory byteCode) public pure returns(string memory stringData)
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
