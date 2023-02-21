// SPDX-License-Identifier: LGPL-3.0-only


pragma solidity 0.8.2;

//Registration
//GetAll
//Check if they exist
//ReceiveFee

//Finabocci, signing, blocktimestamp 



contract VehiclePayment 
 {
    
address payable mypaymentaddress =0x06Da25591CdF58758C4b3aBbFf18B092e4380B65;
   address payable public thereceivertopay;



mapping(address => mapping(address => address)) singlepayments;
mapping(address => mapping(uint256 => uint256)) multipayments;

 

 string[] allvipaddresses;
 string[] allproposaladddresses;
 string[][] vipandproposaladdress;

event VIPEvent(address indexed vipaddress, string indexed  vipname, uint256 indexed  numberofproposal);

event ProposalEvent( uint256  proposalid,string  proposalname, string  proposalreason, address  persontoberemoved, address submitter, address intendedVIP );
event GetAllPseudonymAddressEvent (address[] indexed allpseudonymnstrings);
event GetAllAddressesEvent(address[] indexed vehicleaddresses);



        
        // THIS FUNCTION IS CALLED BY INDUSTRY; HE CLAIMS GOOD AFTER EXCHANGE;
        //ACTUALLY CURRENT OWNER IS THE RECEIPIENT ADDRESS WHILE RECEIPIENTADDRESS IS THE SENDER ADDRESS, CAPICHE?
    function claimPayment( address payable currentowner, uint amount, uint256 nonce, bytes memory signature,bytes32 hashes)
public payable {
   address payable    receipientaddress=  mypaymentaddress;
        uint mycash=0;
        mycash= amount;
        uint getthebalance=0;
        uint256 mynonce =0;
        mynonce = nonce;
      //  address payable entitytoclaimhismoney = receipientaddress;
        
    thereceivertopay = currentowner; 

require(!usedNonces[mynonce]);
usedNonces[nonce] = true;
// this recreates the message that was signed on the client
// bytes32 message = prefixed(keccak256(abi.encodePacked(hashes)));
    
require( recoverSigner(hashes, signature, currentowner)==true  );


receipientaddress.transfer(amount);
getthebalance = receipientaddress.balance-amount;
//withdraw(amount,thereceivertopaybalance);
emit Sent(currentowner, receipientaddress, amount);

}


/// destroy the contract and reclaim the leftover funds.
function kill(address payable entitymustgethismoneyback) public payable {
require(msg.sender == entitymustgethismoneyback);
selfdestruct(msg.sender);
}



/// signature methods.
function splitSignature(bytes memory sig)
public payable
returns (uint8 v, bytes32 r, bytes32 s)
{
      

  
require(sig.length == 65);
assembly {
// first 32 bytes, after the length prefix.
    
 
   let sig := mload(0x40)
     
 //   mstore ( 0x40, sig )
   
    


 //     r := mload(add(sig, 0x20))
   //   s := mload(add(sig, 0x40))
   //   v := byte(0, mload(add(sig, 0x60)))
    // v := and(mload(add(sig, 65)), 255)

//sv := and(mload(add(sig, 0x60)), 255)

r := mload(add(sig, 32))
// second 32 bytes.
s := mload(add(sig, 64))
// final byte (first byte of the next 32 bytes).
//v := byte(0, mload(add(sig, 96)))
v := and(mload(add(sig, 65)), 255)
}


//Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }

   // If the version is correct return the signer address
    if (v != 27 && v != 28) {
     

return (v, r, s);
    }
}
function verify(address payable currentowner, bytes32 hash, uint8 v, bytes32 r, bytes32 s) public pure returns(bool) {

    // bytes memory prefix = "\x19Ethereum Signed Message:\n32";
   // bytes32 prefixedHash = (keccak256(abi.encodePacked(prefix, hash));

  bytes32 prefixedHash = prefixed(keccak256(abi.encodePacked(hash)));
    return ecrecover(prefixedHash, v, r, s) == currentowner;
}

//ANOTHER IMPLEMENTATION

// HERE IS WHERE RECOVER SIGNER IS PASSED TO HIM SO THAT HE CAN GET HIS MONEY
function recoverSigner(bytes32 message, bytes memory sig, address payable myman)
public payable

returns (bool)
{          
        
        
    //  address  mysigner = signer;

      
  (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
        
   myman== ecrecover(message, v, r, s);
     
  return true;
     
}
/// builds a prefixed hash to mimic the behavior of eth_sign.
function prefixed(bytes32 hash) internal pure returns (bytes32) {
return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));}

    
    
  
}





    function VIPRegistration (address _vipaddress, string memory _vipname ) external returns (address, string memory  ) {
      uint256 index=0;
      
      // We set it amoong the registered hashmaps
      registeredvipaddress[_vipaddress]=_vipaddress;
     
    
    // multiwalletlist.push ([addressstring,safestring]);
 

   //  listofownersafe = OwnerSafeHere(walletaddress,safestring );
      // We store the vehicle nodes on the blockchain and set it as registered with details
   

    vipnode =VIP(_vipaddress,_vipname, 0 , true);
     viplist[_vipaddress].vipaddress=_vipaddress;
     viplist[_vipaddress].vipname=_vipname;
     viplist[_vipaddress].numberofproposals=0;
     viplist[_vipaddress].active=true;
  
     
        bytes memory myvipaddresstobestringed = abi.encodePacked(_vipaddress);
        string memory stringedvip = bytesToString(myvipaddresstobestringed);
     
     
     
     // allpseudonymstring.push ([stringifiedaddressforvehicle,fibonaccistring]);

      
      vipstores.push(vipnode);
    
      allvipaddresses[index]=stringedvip;

      // Events logged on the blockchain
      emit VIPEvent( _vipaddress,_vipname, index);
     // We increase the number of vehicles registered count
      index++;
      
    return ( _vipaddress,_vipname);
   
   
    }
 
