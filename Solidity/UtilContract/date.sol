pragma solidity ^0.4.0;


import "browser/DateTime.sol";


contract Util {

uint[] result;
 event arrayLog(uint i);

 DateTime dateTime = new DateTime();

    function Util() {

    }
  function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute)
   constant returns (uint){

     return dateTime.toTimestamp(year, month, day, hour, minute);
   }


   function toNow() returns (uint){
       return now;
   }
  function toDate()
   {

    result.push(dateTime.getYear(now));
    result.push(dateTime.getMonth(now));
    result.push(dateTime.getDay(now));
    result.push(dateTime.getHour(now));
    result.push(dateTime.getMinute(now));

    for(uint i = 0; i < result.length; i ++){
    arrayLog(result[i]);
    }

   }
}
