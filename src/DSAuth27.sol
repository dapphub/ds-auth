/// DSAuth27.sol -- base class for contracts with authorized methods

// Copyright (C) 2015, 2016, 2017  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

pragma solidity ^0.4.8;

contract DSAuth27Events {
    event LogSetOwner     (address indexed owner);
    event LogSetAuthority (address indexed authority);
}

contract DSAuth27Authority {
    function canCall(
        address  caller,
        address  callee,
        bytes4   sig
    ) constant returns (bool);
}

contract DSAuth27 is DSAuth27Events {
    address            public  owner;
    DSAuth27Authority  public  authority;

    function DSAuth27() {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    function setOwner(address newOwner) auth {
        owner = newOwner;
        LogSetOwner(owner);
    }

    function setAuthority(DSAuth27Authority newAuthority) auth {
        authority = newAuthority;
        LogSetAuthority(authority);
    }

    modifier auth {
        if (isAuthorized(msg.sender, msg.sig)) {
            _;
        } else {
            throw;
        }
    }

    function isAuthorized(
        address caller, bytes4 sig
    ) constant returns (bool) {
        if (caller == address(this) || caller == owner) {
            return true;
        } else if (authority == address(0)) {
            return false;
        } else {
            return authority.canCall(caller, this, sig);
        }
    }
}
