Web3 = require('web3');
solc = require('solc');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs');

input = {
  'Main.sol' : fs.readFileSync('Main.sol', 'utf8'),
  'Game.sol' : fs.readFileSync('Game.sol', 'utf8'),
  'Creator.sol' : fs.readFileSync('Creator.sol', 'utf8'),
  'Token.sol' : fs.readFileSync('Token.sol', 'utf8')
}
compiledContract = solc.compile({sources: input}, 1)
abi = compiledContract.contracts['Main.sol:Main'].interface
bytecode = '0x' + compiledContract.contracts['Main.sol:Main'].bytecode
Toto = web3.eth.contract(JSON.parse(abi));
deployed = Toto.new([],{data : bytecode, from:web3.eth.accounts[0], gas:5000000})
toto = Toto.at(deployed.address)

for(var i = 0; i < 5; i ++)
toto.distributeTokens({from : web3.eth.accounts[i], gas : 5000000})
toto.createGame("한국vs중국", 10, 50, {from : web3.eth.accounts[0], gas: 5000000})
toto.betGame(0, 20, 0, {from : web3.eth.accounts[1], gas: 5000000, value : 100 })
toto.enterResult(0,20,0,{from : web3.eth.accounts[2], gas: 5000000})
toto.checkResult(0, {from : web3.eth.accounts[3], gas: 5000000})

for(var i = 0; i < 100; i ++)
toto.distributeTokens({from : web3.eth.accounts[i], gas : 5000000})

toto.createGame("한국vs중국", 10, 50, { from : web3.eth.accounts[0], gas : 500000})
toto.createGame("한국vs중국", 10, 50, {from : web3.eth.accounts[1], gas: 500000})

for(var i = 2; i < 12; i ++)
toto.createGame("한국vs미국", 10, 50, {from : web3.eth.accounts[i], gas:50000})

for(var i = 12; i < 42 ; i ++)
toto.betGame(0, 1 * i, 0, {from : web3.eth.accounts[i], gas: 500000, value : 10 * i })

for(var i = 42; i < 72 ; i ++)
toto.betGame(0, 1 * i, 1, {from : web3.eth.accounts[i], gas: 500000,value : 10 * i})

for(var i = 72; i < 90 ; i ++)
toto.betGame(0, 1 * i, 2, {from : web3.eth.accounts[i], gas: 500000,value : 10 * i})


for(var i = 91; i < 93; i++)
toto.enterResult(0,i,0,{from : web3.eth.accounts[i], gas: 500000})

for(var i = 93; i <98; i ++ )
toto.enterResult(0,i,1,{from : web3.eth.accounts[i], gas: 500000})

for(var i = 98; i<100; i++)
toto.enterResult(0,i,2,{from : web3.eth.accounts[i], gas: 500000})

toto.checkResult(0, {from : web3.eth.accounts[0], gas: 500000})
