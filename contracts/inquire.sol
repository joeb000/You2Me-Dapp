contract inquire {
    address public admin;
    uint private payment;

    // seeker address is the key. provider address is the value.
    mapping (address => Match) private seekerProviderMap;
    enum CallState {
<<<<<<< HEAD:contracts/inquire.sol
=======
        notStarted,     // default value.
>>>>>>> master:contracts/you2me.sol
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
<<<<<<< HEAD:contracts/inquire.sol
        if (msg.sender == admin){
            _
        }
    }

    modifier seekerOnly(){
=======
        
        if (msg.sender == admin)
        {
            _   // continue
        }
    }

    modifier seekerOnly() {
>>>>>>> master:contracts/you2me.sol
        Logging("SeekerOnly", msg.sender);
        if(seekerProviderMap[msg.sender].provider == address(0)) {
            Logging("SeekerOnly: no provider mapping found", msg.sender);
            throw;
        }
        _   // continue
    }

    // constructor
<<<<<<< HEAD:contracts/inquire.sol
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
=======
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
>>>>>>> master:contracts/you2me.sol
        }
        // last seeker request overwrites previous matches.
        seekerProviderMap[_seeker].provider = _provider;
    }
<<<<<<< HEAD:contracts/inquire.sol

    function cancelMatch(address _seeker, address _provider) adminOnly() seekerOnly() {
        Logging("CancelMatch", _provider);
        if(seekerProviderMap[msg.sender].state != CallState.inProgress) {
            Logging("CancelMatch: call not in progress", _provider);
=======
    
    function cancelMatch(address _seeker, address _provider) adminOnly() seekerOnly() {
        Logging("unmatch", _provider);
        
        if(seekerProviderMap[msg.sender].state != CallState.inProgress)
        {
            Logging("unmatch: call not already in progress", _provider);

>>>>>>> master:contracts/you2me.sol
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
<<<<<<< HEAD:contracts/inquire.sol
        if(!seekerProviderMap[_seeker].provider.send(payment)){
=======
        if(false == seekerProviderMap[_seeker].provider.send(payment))
        {
>>>>>>> master:contracts/you2me.sol
            Logging("CallComplete: payment failed", _seeker);
            return;
        }
            
        Logging("CallComplete: payment sent", seekerProviderMap[_seeker].provider);
    }

    // caller: seeker
<<<<<<< HEAD:contracts/inquire.sol
    function RateProvider(address _provider, uint _rating) seekerOnly(){
        Logging("RateProvider", _provider);
        // check against an empty address.
        if(_rating < 1 || _rating > 5) {
            Logging("RateProvider: rating is invalid", _provider);
=======
    function rateProvider(uint _rating) seekerOnly() {
        Logging("RateProvider", msg.sender);
        
        // check against an empty address.
        if(_rating < 1 || _rating > 5) 
        {
            Logging("RateProvider: rating is invalid", msg.sender);
        
>>>>>>> master:contracts/you2me.sol
            // invalid rating value.
            return;
        }
<<<<<<< HEAD:contracts/inquire.sol
        if(seekerProviderMap[msg.sender].state != CallState.completed){
            Logging("RateProvider: call was not completed", _provider);
=======
        
        if(seekerProviderMap[msg.sender].state != CallState.completed)
        {
            Logging("RateProvider: call was not completed", msg.sender);
        
>>>>>>> master:contracts/you2me.sol
            // prevent seeker from rating provider before the call is complete.
            return;
        }
<<<<<<< HEAD:contracts/inquire.sol
=======
        
        var _provider = seekerProviderMap[msg.sender].provider;

>>>>>>> master:contracts/you2me.sol
        // store rating.
        providerRating[_provider] = _rating;

        Logging("RateProvider: rating complete", _provider);
    }
<<<<<<< HEAD:contracts/inquire.sol
    event Call(
        address seeker,
        address provider
        );

    // caller: seeker
    function pay() seekerOnly(){
=======

    event Call(address seeker, address provider);
        
    // caller: seeker
    function payProvider() seekerOnly() {
>>>>>>> master:contracts/you2me.sol
        Logging("Pay", msg.sender);
        // check payment is valid.
        if (msg.value < payment){
            Logging("Pay: too low", msg.sender);
            return;
        }
<<<<<<< HEAD:contracts/inquire.sol
        // contract automatically accepts payment. nothing needs to be done.
=======
        
>>>>>>> master:contracts/you2me.sol
        // change call state.
        seekerProviderMap[msg.sender].state = CallState.inProgress;
        // trigger event to initiate call between seeker and provider.
        Call(msg.sender, seekerProviderMap[msg.sender].provider);

        // contract automatically accepts payment. nothing needs to be done.
        Logging("PayProvider: payment complete", msg.sender);
    }
<<<<<<< HEAD:contracts/inquire.sol

=======
    
>>>>>>> master:contracts/you2me.sol
    function () {
        // prevent use of the default function.
        Logging("default function", address(0));
    }
}
