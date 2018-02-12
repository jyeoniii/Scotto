pragma solidity ^0.4.11;
import "browser/Game.sol";

import "browser/Token.sol";

contract Main is Scottoken{

    event MainBalanceLog(uint etherAmount, uint tokenAmount);

    modifier logging(){
        _;
        MainBalanceLog(this.balance, balanceOf(this));
    }

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

    function createGame(string gameInfoStr, uint timestamp, uint tokenAmount) public returns (Game[]){
        require(tokenAmount > 0 && tokenAmount <= balanceOf(msg.sender));
        //require(isCreatingTime(timestamp) == true);
        // require(tokenAmount >= getCirculation()); // Not Implemented yet
        // require(tmpGame.creators.length < MIN_CREATORS);

        tempGame storage tmpGame = tempGames[gameInfoStr];
        Creator _creator = new Creator(msg.sender, tokenAmount);

        tmpGame.creators.push(_creator);
        tmpGame.totalToken += tokenAmount;

        // token transfer process
        __balanceOf[msg.sender] -= tokenAmount;
        __balanceOf[this] += tokenAmount;

        // Create game if condition is met
        if (tmpGame.creators.length >= 1 ) {
            Game game = new Game(id++, tmpGame.creators, tmpGame.totalToken, timestamp);
            games.push(game);
            this.approve(game, tmpGame.totalToken); // approve game instance to transfer token in Main Contract
        }

        return games;
    }

    function betGame(uint _id, uint tokenAmount, uint8 result) public logging payable {
        require(tokenAmount > 0 && tokenAmount <= balanceOf(msg.sender));
        require(result>= 0 && result <= 2);
        // require(isBettingTime(game));

        Game game = games[_id];
        game.addBettingInfo(msg.sender, msg.value, tokenAmount, result);
        game.transfer(msg.value);

        //token transfer process
        __balanceOf[msg.sender] -= tokenAmount;
        __balanceOf[this] += tokenAmount;

        this.approve(game, tokenAmount); // approve game instance to transfer token in Main Contract
    }


    function enterResult(uint _id, uint tokenAmount, uint8 result) logging public {
        // require(isResultTime(game));
        Game game = games[_id];
        game.enterResult(msg.sender, tokenAmount, result);

       __balanceOf[msg.sender] -= tokenAmount;
       __balanceOf[this] += tokenAmount;

       this.approve(game, tokenAmount); // approve game instance to transfer token in Main Contract
    }


    function checkResult(uint _id) logging public { // when user triggers event after the result has been decided
        Game game = games[_id];
        // require(isRewardingTime(game));
        game.finalize();
    }

    /* Functions checking game status */
    function isCreatingTime(uint start) private view returns (bool){
        return ( now >= start - CREATE_START && now <start - CREATE_PERIOD ); // 임시
    }

    function isBettingTime(Game game) private view returns (bool){
        uint start = game.getStartTime();
        return (now < start && now > start - BETTING_TIME);
    }

    function isResultTime(Game game) private view returns (bool){
        uint start = game.getStartTime();
        return (now > start + PLAYING_TIME && now < start + PLAYING_TIME + RESULT_TIME);
    }

    function isRewardingTime(Game game) private view returns (bool){
        uint start = game.getStartTime();
        return (now > start + PLAYING_TIME + RESULT_TIME);
    }

}
