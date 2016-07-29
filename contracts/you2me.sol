contract you2me{
    address public admin;
    uint private payment;

    // seeker address is the key. provider address is the value.
    mapping (address => Match) private seekerProviderMap;
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

    // provider rating.
    mapping (address => uint) providerRating;

    modifier adminOnly() {
        Logging("AdminOnly", msg.sender);
        if (msg.sender == admin)
        {
            _   // continue
        }
    }

    modifier seekerOnly() {
        Logging("SeekerOnly", msg.sender);
        if(seekerProviderMap[msg.sender].provider == address(0))
        {
            Logging("SeekerOnly: no provider mapping found", msg.sender);

            // mapping doesn't exist.
            throw;
        }
        _   // continue
    }

    // constructor
    function you2me() {
        admin = msg.sender;
        payment = 5;
    }

    event Logging(string output, address adr);

    // caller: admin
    function createMatch(address _seeker, address _provider) adminOnly() {
        Logging("match", _provider);

        if(seekerProviderMap[msg.sender].state == CallState.inProgress)
        {
            Logging("match: call already in progress", _provider);

            // prevent seeker from placing another if a call is already in progress.
            return;
        }

        // last seeker request overwrites previous matches.
        seekerProviderMap[_seeker].provider = _provider;
    }

    function cancelMatch(address _seeker, address _provider) adminOnly() seekerOnly() {
        Logging("unmatch", _provider);

        if(seekerProviderMap[msg.sender].state != CallState.inProgress)
        {
            Logging("unmatch: call not already in progress", _provider);

            // can only cancel calls in progress.
            return;
        }

        // mark call as canceled.
        seekerProviderMap[_seeker].state = CallState.canceled;
    }

    // caller: admin
    function callComplete(address _seeker) adminOnly() {
        Logging("CallComplete", _seeker);

        seekerProviderMap[_seeker].state = CallState.completed;

        // send payment to provider.
        if(false == seekerProviderMap[_seeker].provider.send(payment))
        {
            Logging("CallComplete: payment failed", _seeker);
            return;
        }

        Logging("CallComplete: payment sent", seekerProviderMap[_seeker].provider);
    }

    // caller: seeker
    function rateProvider(uint _rating) seekerOnly() {
        Logging("RateProvider", msg.sender);

        // check against an empty address.
        if(_rating < 1 || _rating > 5)
        {
            Logging("RateProvider: rating is invalid", msg.sender);

            // invalid rating value.
            return;
        }

        if(seekerProviderMap[msg.sender].state != CallState.completed)
        {
            Logging("RateProvider: call was not completed", msg.sender);

            // prevent seeker from rating provider before the call is complete.
            return;
        }

        var _provider = seekerProviderMap[msg.sender].provider;

        // store rating.
        providerRating[_provider] = _rating;

        Logging("RateProvider: rating complete", _provider);
    }

    event Call(address seeker, address provider);

    // caller: seeker
    function payProvider() seekerOnly() {
        Logging("Pay", msg.sender);

        // check payment is valid.
        if (msg.value < payment)
        {
            Logging("Pay: too low", msg.sender);
            return;
        }

        // change call state.
        seekerProviderMap[msg.sender].state = CallState.inProgress;

        // trigger event to initiate call between seeker and provider.
        Call(msg.sender, seekerProviderMap[msg.sender].provider);

        // contract automatically accepts payment. nothing needs to be done.
        Logging("PayProvider: payment complete", msg.sender);
    }

    function () {
        // prevent use of the default function.
        Logging("default function", address(0));
    }
}
