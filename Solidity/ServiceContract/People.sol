pragma solidity ^0.4.11;

contract People {

  address addr;
  uint tokenAmount;

  function getAddr() public view returns (address) {
      return addr;
  }

  function getTokenAmount()public view returns (uint){
      return tokenAmount;
  }

}