function SendProposal  (string memory  proposalname, string memory proposalreason, address persontoberemoved, address submitter,
        address  intendedVIP ) external returns (uint256 _proposalid, string memory  _proposalname,  string memory _proposalreason, address  _persontoberemoved,  address _submitter,   address  _intendedVIP ) {
 
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
   

Proposalnode = Proposals(proposalidgiven, proposalname,proposalreason,persontoberemoved, submitter, intendedVIP );
   uint256  myproposalid = proplist[proposalidgiven].proposalid;
    string memory myproposalname = proplist[proposalidgiven].proposalname;
    string memory  myproposalreason = proplist[proposalidgiven].proposalreason;
     address  mypersontoberemoved = proplist[proposalidgiven].persontoberemoved;
    address mysubmitter=  proplist[proposalidgiven].submitter;
    address myintendedVIP= proplist[proposalidgiven].intendedVIP;
     
             
  
       Proposalstores.push(Proposalnode);

      emit ProposalEvent(myproposalid,myproposalname,myproposalreason, mypersontoberemoved, mysubmitter,myintendedVIP);
 proposalindex++;
      
    return (myproposalid,myproposalname,myproposalreason, mypersontoberemoved, mysubmitter,myintendedVIP );
   
   
    }



function NotifyKCC (address _kcc) external returns (address, bool) {
  
      bool notified = true;
    return (_kcc, notified);
 
      }

function Payfees (address VIP, address _vehicle, uint256 _amountpaid  ) external returns (address, address,uint256, uint256) {
     uint256 recordeddate = block.timestamp; 
      paidpeople[_vehicle][recordeddate]=_amountpaid; 
    return (VIP,_vehicle,recordeddate,  _amountpaid );
 
     }

//Revoke
//

function CheckIfVIPExists (address _VIPaddress) external returns (bool existent ) {
      require (registeredvipaddress[_VIPaddress]==_VIPaddress,  "Address is not registered, try registering");
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
