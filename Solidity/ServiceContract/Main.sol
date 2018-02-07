pragma solidity ^0.4.0;

import "browser/Game.sol";

contract Main {

    struct creator {
      address addr;
      uint tokenAmount;
    }


    uint private constant MIN_CREATORS = 20;
    uint private constant CREATE_START = 7 days;
    uint private constant CREATE_PERIOD = 4 days;


    uint private id = 0;
    Game[] private games;

    RewardingContract reward;


    mapping (string => creator[]) private creators; // string: identifier of the game

    function Main() {
        reward = new RewardingContract();
    }

    function createGame(string gameInfoStr, uint timestamp, uint tokenAmount) {
        require(isCreating(timestamp) == true);
        require(tokenAmount >= getCirculation());
        require(creators[gameInfoStr] < MIN_CREATORS);

        creator _creator;
        _creator.addr = msg.sender;
        _creator.tokenAmount = tokenAmount;

        _creators[gameInfoStr].push(creator);

        if (creators.length >= MIN_CREATORS ) {
            Game game = new Game(id++, creators[gameInfoStr], timestamp);
            games.push(game);
        }
    }

    function betGame(uint id, uint numEther, uint numToken, uint scoreA, uint scoreB) {
        require(/*compare timestamp*/);
        games[id].addBettingInfo(/*..*/);
    }


    function enterResult(uint id, uint scoreA, uint scoreB) {
        require(/*compare timestamp*/);
        games[id].enterResult(scoreA, scoreB, msg.sender);
    }


    function checkResult(uint id) { // when user triggers event after the result has been decided
        games[id].finalize();
        reward.reward(games[id]);
    }

    function isCreating(uint start) public returns (bool){
      return ( now >= start - CREATE_START && now <start - CREATE_PERIOD ); // 임시
    }
}

contract RewardingContract {

    address private owner;

    modifier ownerFunc {
      require(owner == msg.sender);
      _;
    }

    function RewardingContract() public {
        owner = msg.sender;
    }

    function reward(Game game) ownerFunc public {
        rewardCreators(game);
        rewardParticipants(game);
        rewardVerifier(game);
    }

    function rewardCreators() private {

    }

    function rewardParticipants() private {

    }

    function rewardVerifier() private {

    }

}
