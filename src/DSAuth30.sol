/// DSAuth30.sol -- simple base class for authorized objects

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
import "DSIAuthorized7.sol";

contract DSAuth30Events {
    event LogDSAuthTransfer(
        address  indexed  owner,
        address  indexed  authority
    );
}

contract DSAuth30 is DSAuth30Events, DSIAuthorized7 {
    address        public  owner;
    DSIAuthority7  public  authority;

    function DSAuth30() {
        owner = msg.sender;
        LogDSAuthTransfer(owner, authority);
    }

    function setOwner(address newOwner) auth {
        owner = newOwner;
        LogDSAuthTransfer(owner, authority);
    }

    function setAuthority(DSIAuthority7 newAuthority) auth {
        authority = newAuthority;
        LogDSAuthTransfer(owner, authority);
    }

    modifier auth {
        if (canCall(msg.sender, msg.sig)) {
            _;
        } else {
            throw;
        }
    }

    function canCall(
        address caller, bytes4 sighash
    ) constant returns (bool) {
        if (caller == owner) {
            return true;
        } else if (authority == address(0)) {
            return false;
        } else {
            return authority.canCall(caller, this, sighash);
        }
    }
}
