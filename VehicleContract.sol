// SPDX-License-Identifier: LGPL-3.0-only


pragma solidity 0.8.2;

// Bidding
//Fabioni
//Payments
//Clustering
contract VehicleContract 
 {
        
        struct Vehicle {      
        address  vehicleaddress;  
        string  vehiclename;
        string  cartype;
        uint256  proposalindex;
        string pseudorandomnum;
        bool active;      
      }
         
   
      Vehicle vehiclenode;
      Vehicle[] public vehiclestore;
    //  string [][] public multiwalletlist ;
    //  string[] public safeaddressarray;


mapping(address => address) public registeredentitiesasddress;
mapping(string =>  string ) public  registeredentitiespseudonymlist;
mapping(address =>  address ) public  revokedlist;
mapping(address =>  string ) public  prevrevokedlist;
 mapping(address => Vehicle) public vehiclelist;

 string[] alladdresses;
 string[] allmypseudonyms;
 string[][] allpseudonymstring;

event registrationevent(address indexed vehicleaddress, string indexed  vehiclename, string indexed  cartype);

event GetVehicleDetailViaAddressEvent(address  _myvehicleaddress,   string  _myvehiclename, string  mycartype, uint256  _proposalindex, string  _pseudorandomnum,  bool _active );
event GetAllPseudonymAddressEvent (address[] indexed allpseudonymnstrings);
event GetAllAddressesEvent(address[] indexed vehicleaddresses);



    function vehicleregistration (address _vehicleaddress, string memory _vehiclename, string memory _cartype ) public returns (address, string memory  ) {
      uint256 index=0;
      
      // We set it amoong the registered hashmaps
      registeredentitiesasddress[_vehicleaddress]=_vehicleaddress;
     
     // We design a fabonacci algorithm to create a pseudonym
     //bytes memory  fibonacci = abi.encodePacked(_vehicleaddress);
     string memory  fibonaccistring = "placeholder";
   
    // multiwalletlist.push ([addressstring,safestring]);
 

   //  listofownersafe = OwnerSafeHere(walletaddress,safestring );
      // We store the vehicle nodes on the blockchain and set it as registered with details
   
  
    vehiclenode =Vehicle(_vehicleaddress,_vehiclename, _cartype,index,fibonaccistring, true );
     vehiclelist[_vehicleaddress].vehicleaddress=_vehicleaddress;
     vehiclelist[_vehicleaddress].vehiclename=_vehiclename;
     vehiclelist[_vehicleaddress].cartype=_cartype;
      vehiclelist[_vehicleaddress].proposalindex=index;
     vehiclelist[_vehicleaddress].pseudorandomnum=fibonaccistring;
     vehiclelist[_vehicleaddress].active= true;
     
        bytes memory bytifiedwalletaddress = abi.encodePacked(_vehicleaddress);
     string memory stringifiedaddressforvehicle = bytesToString(bytifiedwalletaddress);
      allpseudonymstring.push ([stringifiedaddressforvehicle,fibonaccistring]);

      
      vehiclestore.push(vehiclenode);
    // We store the pseudorandom value as well
    registeredentitiespseudonymlist[fibonaccistring] = fibonaccistring;
      alladdresses[index]=stringifiedaddressforvehicle;
      allmypseudonyms[index]=fibonaccistring;
      // Events logged on the blockchain
      emit registrationevent( _vehicleaddress,   _vehiclename,   _vehiclename  );
     // We increase the number of vehicles registered count
      index++;
      
    return (_vehicleaddress,fibonaccistring);
   
   
    }

function GetVehicleDetailViaAddress  (address _vehicleaddress) external returns ( address _myvehicleaddress,   string memory _myvehiclename, string memory  _mycartype, uint256  _proposalindex, string memory _pseudorandomnum,  bool  _active ) {
 
       require (registeredentitiesasddress[_vehicleaddress]==_vehicleaddress,  "Address is not registered, try registering");
   
   address  myvehicleaddress = vehiclelist[_vehicleaddress].vehicleaddress;
    string memory myvehiclename = vehiclelist[_vehicleaddress].vehiclename;
    string memory mycartype = vehiclelist[_vehicleaddress].cartype;
     uint256  proposalindex=  vehiclelist[_vehicleaddress].proposalindex;
    string memory pseudorandomnum= vehiclelist[_vehicleaddress].pseudorandomnum;
  
   bool active= vehiclelist[_vehicleaddress].active;

      emit GetVehicleDetailViaAddressEvent(myvehicleaddress,myvehiclename,mycartype, proposalindex, pseudorandomnum,active);
 
      
    return (myvehicleaddress,myvehiclename,mycartype, proposalindex, pseudorandomnum,active);
   
   
    }



function GetAllRegisteredAddress () external returns (string[] memory _alladdresses) {
  
      
    return (alladdresses);
 
  
   
    }
function GetAllPseudonymAddress () external returns (string[] memory _allpseudonymnstrings) {

      
    return (allmypseudonyms);
 
     }

//Revoke
//

function CheckIfVehicleExistsViaAddress  (address _vehicleaddreess) external returns (bool existent ) {
      require (registeredentitiesasddress[_vehicleaddreess]==_vehicleaddreess,  "Address is not registered, try registering");
    bool  _existent = true;   
      
    return (_existent);
   
   
    }
function CheckIfVehicleExistsViaPseudonym  (string memory _pseudorandomnum) external returns (bool existent ) {
      
bool  _existent=false;
      //   bytes memory yourpseudonym = abi.encodePacked(_pseudorandomnum);
    // string memory _yourpseudonym = bytesToString(yourpseudonym);

      //    bytes memory myamazingpseudonym = abi.encodePacked(registeredentitiespseudonymlist[_pseudorandomnum]);
   //  string memory superpseudonym = bytesToString(myamazingpseudonym);
 if(equal(registeredentitiespseudonymlist[_pseudorandomnum],_pseudorandomnum) == true){
              
             

    bool  _existent = true;   
 }
    return (_existent);
   
   
    }


    function RevokeVehicle(uint256 index) public returns(bool){
    alladdresses[index] = alladdresses[alladdresses.length - 1];
   
    alladdresses.pop();
  
      return true;
  }


  function getLength() public view returns(uint){
   return alladdresses.length;
}

   function ReAddVehicle(address _vehicleaddreess) public  returns(string memory, uint){
          bytes memory bytifiedwalletaddress = abi.encodePacked(_vehicleaddreess);
     string memory stringifiedaddressforvehicle = bytesToString(bytifiedwalletaddress);
    
       alladdresses.push(stringifiedaddressforvehicle);
  return (stringifiedaddressforvehicle, alladdresses.length );
}
  
  function revokebyaddress (address _vehicleaddress) public returns (address ) {
       delete registeredentitiesasddress[_vehicleaddress];
     uint256 myindex =    vehiclelist[_vehicleaddress].proposalindex;
      RevokeVehicle(myindex) ;
      return( _vehicleaddress);
  
  }



 function compare(string memory _a, string memory _b) public virtual returns (int) {
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
  
    function equal(string memory _a, string memory _b) public virtual  returns (bool) {
        return compare(_a, _b) == 0;
    }

function bytesToString(bytes memory byteCode) public virtual pure returns(string memory stringData)
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
