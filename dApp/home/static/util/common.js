var gameStatus = ["BETTING", "PLAYING", "RESULT", "REWARD", "CLOSED"];
var gameStatusColor = ["#28a745", "#8A2BE2",	"#FFA500", "	#DB7093", "#B22222"];
var accountAddr;

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
  base();
  init();
});

web3.eth.getAccounts(function(e,r){
  if (r.length > 0){
    document.getElementById('accountAddr').innerHTML += r[0];
    accountAddr = r[0];
    document.getElementById("to_accountpage").setAttribute("href", `/home/account/${accountAddr}`);
  }
  else
    document.getElementById('accountAddr').innerHTML += "Please sign in to Metamask first!";
});

function getGameInfoTds(gid, league, A_B_DRAW, time, status) {
  return `<td>${gid}</td>
          <td>${league}</td>
          <td style="font-weight:bold"><a href='/home/game/${gid}'>${A_B_DRAW[0]} : ${A_B_DRAW[1]}</a></td>
          <td>${time}</td>
          <td><label class="label" style="background-color: ${gameStatusColor[status]}; color:white">${gameStatus[status]}</label></td>`;;
}

function getGameDateStr(timestamp){
  let dt = parseTimestamp(timestamp);
  let noon = "AM";

  if (dt.hour > 12){
    dt.hour -= 12;
    noon = "PM";
  }

  return `${dt.year}/${dt.month}/${dt.day} - ${noon} ${dt.hour}:${dt.minute}`;
}

function getGameInfo(games, gid){
  return new Promise(function(resolve, reject) {
    games[gid].getGameInfo(function(e,r) {
      let gameStr = r[1];
      let info = gameStr.split(":");

      let league = info[0];
      let A_B_DRAW = [info[1], info[2], 'DRAW'];
      let startTime = r[2].toNumber();
      let status;

      let time = getGameDateStr(startTime);

      toto.isGameClosed(gid, function(e,r){
        if (r) status = 4;
        else status = getStatus(startTime);

        resolve([league, A_B_DRAW, time, status, startTime]);
      });//end isGameClosed
    }); //end getGameInfo
  }); //end Promise
}
