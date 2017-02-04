pragma solidity ^0.4.9;

contract DSIAuth {
    function setAuthority(DSIAuthority newAuthority);
}

// `DSAuthority` is the interface which `DSAuth`-derived objects expect
// their authority to be when it is defined.
contract DSIAuthority {
    // `canCall` will be called with these arguments in the caller's
    // scope if it is coming from an `auth` check (`isAuthorized` internal function):
    // `DSAuthority(_ds_authority).canCall(msg.sender, address(this), msg.sig);`
    function canCall( address caller
                    , address code
                    , bytes4 sig )
             constant
             returns (bool);

    function release(DSIAuth what);
}

