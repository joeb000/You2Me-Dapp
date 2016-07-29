


ytm.createMatch(eth.accounts[2],eth.accounts[3],{from:admin,gas:4000000})
ytm.createMatch(eth.accounts[4],eth.accounts[5],{from:admin,gas:4000000})
//ytm.createMatch(eth.accounts[1],eth.accounts[6],{from:admin,gas:4000000})

ytm.seekerProviderMap(eth.accounts[2])
ytm.seekerProviderMap(eth.accounts[4])

ytm.payProvider({from:eth.accounts[2],value:web3.toWei(15),gas:4000000})
ytm.payProvider({from:eth.accounts[4],value:web3.toWei(24),gas:4000000})
//ytm.payProvider({from:eth.accounts[1],value:web3.toWei(24),gas:4000000})

web3.fromWei(eth.getBalance(ytm.address))
web3.fromWei(ytm.rewardPot())

ytm.callComplete(eth.accounts[2],{from:admin,gas:4000000})
ytm.callComplete(eth.accounts[4],{from:admin,gas:4000000})
//ytm.callComplete(eth.accounts[1],{from:admin,gas:4000000})
web3.fromWei(eth.getBalance(ytm.address))

ytm.rateProvider(5,{from:eth.accounts[2],gas:4000000})
ytm.rateProvider(4,{from:eth.accounts[4],gas:4000000})
//ytm.rateProvider(3,{from:eth.accounts[1],gas:4000000})

ytm.providerReward(eth.accounts[3])
ytm.providerReward(eth.accounts[5])
web3.fromWei(ytm.rewardPot())

ytm.sendRewardsToProviders({from:admin,gas:4000000})
