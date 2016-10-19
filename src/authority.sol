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

// `DSAuthority` is the interface which `DSAuthorized` (`DSAuth`) contracts expect
// their authority to be when they are in the remote auth mode.
contract DSAuthority {
    // `canCall` will be called with these arguments in the caller's
    // scope if it is coming from an `auth()` call:
    // `DSAuthority(_ds_authority).canCall(msg.sender, address(this), msg.sig);`
    function canCall( address caller
                    , address code
                    , bytes4 sig )
             constant
             returns (bool);
}

contract AcceptingAuthority is DSAuthority {
    function canCall( address caller
                    , address code
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return true;
    }
}

contract RejectingAuthority is DSAuthority {
    function canCall( address caller
                    , address callee
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return false;
    }
}


