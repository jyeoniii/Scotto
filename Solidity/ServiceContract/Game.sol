pragma solidity ^0.4.19;
import "browser/Common.sol";
import "browser/Creator.sol";


contract Game is Common{

    struct bettingInfo{
        address addr;
        uint numEther;
        uint numToken;
    }

    struct verifierInfo {
        address addr;
        uint numToken;
    }

    struct gameResult {
        verifierInfo[] verifiers;
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


    Creator[] creators; // 경기 등록한 사람들 목록
    mapping(uint8 => bettingInfo[]) betting; //length should be 3
    gameResult[] results;


    uint creatorTokens = 0;
    uint tokenPool = 0;
    uint etherPool = 0;


    function Game(uint _id, Creator[] _creators, uint _creatorTokens, uint timestamp) public {
        id = _id;
        creators = _creators;
        start = timestamp;
        creatorTokens = _creatorTokens;
        tokenPool += _creatorTokens;
    }

    /*
    result: 0 (bet to A)
            1 (bet to Draw)
            2 (bet to B)
            TODO: should be payable
    */
    function addBettingInfo(address addr, uint numEther, uint numToken, uint8 result) public {
        require(result>=0 && result<=2);

        bettingInfo memory info = bettingInfo(addr, numEther, numToken);
        betting[result].push(info);

        tokenPool += numToken;
        etherPool += numEther;
    }

    function enterResult(uint8 res, uint numToken, address addr) public {
        verifierInfo memory verifier = verifierInfo(addr, numToken);

        results[res].verifiers.push(verifier);
        results[res].totalToken += numToken;

        tokenPool += numToken;
    }

    function getStartTime() public returns (uint) {
        return start;
    }

    /*
    Close the game
    Determine the results
    Reward participants
     */
    function finalize() public {
      uint8[3] memory winner = maxResult(results[0].totalToken, results[1].totalToken, results[2].totalToken);


    }

    // Rewarding functions
    /* rewardCreators()
    Creators of the game would receive
        1. Ether: etherPool * 0.1 * 0.1
        2. Tokens: Same amount with collateralized tokens
    */
    function rewardCreators() private {
        uint etherForCreators = etherPool * ETHER_FEE_CREATOR / 10;
        address addr;
        uint tokenAmount;

        for (uint i=0; i<creators.length; ++i) {
            addr = creators[i].getAddr();
            tokenAmount = creators[i].getTokenAmount();

            addr.transfer(etherForCreators * creators[i].getTokenAmount() / creatorTokens); // ether compensation
            // TODO: Give back collateralized tokens (=tokenAmount)
            // Not implemented yet
        }
    }

    function rewardParticipants() private {

    }

    function rewardVerifier() private {

    }


}
