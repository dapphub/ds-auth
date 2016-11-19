/// DSAuthority50.sol -- basic lookup-table-based authority

// Copyright 2016  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// A copy of the License may be obtained at the following URL:
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity ^0.4.4;

import "DSIAuthority7.sol";
import "DSAuth30.sol";

contract DSAuthority50Events {
    event LogSetCanCall(
        address  indexed  caller,
        address  indexed  callee,
        bytes4   indexed  sighash,
        bool              value,
        string            signame
    );
}

contract DSAuthority50 is DSAuthority50Events,
    DSIAuthority7, DSAuth30
{
    mapping (address =>
        mapping (address =>
            mapping (bytes4 => bool))) _canCall;

    function canCall(
        address  caller,
        address  callee,
        bytes4   sighash
    ) constant returns (bool) {
        return _canCall[caller][callee][sighash];
    }

    function setCanCall(
        address  caller,
        address  callee,
        bytes4   sighash,
        bool     value,
        string   sig
    ) auth {
        _canCall[caller][callee][sighash] = value;
        LogSetCanCall(caller, callee, sighash, value, sig);
    }

    function setCanCall(
        address  caller,
        address  callee,
        string   sig,
        bool     value
    ) auth {
        setCanCall(caller, callee, bytes4(sha3(sig)), value, sig);
    }

    function permit(
        address  caller,
        address  callee,
        string   sig
    ) auth {
        setCanCall(caller, callee, sig, true);
    }

    function forbid(
        address  caller,
        address  callee,
        string   sig
    ) auth {
        setCanCall(caller, callee, sig, false);
    }

    function permit(
        address  caller,
        address  callee,
        bytes4   sighash
    ) auth {
        setCanCall(caller, callee, sighash, true, "");
    }

    function forbid(
        address  caller,
        address  callee,
        bytes4   sighash
    ) auth {
        setCanCall(caller, callee, sighash, false, "");
    }

    function release(DSAuth30 object, address owner) auth {
        object.setOwner(owner);
    }
}

contract DSAuthority50Factory {
    function newAuthority() constant returns (DSAuthority50 result) {
        result = new DSAuthority50();
        result.setOwner(msg.sender);
    }
}
