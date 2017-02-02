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


// Legacy types for some old `DSAuth` systems

pragma solidity ^0.4.4; // compiler bugs

contract DSAuthModes957 {
    enum DSAuthModes {
        Owner,
        Authority
    }
}

contract DSAuth957 is DSAuthModes957 {
    function updateAuthority(address authority, DSAuthModes mode);
}

contract DSBasicAuthorityEvents957
{
    event DSSetCanCall( address caller_address
                      , address code_address
                      , bytes4 sig
                      , bool can );
}

contract DSBasicAuthority957 is DSAuth957
                              , DSBasicAuthorityEvents957
{
    function setCanCall( address caller_address
                       , address code_address
                       , bytes4 sig
                       , bool can );
}
