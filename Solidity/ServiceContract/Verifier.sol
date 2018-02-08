pragma solidity ^0.4.19;
import "browser/People.sol";

contract Verifier is People{
    uint8 result;
    function Verifier(address _addr, uint _tokenAmount, uint8 _result) public {
        addr = _addr;
        tokenAmount = _tokenAmount;
        result = _result;
    }

    function getResult() public view returns (uint8){
        return result;
    }

}
