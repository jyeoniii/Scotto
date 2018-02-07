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

    // A vs B
    uint id ; // 게임 고유 id
    string gameInfoStr; // 날짜 리그 팀에 대한 정보를 하나의 스트링으로 저장

    // date
    uint start; // 시작 시간 timestamp

    Creator[] creators; // 경기 등록한 사람들 목록
    //--------------------
    // participants
    mapping(uint8 => bettingInfo[]) betting; //length should be 3
    gameResult[] results;       //length should be 3

    function Game(uint _id, Creator[] _creators, uint timestamp) public {
        id = _id;
        creators = _creators;
        start = timestamp;
    }

    /*
    result: 0 (bet to A)
            1 (bet to Draw)
            2 (bet to B)
    */
    function addBettingInfo(address addr, uint numEther, uint numToken, uint8 result){
        require(result>=0 && result<=2);

        bettingInfo memory info = bettingInfo(addr, numEther, numToken);
        betting[result].push(info);
    }

    function enterResult(uint8 res, uint numToken, address addr) {
        verifierInfo x;
        x.addr = addr;
        x.numToken = numToken;
        results[res].verifiers.push(x);
        results[res].totalToken += numToken;
    }

    function getStartTime() returns (uint){
        return start;
    }

    /*
    Close the game
    Determine the results
    Reward participants
     */
    function finalize() {
      uint8[3] memory winner = maxResult(results[0].totalToken, results[1].totalToken, results[2].totalToken);


    }

    // Rewarding functions
    function rewardCreators() private {

    }

    function rewardParticipants() private {

    }

    function rewardVerifier() private {

    }


}
