pragma solidity ^0.4.0;

import "browser/Game.sol";

contract Main {

    struct creator {
      address addCreator;
      uint tokenAmount;
    }


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
        require(creators[gameInfoStr] < 20);

        creator creator;
        creator.address = msg.sender;
        creator.tokenAmount = tokenAmount;

        creators[gameInfoStr].push(creator);

        if (creators.length >= 20  ) {
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
      return ( now >= start - 7 days && now <start - 3 days ) // 임시
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
