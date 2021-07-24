//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6;
contract project {
    struct customer{
        uint8 mobile;
        bool reg;
        uint64 l_id;
    }
mapping(address=>customer) allcustomers;

struct available_drops{
address userid;
address autoid;
uint8[] quotes;
address[] quote_add;
uint8[] timeofquote;
mapping(address=>uint8) addtoind;
uint8 quote_l;
bool quote_acc;
string source;
string dest;
uint8 amount_paid;
bool dropped;
uint8 id;
uint otp_of_user;
}
uint8 lastid;
mapping(uint8=>available_drops) drops_available;

function signup_as_customer(address add, uint8 mob) public{
    allcustomers[add].mobile=mob;
    allcustomers[add].reg=true;
}

struct driver{
    uint8 mobile;
    string link;
    bool reg;
}
mapping( address=> driver) alldrivers;

function signup_as_driver(address add, uint8 mob, string memory link) public{
    alldrivers[add].mobile=mob;
    alldrivers[add].link=link;
    alldrivers[add].reg=true;
}  

function is_registered_driver(address add) public view returns(bool){
   return alldrivers[add].reg;
}

function generate_otp_for_drop() public view returns (uint){
return uint(keccak256(abi.encodePacked(now,msg.sender,lastid)))%10000;
   }
   
function add_drop(string memory source,string memory dest) public{
lastid+=1;
drops_available[lastid].id=lastid;
drops_available[lastid].userid=msg.sender;
drops_available[lastid].source=source;
drops_available[lastid].dest=dest;
drops_available[lastid].otp_of_user=generate_otp_for_drop();
allcustomers[msg.sender].l_id=lastid;
   }
   
function give_a_quote(address add,uint8 id, uint8 am, uint8 time) public returns(bool){
       if(is_quote_given(add,id)){
           return false;
       }
    drops_available[id].quote_l=drops_available[id].quote_l+1;
   uint8 l= drops_available[id].quote_l;
   drops_available[id].quotes[l]=am;
   drops_available[id].timeofquote[l]=time;
   drops_available[id].quote_add[l]=add;
   drops_available[id].addtoind[add]=l;
 return true; 
}

function is_quote_given(address add, uint8 id) public view returns(bool){
    if(drops_available[id].addtoind[add]!=0)
    return true;
    return false;
}
function accept_a_quote(uint8 id,address  add) public{
    drops_available[id].quote_acc=true;
    drops_available[id].autoid=add;
    drops_available[id].amount_paid= drops_available[id].quotes[drops_available[id].addtoind[add]];
}
function is_quote_accepted(uint8 id) public view returns(bool){
    return  drops_available[id].quote_acc;
}

function reject_a_quote(uint8 id) public{
    drops_available[id].quote_acc=false;
    drops_available[id].autoid=0x0000000000000000000000000000000000000000;
    drops_available[id].amount_paid=0;
}

function accept_drop(uint8 id, uint otp) public returns(bool){
    if(drops_available[id].otp_of_user==otp){
        drops_available[id].dropped=true;
        return true;
    }
    return false;
}

function all_unpicked_drops() public  view returns(uint8[] memory ){
uint8[] memory allids=new uint8[](50);
uint8 z=0;
uint8 i=0;
for(i=1;i<=lastid;i++){
    if(drops_available[i].dropped==false){
if(z<50){
        allids[z]=i;
        z=z+1;}
        else{
            break;
        }

    }
}
return allids;
}


}
