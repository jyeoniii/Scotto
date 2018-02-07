pragma solidity ^0.4.19;

contract Common {


    function maxResult(uint8 a, uint8 b, uint8 c) returns (uint8[3]){

        uint8[3] memory winner;
        if(a > b){
            if(b >= c)
            winner[0] = 1; // a > b >= c

            else if(a > c)
                winner[0] = 1; // a > c > b

            else if(a < c)
                winner[2] = 1; // c > a > b

            else if( a== c){  // a == c > b
                winner[0] = 1;
                winner[2] = 1;
            }

        }
        else if(a < b){
            if( a >= c)
            winner[1] = 1; //b > a >= c
            else if( b > c)
            winner[1] = 1; // b > c > a
            else if( b < c)
            winner[2] = 1;
            else if( b == c){
                winner[1] = 1;
                winner[2] = 1;
            }
        }

        else if(a == b){
            if(a < c) winner[2] = 1;
            else if( a > c) {
                winner[0] = 1;
                winner[1] = 1;
            }
            else{
                winner[0] = 1;
                winner[1] = 1;
                winner[2] = 1;
            }
        }


    }


}
