pragma solidity ^0.4.0;
import "browser/Common.sol";

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

    creator[] creators; // 경기 등록한 사람들 목록
    //--------------------
    // participants
    mapping(uint8 => bettingInfo[]) betting; //length should be 3
    gameResult[3] results;       //length should be 3

    function Game(uint _id, creator[] _creators, uint timestamp) public {
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
        results[res].verifiers.push(verifierInfo(addr, numToken));
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


    }

    // Rewarding functions
    function rewardCreators() private {

    }

    function rewardParticipants() private {

    }

    function rewardVerifier() private {

    }


}
