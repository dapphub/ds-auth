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

import 'auth.sol';

contract DSBasicAuthorityEvents {
    event DSSetCanCall( address caller_address
                      , address code_address
                      , bytes4 sig
                      , bool can );
}

// A `DSAuthority` which contains a whitelist map from can_call arguments to return value.
// Note it is itself a `DSAuth` - ie it is not self-authorized by default.
contract DSBasicAuthority is DSAuthority
                           , DSBasicAuthorityEvents
                           , DSAuth
{
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;

    // See `DSAuthority.sol`
    function canCall( address caller_address
                    , address code_address
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return _can_call[caller_address][code_address][sig];
    }

    function setCanCall( address caller_address
                       , address code_address
                       , bytes4 sig
                       , bool can )
             auth()
    {
        _can_call[caller_address][code_address][sig] = can;
        DSSetCanCall( caller_address, code_address, sig, can );
    }

    function setCanCall( address caller_address
                       , address code_address
                       , string signature
                       , bool can )
             auth()
    {
        var sig = bytes4(sha3(signature));
        _can_call[caller_address][code_address][sig] = can;
        DSSetCanCall( caller_address, code_address, sig, can );
    }

}
