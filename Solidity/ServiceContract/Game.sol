contract Game {

    struct creator {
      address addr;
      uint tokenAmount;
    }

    struct bettingInfo{
        address person;
        uint numEther;
        uint numToken;
    }

    struct result {
        uint count;
        address[] addrs;
    }

    //constant
    uint private constant BETTING_TIME = 3 days;
    uint private constant PLAYING_TIME = 3 hours;
    uint private constant RESULT_TIME = 18 hours;


    // A vs B
    uint id ; // 게임 고유 id
    string gameInfoStr; // 날짜 리그 팀에 대한 정보를 하나의 스트링으로 저장

    // date
    uint start; // 시작 시간 timestamp

    creator[] creators; // 경기 등록한 사람들 목록
    //--------------------
    // participants
    mapping (string => bettingInfo[]) betting;
    mapping (string => result) results;

    function Game(uint _id, creator[] _creators, uint timestamp) public {
        id = _id;
        creators = _creators;
        start = timestamp;
    }

    function addBettingInfo(address addr, uint numEther, uint numToken, uint scoreA, uint scoreB){
       string memory scoreStr = getScoreStr(scoreA, scoreB);
       betting[scoreStr].push(bettingInfo(addr, numEther, numToken));
    }

    function enterResult(uint scoreA, uint scoreB, address addr) {
        require();
        string memory scoreStr = getScoreStr(scoreA, scoreB);
        result res = results[scoreStr];
        res.count += 1;
        res.addrs.push(addr);
    }

    function getScoreStr(uint scoreA, uint scoreB) private returns (string) {
        return "scoreA:scoreB"; // how?
    }

    function isBetting() returns (bool){
      return (now < start && now > start - BETTING_TIME);
    }

    function isResult() returns (bool){
      return (now > start + PLAYING_TIME && now < start + PLAYING_TIME + RESULT_TIME);
    }

    function isReward() returns (bool){
      return (now > start + PLAYING_TIME + RESULT_TIME);
    }
}
