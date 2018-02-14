pragma solidity ^0.4.18;
import "./Creator.sol";
import "./Token.sol";

contract Game {


    ERC20 token;
    bool close = false;

    event bettingLog(uint result, address addr, uint etherAmount, uint tokenAmount);
    event verifyingLog(uint result, address addr, uint tokenAmount);


    struct Participant {
        address addr;
        uint etherAmount;
        uint tokenAmount;
        uint8 result;
    }

    struct Verifier {
        address addr;
        uint tokenAmount;
        uint8 result;
    }

    struct resultStatus {
      Participant[] participants;
      uint totalEtherBetted;
      uint totalTokenBetted;

      Verifier[] verifiers;
      uint totalTokenFromVerifiers;
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
    string gameInfoStr; // game information in string

    uint8[] finalResult; // 최종 게임 결과
    uint8[] loseResult; // wrong game result

    Creator[] creators; // 경기 등록한 사람들 목록
    uint creatorTokens = 0;           // Tokens from creators

    resultStatus[3] resultStat;

    event log(uint);

    // To decide compenstation ratio of each
    uint winnerEtherAmount = 0;       // Total Ether betted from winner - will be used to decide compensation ratio
    uint winnerTokenAmount = 0;
    uint loserTokenAmount = 0;
    uint rightVerifierTokenAmount = 0;

    uint etherForCompensation = 0;    // Ether from losers only (90%: for winner, 10%: fee)
    uint rewardTokenPool = 0;         // Tokens from every participants & wrong verifier


    function Game(uint _id, string _gameInfoStr, Creator[] _creators, uint _creatorTokens, uint timestamp) public {
        id = _id;
        gameInfoStr = _gameInfoStr;
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
    function addBettingInfo(address sender, uint etherAmount, uint tokenAmount, uint8 result) public {

        Participant memory part = Participant(sender, etherAmount, tokenAmount, result);
        resultStat[result].participants.push(part);

        resultStat[result].totalEtherBetted += etherAmount;
        resultStat[result].totalTokenBetted += tokenAmount;

        /* addrLog(resultStat[result][0].getAddr()); */
        bettingLog(result, sender, etherAmount, tokenAmount);
    }

    function enterResult(address sender, uint tokenAmount, uint8 result) public {
         /* Participant x = Participant(betting[1][0]); */
         Verifier memory verifier = Verifier(sender, tokenAmount, result);

         resultStat[result].verifiers.push(verifier);
         resultStat[result].totalTokenFromVerifiers += tokenAmount;

          /* addrLog(x.getAddr()); */
          verifyingLog(result, verifier.addr, verifier.tokenAmount);
    }

    function getStartTime() public view returns (uint) {
        return start;
    }

    /*
    Close the game
    Determine the results
    Reward participants
     */
    function finalize() public returns (uint8[]) {
      uint8 winIdx;
      uint8 loseIdx;
      resultStatus memory stat;

      this.maxResult(resultStat[0].totalTokenFromVerifiers, resultStat[1].totalTokenFromVerifiers, resultStat[2].totalTokenFromVerifiers);

      // Winner result
      for(uint i = 0; i < finalResult.length; i++){
         winIdx = finalResult[i];
         initDistribute(winIdx); // give ether back to winners & give token back to right verifiers

         stat = resultStat[winIdx];
         winnerEtherAmount += stat.totalEtherBetted;
         winnerTokenAmount += stat.totalTokenBetted;
         rightVerifierTokenAmount += stat.totalTokenFromVerifiers;

         rewardTokenPool += stat.totalTokenBetted;
      }

      // Loser result
      for (i=0; i<loseResult.length; ++i) {
        loseIdx = loseResult[i];
        stat = resultStat[loseIdx];

        etherForCompensation += stat.totalEtherBetted;
        loserTokenAmount += stat.totalTokenBetted;

        rewardTokenPool += stat.totalTokenBetted + stat.totalTokenFromVerifiers;
      }

      this.rewardCreators();
      this.rewardParticipants();
      this.rewardVerifier();

    }

    // Rewarding functions
    /* rewardCreators()
    Creators of the game would receive
        1. Ether: etherPool * 0.1 * 0.1
        2. Tokens: Same amount with collateralized tokens
    */
    event rewardCreatorLog(uint baseToken, uint rewardToken, uint rewardEther);
    function rewardCreators() public payable {
        // 10% of etherForCompensation will be used for fee => 10% of it will be used to reward creators
        uint etherForCreators = (etherForCompensation * ETHER_POOL_FEE / 10) * ETHER_FEE_CREATOR / 10;
        uint tokenForCreators = rewardTokenPool * TOKEN_POOL_CREATOR / 10;


        for (uint i=0; i<creators.length; ++i) {
            // give token back to creators
            token.transferFrom(token, creators[i].getAddr(), creators[i].getTokenAmount());

            // token compensation for creators
            token.transferFrom(token, creators[i].getAddr(), tokenForCreators * creators[i].getTokenAmount() / creatorTokens);

            // ethereum compensation for creators
            creators[i].getAddr().transfer(etherForCreators * creators[i].getTokenAmount() / creatorTokens);

            rewardCreatorLog(creators[i].getTokenAmount(),
                             tokenForCreators * creators[i].getTokenAmount() / creatorTokens,
                             etherForCreators * creators[i].getTokenAmount() / creatorTokens);
        }

    }

    event rewardWinnerLog(uint tokenAmount, uint etherAmount, uint rewardToken, uint rewardEther, uint additionalEther);
    event rewardLoserLog(uint tokenAmount, uint rewardToken);
    function rewardParticipants() public payable {
        Participant memory part;
        Participant[] memory winners;
        Participant[] memory losers;
        uint etherForPariticipants = etherForCompensation * (10 - ETHER_POOL_FEE) / 10;
        uint ether95 = etherForPariticipants * 95 / 100;
        uint ether5 = etherForPariticipants * 5 / 100;
        uint tokenForWinners = rewardTokenPool * TOKEN_POOL_WINNER / 10;
        uint tokenForLosers = rewardTokenPool * TOKEN_POOL_LOSER / 10;


        // Reward winners
        for(uint8 k = 0; k < finalResult.length; k++){
          winners = resultStat[finalResult[k]].participants;
          for (uint i=0; i<winners.length; ++i) {
             part = winners[i];
             // Ether compensation proposional to the amount of ether betted
             part.addr.transfer( ether95 * part.etherAmount / winnerEtherAmount); // ether compensation
             // Additional ether rewarding propostional to the amount of token betted
             part.addr.transfer( ether5 * part.tokenAmount / winnerTokenAmount );

             // Token compenstation for encouraging - propositional to the amount of token betted
             token.transferFrom(token, part.addr, tokenForWinners * part.tokenAmount / winnerTokenAmount );

             rewardWinnerLog(part.tokenAmount,
                             part.etherAmount,
                             tokenForWinners * part.tokenAmount / winnerTokenAmount,
                             ether95 * part.etherAmount / winnerEtherAmount,
                             ether5 * part.tokenAmount / winnerTokenAmount
                             );
          }
        }

        // Reward losers
        for( k = 0; k < loseResult.length; k++){

           losers = resultStat[loseResult[k]].participants;
           for ( i=0; i<losers.length; ++i) {
             part = losers[i];

             // Token compenstation for encouraging - propositional to the amount of token betted
             token.transferFrom(token, part.addr,tokenForLosers * part.tokenAmount / loserTokenAmount );

             rewardLoserLog(part.tokenAmount, tokenForLosers * part.tokenAmount / loserTokenAmount);
           }
        }

    }

    event rewardVerifierLog(uint tokenAmount, uint rewardToken, uint rewardEther);
    function rewardVerifier() public payable {
        Verifier[] memory verifiers;
        Verifier memory verifier;

        uint etherForVerifiers = (etherForCompensation * ETHER_POOL_FEE / 10) * ETHER_FEE_VERIFIER / 10;
        uint tokenForVerifiers = rewardTokenPool * TOKEN_POOL_VERIFIER / 10;
        uint winnerIdx;
        address addr;

        for(uint8 i = 0 ; i < finalResult.length; i ++){
            winnerIdx = finalResult[i];
            verifiers = resultStat[winnerIdx].verifiers;
            for (uint j=0; j < verifiers.length; j ++ ) {
                verifier = verifiers[j];
                addr = verifier.addr;

                // ether compensation for verifiers
                addr.transfer(etherForVerifiers * verifier.tokenAmount / rightVerifierTokenAmount); // ether compensation
                // token compensation for verifiers
                token.transferFrom(token, addr, tokenForVerifiers * verifier.tokenAmount / rightVerifierTokenAmount);

                rewardVerifierLog(verifier.tokenAmount,
                                  tokenForVerifiers * verifier.tokenAmount / rightVerifierTokenAmount,
                                  etherForVerifiers * verifier.tokenAmount / rightVerifierTokenAmount);
            }
        }
    }

    function initDistribute(uint8 result) public {
        Participant memory part;
        Verifier memory ver;

        //give token back to winners
        Participant[] memory participants = resultStat[result].participants;

        for (uint i=0; i<participants.length; ++i){
           part = participants[i];
           part.addr.transfer(part.etherAmount);
        }

        // give token back to right verifiers
        Verifier[] memory verifiers = resultStat[result].verifiers;
        for ( i = 0; i < verifiers.length; ++i){
            ver = verifiers[i];
            token.transferFrom(token, ver.addr, ver.tokenAmount);
        }
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
                   loseResult = [0];
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

    function settle(address _owner) public payable{
        close = true;
        _owner.transfer(this.balance);
    }

    /* For frontend */
    function getGameInfo() public view returns (uint, string, uint){
        return (id, gameInfoStr, start);
    }

    function getBettingInfo() public view returns (uint, uint, uint, uint ,uint ,uint ){
        return (resultStat[0].totalEtherBetted, resultStat[0].totalTokenBetted,
                resultStat[1].totalEtherBetted, resultStat[1].totalTokenBetted,
                resultStat[2].totalEtherBetted, resultStat[2].totalTokenBetted);
    }

    function isClose() public view returns (bool){
        return close;
    }

    function () public payable {
    }
}
