contract ytm{
    event LogSeekerPaid(address seeker, address provider);
    event LogCallCompleted(address seeker, address provider);
    event LogRewardSent(address provider, uint reward);
    event LogRated(address provider, uint rating);

    address public admin;
    uint payment;
    uint adminFee;
    address[] public activeProviders;

    uint public totalRewardTokenBalance;
    uint public rewardPot;
    // provider rating.
    mapping (address => uint) public providerReward;
    // seeker address is the key. provider address is the value.
    mapping (address => Match) public seekerProviderMap;

    enum CallState {
        notStarted,     // default value.
        inProgress,
        canceled,
        completed
    }

    struct Match {
        address provider;
        CallState state;    // defaults to false.
    }

    modifier adminOnly() {
        if (msg.sender == admin)
            _   // continue
    }

    modifier seekerOnly() {
        if(seekerProviderMap[msg.sender].provider == address(0))
            throw;
        _   // continue
    }

    // constructor
    function ytm() {
        admin = msg.sender;
        payment = 5 ether;
        adminFee = 10 ether;
    }

    //////////////////////////////////////////////
   // Admin Functions                          //
  //////////////////////////////////////////////

    function createMatch(address _seeker, address _provider) adminOnly() {
        activeProviders.push(_provider);
        //if(seekerProviderMap[msg.sender].state == CallState.inProgress)
        //    return;
        seekerProviderMap[_seeker].provider = _provider;
    }

    function callComplete(address _seeker) adminOnly() {
        seekerProviderMap[_seeker].state = CallState.completed;
        // send payment to provider.
        if(!seekerProviderMap[_seeker].provider.send(payment))
            throw;
        LogCallCompleted(_seeker,seekerProviderMap[_seeker].provider);
    }

    function sendRewardsToProviders() adminOnly(){
        for (uint i = 0; i < activeProviders.length; i++){
            uint reward = ((rewardPot-adminFee) * providerReward[activeProviders[i]]/totalRewardTokenBalance);
            if(!activeProviders[i].send(reward))
                throw;
            providerReward[activeProviders[i]]=0;
            LogRewardSent(activeProviders[i],reward);
        }
        if(!admin.send(this.balance))
            throw;
        rewardPot=0;
        delete activeProviders;
    }

      //////////////////////////////////////////////
     // Seeker Functions                         //
    //////////////////////////////////////////////

    function payProvider() seekerOnly() {
        if (msg.value < payment)
            throw;
        // change call state.
        seekerProviderMap[msg.sender].state = CallState.inProgress;
        rewardPot += (msg.value - payment);
        // trigger event to initiate call between seeker and provider.
        LogSeekerPaid(msg.sender, seekerProviderMap[msg.sender].provider);
    }

    function rateProvider(uint _rating) seekerOnly() {
        if(_rating > 5 || seekerProviderMap[msg.sender].state != CallState.completed)
            return;
        providerReward[seekerProviderMap[msg.sender].provider] += _rating;
        totalRewardTokenBalance += _rating;
        LogRated(seekerProviderMap[msg.sender].provider,_rating);
    }
}
