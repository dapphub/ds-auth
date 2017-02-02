/*
   Copyright 2016 Nexus Development

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


pragma solidity ^0.4.2;

import 'dapple/test.sol';

import 'auth.sol';
import 'authority.sol';
import 'auth_test.sol';  // Vault
import 'basic_authority.sol';


contract BasicAuthorityTest is Test, DSAuthEvents, DSBasicAuthorityEvents {
    DSBasicAuthority a;
    DSBasicAuthority a2;
    Vault v;
    function setUp() {
        a = new DSBasicAuthority();
        v = new Vault();
        v.setAuthority(a);
        v.setOwner(0);
    }
    function testExportAuthorized() {
        assertFalse( v.breached(), "vault started breached" );
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("setOwner(address)")),
                     true);

        a.setCanCall(this, v, bytes4(sha3("setOwner(address)")),
                     true);

        v.setOwner( address(this) );
        v.breach();
        assertTrue( v.breached(), "couldn't after export attempt" );
    }
    function testFailBreach() {
        assertFalse( v.breached(), "vault started breached" );
        v.breach(); // throws
    }
    function testNormalWhitelistAdd() {
        assertFalse( v.breached(), "vault started breached" );
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("breach()")), true);

        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        v.reset();
        assertFalse( v.breached(), "vault not reset" );
    }
    function testFailNormalWhitelistReset() {
        assertFalse( v.breached(), "vault started breached" );
        expectEventsExact(a);
        DSSetCanCall(this, v, bytes4(sha3("breach()")), false );

        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        a.setCanCall( me, address(v), bytes4(sha3("breach()")), false );
        v.breach();
    }
}

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
