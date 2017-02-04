/*
   Copyright 2016-2017 Nexus Development, LLC

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

pragma solidity ^0.4.9;

import 'types.sol';
import 'events.sol';

contract DSAuth is DSIAuth, DSAuthEvents {
    DSIAuthority  public  authority;

    function DSAuth() {
        authority = DSIAuthority(msg.sender);
        LogSetAuthority(authority);
    }

    function setAuthority(DSIAuthority newAuthority)
        auth
    {
        authority = newAuthority;
        LogSetAuthority(authority);
    }

    modifier auth {
        if (!isAuthorized()) throw;
        _;
    }

    function isAuthorized() internal returns (bool)
    {
        if ( address(authority) == msg.sender ) {
            return true;
        } else if ( address(authority) == 0 ) {
            return false;
        } else {
            return authority.canCall(msg.sender, this, msg.sig);
        }
    }
}
