pragma solidity ^0.4.19;

library Common {


    function maxResult(uint a, uint b, uint c) returns (bool[3]){

        bool[3] memory winner;
        if(a > b){
            if(b >= c)
            winner[0] = true; // a > b >= c

            else if(a > c)
                winner[0] = true; // a > c > b

            else if(a < c)
                winner[2] = true; // c > a > b

            else if( a== c){  // a == c > b
                winner[0] = true;
                winner[2] = true;
            }

        }
        else if(a < b){
            if( a >= c)
            winner[1] = true; //b > a >= c
            else if( b > c)
            winner[1] = true; // b > c > a
            else if( b < c)
            winner[2] = true;
            else if( b == c){
                winner[1] = true;
                winner[2] = true;
            }
        }

        else if(a == b){
            if(a < c) winner[2] = true;
            else if( a > c) {
                winner[0] = true;
                winner[1] = true;
            }
            else{
                winner[0] = true;
                winner[1] = true;
                winner[2] = true;
            }
        }


    }


}
