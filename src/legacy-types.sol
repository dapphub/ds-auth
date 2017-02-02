// Legacy types for some old `DSAuth` systems

pragma solidity ^0.4.4; // compiler bugs

contract DSAuthModes957 {
    enum DSAuthModes {
        Owner,
        Authority
    }
}

contract DSAuth957 is DSAuthModes957 {
    function updateAuthority(address authority, DSAuthModes mode);
}

contract DSBasicAuthorityEvents957
{
    event DSSetCanCall( address caller_address
                      , address code_address
                      , bytes4 sig
                      , bool can );
}

contract DSBasicAuthority957 is DSAuth957
                              , DSBasicAuthorityEvents957
{
    function setCanCall( address caller_address
                       , address code_address
                       , bytes4 sig
                       , bool can );
}
