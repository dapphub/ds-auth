/// auth.sol -- widely-used access control pattern for Ethereum

// Copyright (C) 2015, 2016, 2017  Nexus Development, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.8;

contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) constant returns (bool);
}

contract DSIAuthority is DSAuthority {} // deprecated

contract DSAuthEvents {
    event LogSetAuthority(address indexed authority);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;

    function DSAuth() {
        authority = DSAuthority(msg.sender);
        LogSetAuthority(authority);
    }

    function setAuthority(address authority_)
        auth
    {
        authority = DSAuthority(authority_);
        LogSetAuthority(authority);
    }

    modifier auth {
        assert(isAuthorized(msg.sender, msg.sig));
        _;
    }

    modifier authorized(string sig) {
        assert(isAuthorized(msg.sender, bytes4(sha3(sig))));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal returns (bool) {
        if (src == address(authority)) {
            return true;
        } else {
            // WARNING:
            //
            // This must throw if `authority' points to either (1) zero,
            // or (2) an address which has no code attached to it.
            //
            // This is not clearly defined in the semantics of Solidity
            // and only works as of a recent compiler version, so this
            // behavior must be tested explicitly.
            //
            return authority.canCall(src, this, sig);
        }
    }

    function assert(bool x) {
        if (!x) throw;
    }
}
