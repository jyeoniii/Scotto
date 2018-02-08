pragma solidity ^0.4.11;
import "browser/People.sol";

contract Participant is People{
    address private addr;
    uint private tokenAmount;
    uint private etherAmount;
    uint8 private result;

    function Participant (address _addr, uint _etherAmount, uint _tokenAmount, uint8 _result) public {
        addr = _addr;
        etherAmount = _etherAmount;
        tokenAmount = _tokenAmount;
        result = _result;
    }


    function getEtherAmount() public view returns (uint){
        return etherAmount;
    }

    function getResult() public view returns (uint8){
        return result;
    }
}
