class Game:
  def __init__(self, totalEther, totalToken, creatorToken, winnerEther, winnerToken, loserToken, rightVerifierToken):
    self.etherForCompensation = totalEther    # Ether(uint: wei) from losers only
    self.rewardTokenPool = totalToken
    self.creatorTokens = creatorToken
    self.winnerEther = winnerEther
    self.winnerToken = winnerToken
    self.loserToken = loserToken
    self.rightVerifierToken = rightVerifierToken
    
    # Creator
    self.tokenForCreators = int(self.rewardTokenPool * 0.3)
    self.etherForCreators = self.etherForCompensation * 0.01

    # Participant
    self.etherForParticipants = self.etherForCompensation * 0.9
    self.ether95 = self.etherForParticipants * 0.95
    self.ether5 = self.etherForParticipants * 0.05
    self.tokenForWinners = self.rewardTokenPool * 0.1
    self.tokenForLosers = self.rewardTokenPool * 0.3

    # Verifier
    self.etherForVerifiers = self.etherForCompensation * 0.01
    self.tokenForVerifiers = self.rewardTokenPool * 0.3


  def creator(self, tokenAmount):
    print("----- Creator (token: %d) -----" % tokenAmount)
    print("Ether Reward: %fwei" % (self.etherForCreators * tokenAmount / self.creatorTokens ))
    print("Token Reward: %d" % (self.tokenForCreators * tokenAmount / self.creatorTokens))

  def winner(self, tokenAmount, etherAmount):
    print("----- Winner (ether: " + str(etherAmount) + "wei, token: " + str(tokenAmount) + ") -----")
    etherReward95 = self.ether95 * etherAmount / self.winnerEther
    etherReward5 = self.ether5 * tokenAmount / self.winnerToken
    etherRewardTotal = etherReward95 + etherReward5 
    
    print("Ether Reward: %f + %f = %fwei" % (etherReward95 , etherReward5, etherRewardTotal)) 
    print("Token Reward: %d" % (self.tokenForWinners * tokenAmount / self.winnerToken)) 

  def loser(self, tokenAmount):
    print("----- Loser (token: " + str(tokenAmount) + ") -----")
    print("Token Reward: " + str(self.tokenForLosers * tokenAmount / self.loserToken))

  def verifier(self, tokenAmount):
    print("----- Verifier (token: %d) -----" % tokenAmount)
    print("Ether Reward: %fwei" % (self.etherForVerifiers * tokenAmount / self.rightVerifierToken)) 
    print("Token Reward: %d" % (self.tokenForVerifiers * tokenAmount / self.rightVerifierToken)) 


if __name__ == "__main__":
  while(True):
    print("Enter game info to initialize game (totalEther totalToken creatorToken winnerEther winnerToken loserToken rightVerifierToken)")
  
    args = input("> ")
    args = args.split()

    if len(args) != 7:
      print("Wrong input (Should be 7 arguments - %d given)" % len(args))
      continue

    for i in range(7):
      args[i] = int(args[i])

    game = Game(*args)

    while(True):
      print("Choose option (ex. 1 30) \n  1. Creator (tokenAmount)\n  2. Winner (tokenAmount, etherAmount)\n  3. Loser (tokenAmount)\n  4. Verifier (tokenAmount)\n  5. QUIT")
      opt = input("> ")
      opt = opt.split()

      for i in range(len(opt)):
          opt[i] = int(opt[i])

      if (opt[0] == 2 and len(opt) != 3) or (opt[0] in [1,3,4] and len(opt) != 2):
          print(opt[0])
          print(type(opt[0]))
          print ("Wrong input (Invalid argument)")
          continue

      if opt[0] == 1:
        game.creator(opt[1])
      elif opt[0] == 2:
        game.winner(opt[1], opt[2])
      elif opt[0] == 3:
        game.loser(opt[1])
      elif opt[0] == 4:
        game.verifier(opt[1])
      elif opt[0] == 5:
        exit()
      else:
        print ("Wrong input (Invalid option)")

