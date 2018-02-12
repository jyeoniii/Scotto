pragma solidity ^0.4.11;

contract Creator {

    address addr;
    uint tokenAmount;

    function Creator (address _addr, uint _tokenAmount) public {
        addr = _addr;
        tokenAmount = _tokenAmount;
    }

    function getAddr() public view returns (address) {
      return addr;
    }

    function getTokenAmount()public view returns (uint){
      return tokenAmount;
    }


}
