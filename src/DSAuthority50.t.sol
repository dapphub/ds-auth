/// DSAuthority50.t.sol -- DSAuthority50 tests

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

import "dapple/test.sol";

import "DSAuth30.sol";
import "DSAuthority50.sol";

contract FakeVault is DSAuth30 {
    function access() auth {}
}

contract DSAuthorityTest is Test, DSAuthorityEvents {
    DSAuthority50  authority  = new DSAuthority50();
    FakeVault      vault      = new FakeVault();

    function setUp() {
        vault.setAuthority(authority);
        vault.setOwner(address(0));
    }

    function testFail_unauthorized() {
        vault.access();
    }

    function testFail_permit() {
        authority.permit(this, vault, "access()");
        vault.setOwner(address(0));
    }

    function test_permit() {
        expectEventsExact(authority);
        LogSetCanCall(this, vault, sighash("access()"), true, "access()");
        authority.permit(this, vault, "access()");
        vault.access();
    }

    function testFail_forbid() {
        authority.permit(this, vault, "access()");
        authority.forbid(this, vault, "access()");
        vault.access();
    }

    function test_forbid() {
        expectEventsExact(authority);
        LogSetCanCall(this, vault, sighash("access()"), true, "access()");
        authority.permit(this, vault, "access()");
        LogSetCanCall(this, vault, sighash("foo()"), false, "foo()");
        authority.forbid(this, vault, "foo()");
        vault.access();
    }

    function sighash(string sig) internal returns (bytes4) {
        return bytes4(sha3(sig));
    }
}
