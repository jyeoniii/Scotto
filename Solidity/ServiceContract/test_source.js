var toto;
var Toto;
var abi;
var bytecode;
var deployed;

Web3 = require('web3');
solc = require('solc');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs');
input = {
  'Main.sol' : fs.readFileSync('Main.sol', 'utf8'),
  'Game.sol' : fs.readFileSync('Game.sol', 'utf8'),
  'Token.sol' : fs.readFileSync('Token.sol', 'utf8')
}
compiledContract = solc.compile({sources: input}, 1)
abi = compiledContract.contracts['Main.sol:Main'].interface
bytecode = '0x' + compiledContract.contracts['Main.sol:Main'].bytecode
Toto = web3.eth.contract(JSON.parse(abi));
deployed = Toto.new([],{data : bytecode, from:web3.eth.accounts[0], gas:5000000})
toto = Toto.at(deployed.address)


for(var i = 1; i < 100; i ++)
toto.distributeTokens({from : web3.eth.accounts[i], gas : 5000000})


for(var i = 0; i < 10; i ++)
toto.createGame("한국vs미국", 10, 50, {from : web3.eth.accounts[i], gas:5000000})

for(var i = 10; i < 20 ; i ++)
toto.betGame(0, 10, 0, {from : web3.eth.accounts[i], gas: 5000000, value : 2000 })

for(var i = 20; i < 30 ; i ++)
toto.betGame(0, 20, 0, {from : web3.eth.accounts[i], gas: 5000000,value : 1000})

for(var i = 30; i < 40 ; i ++)
toto.betGame(0, 10, 1, {from : web3.eth.accounts[i], gas: 5000000,value : 1500})

for(var i = 40; i < 50 ; i ++)
toto.betGame(0, 20, 1, {from : web3.eth.accounts[i], gas: 5000000,value : 2500})

for(var i = 50; i < 60 ; i ++)
toto.betGame(0, 10, 2, {from : web3.eth.accounts[i], gas: 5000000,value : 3500})

for(var i = 60; i < 70 ; i ++)
toto.betGame(0, 20, 2, {from : web3.eth.accounts[i], gas: 5000000,value : 500})

for(var i = 70; i < 79 ; i ++)
toto.enterResult(0, 10, 0, {from : web3.eth.accounts[i], gas: 5000000})

for(var i = 79; i < 90 ; i ++)
toto.enterResult(0, 10, 1, {from : web3.eth.accounts[i], gas: 5000000})

for(var i = 90; i < 99; i++)
toto.enterResult(0, 10, 2, {from : web3.eth.accounts[i], gas: 5000000})

toto.checkResult(0, {from : web3.eth.accounts[99], gas : 5000000})

toto.pushBalance(web3.eth.accounts, {from : web3.eth.accounts[0], gas : 5000000});

fs.writeFileSync('result.txt', toto.logBalance(), 'utf8');


// toto.createGame("한국vs중국", 10, 50, { from : web3.eth.accounts[0], gas : 500000})
// toto.createGame("한국vs중국", 10, 50, {from : web3.eth.accounts[1], gas: 500000})


// for(var i = 0; i < 5; i ++)
// toto.distributeTokens({from : web3.eth.accounts[i], gas : 5000000})
// toto.createGame("한국vs중국", 10, 50, {from : web3.eth.accounts[0], gas: 5000000})
// toto.betGame(0, 20, 0, {from : web3.eth.accounts[1], gas: 5000000, value : 100 })
// toto.enterResult(0,20,0,{from : web3.eth.accounts[2], gas: 5000000})
// toto.checkResult(0, {from : web3.eth.accounts[3], gas: 5000000})
