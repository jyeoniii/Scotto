Web3 = require('web3');
solc = require('solc');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs');

input = {
  'compiled.sol' : fs.readFileSync('compiled.sol', 'utf8')
}
compiledContract = solc.compile({sources: input}, 1)
abi = compiledContract.contracts['compiled.sol:Main'].interface
bytecode = '0x' + compiledContract.contracts['compiled.sol:Main'].bytecode
Toto = web3.eth.contract(JSON.parse(abi));
deployed = Toto.new([],{data : bytecode, from:web3.eth.accounts[0], gas:5000000})
toto = Toto.at(deployed.address)
toto.createGame("0",1,1, {from:web3.eth.accounts[0]})
// input = {
//   'Main.sol' : fs.readFileSync('Main.sol', 'utf8'),
//   'Game.sol' : fs.readFileSync('Game.sol', 'utf8'),
//   'Creator.sol' : fs.readFileSync('Creator.sol', 'utf8'),
//   'Token.sol' : fs.readFileSync('Token.sol', 'utf8'),
//   'Verifier.sol' : fs.readFileSync('Veraifier.sol', 'utf8'),
//   'People.sol' : fs.readFileSync('People.sol', 'utf8'),
//   'Participant.sol' : fs.readFileSync('Participant.sol', 'utf8')
// }
