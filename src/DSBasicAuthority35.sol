/// DSBasicAuthority35.sol -- basic access control list authority

// Copyright (C) 2015, 2016, 2017  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).

import "./DSAuth27.sol";

contract DSBasicAuthority35Events {
    event LogSetCanCall(
        address  indexed  caller,
        address  indexed  callee,
        string            signature,
        bool              value
    );
}

contract DSBasicAuthority35 is
    DSBasicAuthority35Events,
    DSAuth27,
    DSAuth27Authority
{
    mapping (address =>
        mapping (address =>
            mapping (bytes4 => bool))) _canCall;

    function canCall(
        address  caller,
        address  callee,
        bytes4   sig
    ) constant returns (bool) {
        return _canCall[caller][callee][sig];
    }

    function setCanCall(
        address  caller,
        address  callee,
        string   signature,
        bool     value
    ) auth {
        _canCall[caller][callee][bytes4(sha3(signature))] = value;
        LogSetCanCall(caller, callee, signature, value);
    }

    function release(DSAuth27 object, address newOwner) auth {
        object.setOwner(newOwner);
    }
}
