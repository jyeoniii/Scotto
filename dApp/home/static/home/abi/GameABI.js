var gameAbi = [
	{
		"constant": true,
		"inputs": [],
		"name": "getGameInfo",
		"outputs": [
			{
				"name": "str",
				"type": "string"
			},
			{
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "finalize",
		"outputs": [
			{
				"name": "",
				"type": "uint8[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sender",
				"type": "address"
			},
			{
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"name": "result",
				"type": "uint8"
			}
		],
		"name": "enterResult",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "rewardParticipants",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getStartTime",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getBettingInfo",
		"outputs": [
			{
				"name": "etherA",
				"type": "uint256"
			},
			{
				"name": "tokenA",
				"type": "uint256"
			},
			{
				"name": "etherB",
				"type": "uint256"
			},
			{
				"name": "tokenB",
				"type": "uint256"
			},
			{
				"name": "etherDraw",
				"type": "uint256"
			},
			{
				"name": "tokenDraw",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "result",
				"type": "uint8"
			}
		],
		"name": "initDistribute",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "sender",
				"type": "address"
			},
			{
				"name": "etherAmount",
				"type": "uint256"
			},
			{
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"name": "result",
				"type": "uint8"
			}
		],
		"name": "addBettingInfo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "rewardCreators",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "rewardVerifier",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "a",
				"type": "uint256"
			},
			{
				"name": "b",
				"type": "uint256"
			},
			{
				"name": "c",
				"type": "uint256"
			}
		],
		"name": "maxResult",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_id",
				"type": "uint256"
			},
			{
				"name": "_gameInfoStr",
				"type": "string"
			},
			{
				"name": "_creators",
				"type": "address[]"
			},
			{
				"name": "_creatorTokens",
				"type": "uint256"
			},
			{
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"payable": true,
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "result",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "etherAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "tokenAmount",
				"type": "uint256"
			}
		],
		"name": "bettingLog",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "result",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "tokenAmount",
				"type": "uint256"
			}
		],
		"name": "verifyingLog",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "",
				"type": "uint256"
			}
		],
		"name": "log",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "baseToken",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardToken",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardEther",
				"type": "uint256"
			}
		],
		"name": "rewardCreatorLog",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "etherAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardToken",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardEther",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "additionalEther",
				"type": "uint256"
			}
		],
		"name": "rewardWinnerLog",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardToken",
				"type": "uint256"
			}
		],
		"name": "rewardLoserLog",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardToken",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "rewardEther",
				"type": "uint256"
			}
		],
		"name": "rewardVerifierLog",
		"type": "event"
	}
]
