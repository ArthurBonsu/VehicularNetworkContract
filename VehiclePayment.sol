// SPDX-License-Identifier: LGPL-3.0-only


pragma solidity 0.8.2;

//Registration
//GetAll
//Check if they exist
//ReceiveFee

//Finabocci, signing, blocktimestamp 



contract VehiclePayment 
 {
    
  
     address payable public  receipientaddress;


mapping(address => mapping(address => address)) singlepayments;
mapping(address => mapping(uint256 => uint256)) multipayments;
mapping(uint256 => bool) usedNonces;
 

 string[] allvipaddresses;
 string[] allproposaladddresses;
 string[][] vipandproposaladdress;

event VIPEvent(address indexed vipaddress, string indexed  vipname, uint256 indexed  numberofproposal);

event ProposalEvent( uint256  proposalid,string  proposalname, string  proposalreason, address  persontoberemoved, address submitter, address intendedVIP );
event GetAllPseudonymAddressEvent (address[] indexed allpseudonymnstrings);
event GetAllAddressesEvent(address[] indexed vehicleaddresses);

  // THIS FUNCTION IS CALLED BY INDUSTRY; HE CLAIMS GOOD AFTER EXCHANGE;
        //ACTUALLY CURRENT OWNER IS THE RECEIPIENT ADDRESS WHILE RECEIPIENTADDRESS IS THE SENDER ADDRESS, CAPICHE?
    function claimPayment(address payable currentowner,  uint amount, uint256 nonce, bytes memory signature, bytes32 hashes)
public payable {
         
        uint mycash=0;
        mycash= amount;
        uint getthebalance=0;
        uint256 mynonce =0;
        mynonce = nonce;
      //  address payable entitytoclaimhismoney = receipientaddress;
  
    receipientaddress = payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);
require(!usedNonces[mynonce]);
usedNonces[nonce] = true;
// this recreates the message that was signed on the client
// bytes32 message = prefixed(keccak256(abi.encodePacked(hashes)));
    
require( recoverSigner(hashes, signature, currentowner)==true  );


receipientaddress.transfer(amount);
getthebalance = receipientaddress.balance-amount;
//withdraw(amount,thereceivertopaybalance);


}


/// destroy the contract and reclaim the leftover funds.
function kill(address payable entitymustgethismoneyback) public payable {
require(msg.sender == entitymustgethismoneyback);
selfdestruct(payable(msg.sender));
}


 
/// signature methods.
function splitSignature(bytes memory sig)
public payable
returns (uint8 v, bytes32 r, bytes32 s)
{
      

  
require(sig.length == 65);
assembly {
// first 32 bytes, after the length prefix.
    
 
   sig := mload(0x40)
     
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
