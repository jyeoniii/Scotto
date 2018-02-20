var gameStatus = ["BETTING", "PLAYING", "RESULT", "REWARD", "CLOSE"];
var gameStatusColor = ["#28a745", "#8A2BE2",	"#FFA500", "	#DB7093", "#B22222"];


window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.log('No web3? You should consider trying MetaMask!')
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }
  // Now you can start your app & access web3 freely:
  init();
});



web3.eth.getAccounts(function(e,r){
  if (r.length > 0){
    document.getElementById('accountAddr').innerHTML += r[0];


  }
  else
    document.getElementById('accountAddr').innerHTML += "Please sign in to Metamask first!";
});
