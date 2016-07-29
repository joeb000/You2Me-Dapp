contract test {

    address public admin;
    uint minPayment = 10;
    uint percentageToProvider = 50;
    uint poolFunds;
    uint totalTokenBalances;
    mapping (address => address) seekerProviderMap;
    mapping (address => uint) tokenBalance;

    struct Match {
        address provider;
        uint minPayment;
        bool isPaid;

    }
    modifier onlyAdmin(){
        if (msg.sender==admin)
        _
    }

    function test(){
        admin = msg.sender;
    }

    function makeMatch(address _seeker, address _provider) onlyAdmin() {
        seekerProviderMap[_seeker]=_provider;
    }

    function pay(){
        if (msg.value < minPayment){
            throw;
        }
        poolFunds=(100-percentageToProvider)/100 * msg.value;
    }

    function rateProvider(uint _rating) {
        //release funds to provider
        if (!seekerProviderMap[msg.sender].send((percentageToProvider)/100 * minPayment))
        throw;
        //pay reward tokens to provider
        tokenBalance[seekerProviderMap[msg.sender]]+=_rating;
        totalTokenBalances+=_rating;
        //reset provider (state changed for seeekerToProvider to not valid)
        seekerProviderMap[msg.sender]=address(0);
    }

    function withdrawRewards(address _to){
        uint reward = (tokenBalance[seekerProviderMap[msg.sender]] / totalTokenBalances) * poolFunds;
        poolFunds-=reward;
        tokenBalance[msg.sender]=0;
        if (!_to.send(reward))
        throw;
    }
}
