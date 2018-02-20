pragma solidity ^0.4.19;
import "./Game.sol";

import "./Token.sol";

contract Main is Scottoken{

    event MainBalanceLog(uint etherAmount, uint tokenAmount);
    event GameBalanceLog(uint id, uint etherAmount, uint tokenAmount);

    modifier logging(uint id){
        _;
        MainBalanceLog(this.balance, balanceOf(this));
        GameBalanceLog(id, games[id].balance, balanceOf(games[id]));
    }

    modifier ownerFunc {
      require(_owner == msg.sender);
      _;
    }

    struct tempGame {
        address[] creatorArray;
        uint[] tokenArray;
        uint totalToken;
    }



    //constant
    uint private constant MIN_CREATORS = 1;
    uint private constant CREATE_START = 7 days;
    uint private constant CREATE_PERIOD = 4 days;
    uint private constant BETTING_TIME = 3 days;
    uint private constant PLAYING_TIME = 3 hours;
    uint private constant RESULT_TIME = 18 hours;

    uint private id = 0;
    Game[] private games;
    address _owner;
    mapping (string => tempGame) private tempGames; // string: identifier of the game

    mapping (address => uint[] ) private creatorInfo;
    mapping (address => uint[] ) private partInfo;
    mapping (address => uint[] ) private verifierInfo;


    function Main() public {
        _owner = msg.sender;
    }

    function createGame(string gameInfoStr, uint timestamp, uint tokenAmount) public returns (Game[]){
        // require(tokenAmount > 0 && tokenAmount <= balanceOf(msg.sender));
        // require(isCreatingTime(timestamp) == true);
        // require(tokenAmount >= this.getCirculate() * 25 / 1000); // Not Implemented yet

        tempGame storage tmpGame = tempGames[gameInfoStr];
        require(tmpGame.creatorArray.length < MIN_CREATORS);


        Game.Creator memory _creator = Game.Creator(msg.sender, tokenAmount);

        tmpGame.creatorArray.push(msg.sender);
        tmpGame.tokenArray.push(tokenAmount);
        tmpGame.totalToken += tokenAmount;

        // token transfer process
        __balanceOf[msg.sender] -= tokenAmount;
        __balanceOf[this] += tokenAmount;

        // Create game if condition is met

        if (tmpGame.creatorArray.length >= MIN_CREATORS ) {
            Game game = new Game(id, gameInfoStr, tmpGame.creatorArray,tmpGame.tokenArray, tmpGame.totalToken, timestamp);
            games.push(game);
            this.approve(game, tmpGame.totalToken); // approve game instance to transfer token in Main Contract


             for(uint8 i = 0; i < MIN_CREATORS; i ++){

                 creatorInfo[tmpGame.creatorArray[i]].push(id);
                 creatorInfo[tmpGame.creatorArray[i]].push(tmpGame.tokenArray[i]);
             }
        }

        return games;
    }

     function accountInfo(address _addr) public view returns (uint[], uint[], uint[]){
        return (creatorInfo[_addr], partInfo[_addr], verifierInfo[_addr]);
     }



    function betGame(uint _id, uint tokenAmount, uint8 result) public logging(_id) payable {
        // require(tokenAmount > 0 && tokenAmount <= balanceOf(msg.sender));
        // require(result>= 0 && result <= 2);
        // require(isBettingTime(game));

        Game game = games[_id];
        game.addBettingInfo(msg.sender, msg.value, tokenAmount, result);
        game.transfer(msg.value);

        //token transfer process
        __balanceOf[msg.sender] -= tokenAmount;
        __balanceOf[this] += tokenAmount;

        this.approve(game, tokenAmount); // approve game instance to transfer token in Main Contract

        partInfo[msg.sender].push(_id);
        partInfo[msg.sender].push(result);
        partInfo[msg.sender].push(msg.value);
        partInfo[msg.sender].push(tokenAmount);
    }


    function enterResult(uint _id, uint tokenAmount, uint8 result) logging(_id) public {
        // require(isResultTime(game));
        Game game = games[_id];
        game.enterResult(msg.sender, tokenAmount, result);

       __balanceOf[msg.sender] -= tokenAmount;
       __balanceOf[this] += tokenAmount;

       this.approve(game, tokenAmount); // approve game instance to transfer token in Main Contract

       verifierInfo[msg.sender].push(_id);
       verifierInfo[msg.sender].push(result);
       verifierInfo[msg.sender].push(tokenAmount);
    }


    function checkResult(uint _id) logging(_id) public { // when user triggers event after the result has been decided
        Game game = games[_id];
        // require(isRewardingTime(game));
        game.finalize();

        if(game.balance > 0 )
            game.settle(msg.sender);
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

    event balanceLog(address addr, uint etherBalance, uint tokenBalance);
    /* function logBalance(){
        address addr1 = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        address addr2 = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        address addr3 = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
        address addr4 = 0x583031d1113ad414f02576bd6afabfb302140225;
        address addr5 = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;

        balanceLog(addr1, addr1.balance, balanceOf(addr1));
        balanceLog(addr2, addr2.balance, balanceOf(addr2));
        balanceLog(addr3, addr3.balance, balanceOf(addr3));
        balanceLog(addr4, addr4.balance, balanceOf(addr4));
        balanceLog(addr5, addr5.balance, balanceOf(addr5));
    } */



    function isGameClose(uint _id) public view returns (bool){
        return games[_id].isClose();
    }

    //test
    uint[] tokenAmount;
    function pushBalance(address[] list) public{
      for(uint i = 0; i < list.length; i++)
      tokenAmount.push(balanceOf(list[i]));
    }

    function logBalance() public view returns(uint[]){
      return tokenAmount;
    }

    function getGames() public view returns (Game[]) {
        return games;
    }

     function self_destruct() public ownerFunc(){
       selfdestruct(_owner);
     }

}
