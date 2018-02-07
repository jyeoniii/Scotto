pragma solidity ^0.4.0;

contract Common {
    struct creator {
      address addr;
      uint tokenAmount;
    }

    function max(uint x, uint y, uint z) returns (uint, uint, uint){
        if (x > z) {
            if (x > y) return x;
            else if (x == y) return (x, y);
            else return y;
        }else {
            if (z > y) return z;
            else return y;
        }
    }
}
