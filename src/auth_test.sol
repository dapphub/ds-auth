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

contract Vault is DSAuth {
    bool public breached;
    uint public coins;
    function Vault() {
        reset();
    }
    function reset() {
        coins = 50;
        breached = false;
    }
    // 0x0b6142fc
    function breach() auth() {
        breached = true;
        coins = 4;
    }
}

contract AuthTest is Test, DSAuthEvents {
    Vault v;
    AcceptingAuthority AA;
    RejectingAuthority RA;
    bytes4 breach_sig;
    function setUp() {
        v = new Vault();
        RA = new RejectingAuthority();
        AA = new AcceptingAuthority();
    }
    function testOwnerCanBreach() {
        v.breach();
        assertTrue(v.breached(), "owner failed to call");
    }
    function testTransferToAcceptAuthority() {
        v.setAuthority( AA );
        v.setOwner(address(0));
        v.breach();
        assertTrue( v.breached(), "authority failed to accept");
    }

    function testErrorNonOwnerCantBreach() {
        v.setAuthority( DSAuthority(0x0) );
        v.setOwner(0);
        v.breach();
    }
    function testErrorTransferToRejectAuthority() {
        v.setAuthority( RA );
        v.setOwner(0);
        v.breach();
    }
}
