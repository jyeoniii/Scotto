pragma solidity ^0.4.18;
import "browser/Creator.sol";
import "browser/People.sol";
import "browser/Participant.sol";
import "browser/Verifier.sol";
import "browser/Token.sol";

contract Game {


   ERC20 token;
   event RewardLog();



    struct gameResult {
        Verifier[] verifiers;
        uint totalToken;
    }

    /* Constants for compenstation*/

    // Ether Pool
    uint8 private constant ETHER_POOL_FEE = 1;

    // Ether fee (sum = 10)
    uint8 private constant ETHER_FEE_CREATOR = 1;
    uint8 private constant ETHER_FEE_VERIFIER = 1;
    uint8 private constant ETHER_FEE_PROVIDER = 8;

    // Token Pool (sum=10)
    uint8 private constant TOKEN_POOL_WINNER = 1;
    uint8 private constant TOKEN_POOL_LOSER = 3;
    uint8 private constant TOKEN_POOL_CREATOR = 3;
    uint8 private constant TOKEN_POOL_VERIFIER = 3;

    /* Constants end */

    // game Info
    uint id ; // 게임 고유 id
    uint start; // 시작 시간 timestamp
    uint8[] finalResult; // 최종 게임 결과
    uint8[] loseResult; // wrong game result



    Creator[] creators; // 경기 등록한 사람들 목록
    mapping(uint8 => Participant[]) public betting; //length should be 3

    gameResult[3] results;


    uint creatorTokens = 0;           // Tokens from creators
    uint rewardTokenPool = 0;         // Tokens from every participants & wrong verifier
    uint winnerTokenPool = 0;
    uint loserTokenPool = 0;
    uint rightVerifierTokenPool = 0;  // Tokens from right verifier
    uint wrongVerifierTokenPool = 0;  // Tokens from wrong verifier
    uint totalEtherPool = 0;          // Ether from every participants = etherForCompensation + etherForWinners
    uint etherForCompensation = 0;    // Ether from losers only (90%: for winner, 10%: fee)
    uint etherForWinners = 0;          // Total Ether from winner
    uint[3] resultEtherPool;          // Total Ether betted to certain results from participants
    uint[3] resultTokenPool;
    function Game(uint _id, Creator[] _creators, uint _creatorTokens, uint timestamp) public {
        id = _id;
        creators = _creators;
        start = timestamp;
        creatorTokens = _creatorTokens;


        token =  ERC20(msg.sender); //use SCOTTOKEN instance
    }

    /*
    result: 0 (bet to A)
            1 (bet to Draw)
            2 (bet to B)
            TODO: should be payable
    */

    event addrLog(address);
    event ethLog(uint);
    event tokLog(uint);

    function addBettingInfo(Participant participant) public {

        Participant part =  Participant(participant);
        uint8 result = participant.getResult();
         uint etherAmount = participant.getEtherAmount();
         uint tokenAmount = participant.getTokenAmount();

        betting[result].push(part);

        resultEtherPool[result] += etherAmount;
        resultTokenPool[result] += tokenAmount;

        totalEtherPool += etherAmount;

        rewardTokenPool += etherAmount;
        addrLog(betting[1][0].getAddr());
    }

    function enterResult(Verifier verifier) public {
         Participant x = Participant(betting[1][0]);
         results[verifier.getResult()].verifiers.push(verifier);
         results[verifier.getResult()].totalToken += verifier.getTokenAmount();
         rewardTokenPool += verifier.getTokenAmount();
          addrLog(x.getAddr());
    }

    function getStartTime() public view returns (uint) {
        return start;
    }

    /*
    Close the game
    Determine the results
    Reward participants
     */
    function finalize()public returns (uint8[]) {
      this.maxResult(results[0].totalToken, results[1].totalToken, results[2].totalToken);
         tokLog(betting[1][0].getTokenAmount());
      //for(uint8 i = 0; i < finalResult.length; i++){
         //initDistribute(finalResult[0]); // give ether back to winners & give token back to right verifiers
        // etherForWinners += resultEtherPool[finalResult[i]];
        // rightVerifierTokenPool += results[finalResult[i]].totalToken;
        // winnerTokenPool += resultTokenPool[finalResult[i]];
      //}

      rewardTokenPool -= rightVerifierTokenPool;
      etherForCompensation = totalEtherPool - etherForWinners; //etherForCompensation: Ether from losers only

    //   reward();
    //   myAddress.transfer(etherForCompensation * 8 / 10 /10 );


    }

    // Rewarding functions
    /* rewardCreators()
    Creators of the game would receive
        1. Ether: etherPool * 0.1 * 0.1
        2. Tokens: Same amount with collateralized tokens
    */
    function rewardCreators() public payable {
        // 10% of etherForCompensation will be used for fee => 10% of it will be used to reward creators
        uint etherForCreators = (etherForCompensation * ETHER_POOL_FEE / 10) * ETHER_FEE_CREATOR / 10;
        uint tokenForCreators = rewardTokenPool * TOKEN_POOL_CREATOR / 10;

        // give token back to creators
        for (uint i=0; i<creators.length; ++i) {
            token.transferFrom(token, creators[i], creators[i].getTokenAmount());
        }


        for (i=0; i<creators.length; ++i) {
            // token compensation for creators
            token.transferFrom(token, creators[i], tokenForCreators * creators[i].getTokenAmount() / creatorTokens);

            // ethereum compensation for creators
            creators[i].getAddr().transfer(etherForCreators * creators[i].getTokenAmount() / creatorTokens);
        }

    }

    function rewardParticipants() public payable {

        uint etherForPariticipants = etherForCompensation * (10 - ETHER_POOL_FEE) / 10;
        uint tokenForWinners = rewardTokenPool * TOKEN_POOL_WINNER / 10;
        uint tokenForLosers = rewardTokenPool * TOKEN_POOL_LOSER / 10;
        Participant part;

        // Reward winners
        for(uint8 k = 0; k < finalResult.length; k++)
          for (uint i=0; i<betting[k].length; ++i) {
             part = betting[k][i];
             address(part).transfer( etherForPariticipants * 95 / 100 * part.getEtherAmount() / etherForWinners); // ether compensation
             /* TODO: Additional rewarding propostional to the amount of token betted */
             address(part).transfer( etherForPariticipants * 5 / 100 * part.getEtherAmount() / winnerTokenPool);
             token.transferFrom(token,address(part),tokenForWinners * part.getTokenAmount() / winnerTokenPool );
          }

         // Reward losers
         for( k = 0; k < loseResult.length; k++)
          for ( i=0; i<betting[k].length; ++i) {
              part = betting[k][i];

             token.transferFrom(token,address(part),tokenForLosers * part.getTokenAmount() / loserTokenPool );
          }

    }

    function rewardVerifier() public payable {
        uint etherForVerifiers = (etherForCompensation * ETHER_POOL_FEE / 10) * ETHER_FEE_VERIFIER / 10;
        uint tokenForVerifiers = rewardTokenPool * TOKEN_POOL_VERIFIER / 10;

        for(uint8 i = 0 ; i < finalResult.length; i ++)
            for (uint j=0; j < results[i].verifiers.length; j ++ ) {
                Verifier verifier = results[i].verifiers[j];
                address addr = verifier.getAddr();

                // ether compensation for verifiers
                addr.transfer(etherForVerifiers * verifier.getTokenAmount() / rightVerifierTokenPool); // ether compensation
                // token compensation for verifiers
                token.transferFrom(token, addr, tokenForVerifiers * verifier.getTokenAmount() / rightVerifierTokenPool);
            }



    }
    event strLog(string);
    function initDistribute(uint8 result) public  {

        //give token back to winners

            tokLog(betting[1][0].getTokenAmount());
        // for (uint i=0; i<betting[result].length; ++i){

             //addrLog(betting[result][0].getAddr()); // ether compensation
        // }

        //give token back to right verifiers
        // for ( i = 0; i < results[result].verifiers.length; ++i){
        //     Verifier ver = results[result].verifiers[i];
        //     token.transferFrom(token, ver.getAddr(), ver.getTokenAmount());
        // }
    }

    function maxResult(uint a, uint b, uint c) external {

       if(a > b){
            if(b >= c )
                {
                    finalResult = [0];
                    loseResult = [1,2];

                }
            else if(a > c)
               {
                   finalResult = [0];
                   loseResult = [1,2];
               }
            else if(a < c)
                {
                    finalResult = [2];
                    loseResult = [0,1];
                }
            else if( a== c){
               {
                   finalResult = [0,2];
                   loseResult = [1];
               }
            }

        }
        else if(a < b){
            if( a >= c)
            {
                finalResult = [1];
                loseResult = [0,2];
            }
            else if( b > c)
            {
                finalResult = [1];
                loseResult = [0,2];
            }
            else if( b < c)
           {
               finalResult = [2];
               loseResult = [0,1];
           }
            else if( b == c){
               {
                   finalResult = [1,2];
                   loseResult [0];
               }
            }
        }

        else if(a == b){
             if(a < c)
          {
              finalResult = [2];
              loseResult = [0,1];
          }
            else if( a > c) {
                finalResult = [0,1];
                loseResult = [2];
            }
            else{
                finalResult = [0,1,2];
            }
        }

    }

      function () public payable {
  }
        function getBal() public returns (uint){
            return this.balance;
        }
}
