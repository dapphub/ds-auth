pragma solidity ^0.4.2;

// `DSAuthority` is the interface which `DSAuthorized` (`DSAuth`) contracts expect
// their authority to be when they are in the remote auth mode.
contract DSAuthority {
    // `canCall` will be called with these arguments in the caller's
    // scope if it is coming from an `auth()` call:
    // `DSAuthority(_ds_authority).canCall(msg.sender, address(this), msg.sig);`
    function canCall( address caller
                    , address code
                    , bytes4 sig )
             constant
             returns (bool);
}

contract AcceptingAuthority {
    function canCall( address caller
                    , address code
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return true;
    }
}
contract RejectingAuthority {
    function canCall( address caller
                    , address callee
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return false;
    }
}


