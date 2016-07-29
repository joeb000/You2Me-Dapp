contract inquire {
    address public admin;
    uint private payment;

    // seeker address is the key. provider address is the value.
    mapping (address => Match) private seekerProviderMap;
    enum CallState {
        inProgress,
        canceled,
        completed
    }
    struct Match {
        address provider;
        CallState state;    // defaults to false.
    }

    // provider rating.
    mapping (address => uint) private providerRating;

    modifier adminOnly() {
        Logging("AdminOnly", msg.sender);
        if (msg.sender == admin){
            _
        }
    }

    modifier seekerOnly(){
        Logging("SeekerOnly", msg.sender);
        if(seekerProviderMap[msg.sender].provider == address(0)) {
            Logging("SeekerOnly: no provider mapping found", msg.sender);
            throw;
        }
    }

    // constructor
    function inquire()
    {
        admin = msg.sender;
        payment = 5;
    }

    event Logging(
        string _output,
        address _seekerOrProvider
    );

    // caller: admin
    function makeMatch(address _seeker, address _provider) adminOnly() {
        Logging("MakeMatch", _provider);
        if(seekerProviderMap[msg.sender].state == CallState.inProgress){
            Logging("MakeMatch: call in progress", _provider);
            // prevent seeker from placing another if a call is already in progress.
        }
        // last seeker request overwrites previous matches.
        seekerProviderMap[_seeker].provider = _provider;
    }

    function cancelMatch(address _seeker, address _provider) adminOnly() seekerOnly() {
        Logging("CancelMatch", _provider);
        if(seekerProviderMap[msg.sender].state != CallState.inProgress) {
            Logging("CancelMatch: call not in progress", _provider);
            // can only cancel calls in progress.
            throw;
        }
        // mark call as canceled.
        seekerProviderMap[_seeker].state = CallState.canceled;
    }

    // caller: admin
    function callComplete(address _seeker) adminOnly() {
        Logging("CallComplete", _seeker);
        seekerProviderMap[_seeker].state = CallState.completed;
        // send payment to provider.
        if(!seekerProviderMap[_seeker].provider.send(payment)){
            Logging("CallComplete: payment failed", _seeker);
            throw;
        }
    }

    // caller: seeker
    function RateProvider(address _provider, uint _rating) seekerOnly(){
        Logging("RateProvider", _provider);
        // check against an empty address.
        if(_rating < 1 || _rating > 5) {
            Logging("RateProvider: rating is invalid", _provider);
            // invalid rating value.
            throw;
        }
        if(seekerProviderMap[msg.sender].state != CallState.completed){
            Logging("RateProvider: call was not completed", _provider);
            // prevent seeker from rating provider before the call is complete.
            throw;
        }
        // store rating.
        providerRating[_provider] = _rating;
    }
    event Call(
        address seeker,
        address provider
        );

    // caller: seeker
    function pay() seekerOnly(){
        Logging("Pay", msg.sender);
        // check payment is valid.
        if (msg.value < payment){
            Logging("Pay: too low", msg.sender);
            throw;
        }
        // contract automatically accepts payment. nothing needs to be done.
        // change call state.
        seekerProviderMap[msg.sender].state = CallState.inProgress;
        // trigger event to initiate call between seeker and provider.
        Call(msg.sender, seekerProviderMap[msg.sender].provider);
    }

    function () {
        // prevent use of the default function.
        Logging("default function", address(0));
    }
}
