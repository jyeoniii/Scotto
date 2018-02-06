contract Util(){


 address public dateTimeAddr = 0x8Fc065565E3e44aef229F1D06aac009D6A524e82;
 DateTime dateTime = DateTime(dateTimeAddr);


  function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute)
   constant returns (uint){

     return dateTime.toTimestamp(year, month, day, hour, minute);
   }

  function toDate(uint timestamp)
  constant returns (uint){
    string x =

  }
  function idxConversion(uint date, string teamA, string teamB)
  external returns (string){

  }
}
