pragma solidity ^0.4.11;
import "browser/Creator.sol";
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



    Creator[] creators; // 경기 등록한 사람들 목록
    mapping(uint8 => Participant[]) betting; //length should be 3

    Participant[] finalWinner;

    gameResult[3] results;


    uint creatorTokens = 0;
    uint tokenPool = 0;
    uint verifierTokenPool = 0;
    uint totalEtherPool = 0;
    uint etherForCompensation = 0;
    uint etherForWinner = 0;
    uint[3] resultEtherPool;

    function Game(uint _id, Creator[] _creators, uint _creatorTokens, uint timestamp) public {
        id = _id;
        creators = _creators;
        start = timestamp;
        creatorTokens = _creatorTokens;
        tokenPool += _creatorTokens;

        token =  ERC20(msg.sender); //use SCOTTOKEN instance
    }

    /*
    result: 0 (bet to A)
            1 (bet to Draw)
            2 (bet to B)
            TODO: should be payable
    */
    function addBettingInfo(Participant participant) public {

        uint8 result = participant.getResult();
        uint etherAmount = participant.getEtherAmount();

        betting[result].push(participant);

        resultEtherPool[result] += etherAmount;
        totalEtherPool += etherAmount;

        tokenPool += participant.getTokenAmount();

    }

    function enterResult(Verifier verifier) public {
         results[verifier.getResult()].verifiers.push(verifier);
         results[verifier.getResult()].totalToken += verifier.getTokenAmount();
         tokenPool += verifier.getTokenAmount();
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

      for(uint8 i = 0; i < finalResult.length; i++){
        etherForWinner += resultEtherPool[finalResult[i]];
        initDistribute(finalResult[i]); // refund to winners
        verifierTokenPool += results[finalResult[i]].totalToken;
      }

    //   etherForCompensation = totalEtherPool - etherForWinner;

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
        uint etherForCreators = etherForCompensation * 10 * ETHER_FEE_CREATOR / 10;

        for (uint i=0; i<creators.length; ++i) {

            creators[i].getAddr().transfer(etherForCreators * creators[i].getTokenAmount() / creatorTokens); // ether compensation
            // TODO: Give back collateralized tokens (=tokenAmount)
            // Not implemented yet
        }
    }

    function rewardParticipants() public payable {

     uint etherForPariticipants= etherForCompensation * 9 / 10;



    for(uint8 k = 0; k < finalResult.length; k++)
      for (uint i=0; i<betting[k].length; ++i)
         betting[k][i].getAddr().transfer( etherForPariticipants * betting[k][i].getEtherAmount() / etherForWinner); // ether compensation

    }

    function rewardVerifier()  public payable {
    uint etherForVerifiers = etherForCompensation / 10 * ETHER_FEE_VERIFIER / 10;

        for(uint8 i = 0 ; i < finalResult.length; i ++)
        for (uint j=0; j < results[i].verifiers.length; j ++ ) {
            results[i].verifiers[j].getAddr().transfer(etherForVerifiers * results[i].verifiers[j].getTokenAmount() / verifierTokenPool); // ether compensation
        }
    }

    function initDistribute(uint8 result) public payable {
        address addr;
        for (uint i=0; i<betting[result].length; ++i) {
            addr = betting[result][i].getAddr();
            addr.transfer(betting[result][i].getEtherAmount()); // ether compensation
        }
    }

    function maxResult(uint a, uint b, uint c) external {

       if(a > b){
            if(b >= c )
                finalResult = [0];
            else if(a > c)
                finalResult = [0];
            else if(a < c)
                finalResult = [2];
            else if( a== c){
                finalResult = [0,2];
            }

        }
        else if(a < b){
            if( a >= c)
            finalResult = [1];
            else if( b > c)
            finalResult = [1];
            else if( b < c)
            finalResult = [2];
            else if( b == c){
                finalResult = [1,2];
            }
        }

        else if(a == b){
             if(a < c)
            finalResult = [2];
            else if( a > c) {
                finalResult = [0,1];
            }
            else{
                finalResult = [0,1,2];
            }
        }

    }



}
