pragma solidity ^0.4.19;

import "browser/Game.sol";
import "browser/Common.sol";
import "browser/Creator.sol";
contract Main is Common{

    struct tempGame {
        Creator[] creators;
        uint totalToken;
    }

    //constant
    uint private constant MIN_CREATORS = 20;
    uint private constant CREATE_START = 7 days;
    uint private constant CREATE_PERIOD = 4 days;
    uint private constant BETTING_TIME = 3 days;
    uint private constant PLAYING_TIME = 3 hours;
    uint private constant RESULT_TIME = 18 hours;

    uint private id = 0;
    Game[] private games;

    mapping (string => tempGame) private tempGames; // string: identifier of the game

    function createGame(string gameInfoStr, uint timestamp, uint tokenAmount) {
        tempGame tmpGame = tempGames[gameInfoStr];

        require(isCreatingTime(timestamp) == true);
        // require(tokenAmount >= getCirculation()); // Not Implemented yet
        require(tmpGame.creators.length < MIN_CREATORS);

        Creator _creator = new Creator(msg.sender, tokenAmount);


        tmpGame.creators.push(_creator);
        tmpGame.totalToken += tokenAmount;

        if (tmpGame.creators.length >= MIN_CREATORS ) {
            Game game = new Game(id++, tmpGame.creators, tmpGame.totalToken, timestamp);
            games.push(game);
        }
    }

    function betGame(uint id, uint numEther, uint numToken, uint8 result) {
        Game game = games[id];
        require(isBettingTime(game));
        games[id].addBettingInfo(msg.sender, numEther, numToken, result);
    }


    function enterResult(uint id, uint numToken, uint8 result) {
        Game game = games[id];
        require(isResultTime(game));
        game.enterResult(result, numToken, msg.sender);
    }


    function checkResult(uint id) { // when user triggers event after the result has been decided
        Game game = games[id];
        require(isRewardingTime(game));
        game.finalize();
    }

    /* Functions checking game status */
    function isCreatingTime(uint start) public returns (bool){
        return ( now >= start - CREATE_START && now <start - CREATE_PERIOD ); // 임시
    }

    function isBettingTime(Game game) returns (bool){
        uint start = game.getStartTime();
        return (now < start && now > start - BETTING_TIME);
    }

    function isResultTime(Game game) returns (bool){
        uint start = game.getStartTime();
        return (now > start + PLAYING_TIME && now < start + PLAYING_TIME + RESULT_TIME);
    }

    function isRewardingTime(Game game) returns (bool){
        uint start = game.getStartTime();
        return (now > start + PLAYING_TIME + RESULT_TIME);
    }
}
