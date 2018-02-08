pragma solidity ^0.4.11;
import "browser/People.sol";

contract Creator is People{

    function Creator (address _addr, uint _tokenAmount) public {
        addr = _addr;
        tokenAmount = _tokenAmount;
    }


}
