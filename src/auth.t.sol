// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.4.23;

import "ds-test/test.sol";

import "./auth.sol";

contract FakeVault is DSAuth {
    function access() public view auth {}
}

contract BooleanAuthority is DSAuthority {
    bool yes;

    constructor(bool _yes) public {
        yes = _yes;
    }

    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool) {
        src; dst; sig; // silence warnings
        return yes;
    }
}

contract DSAuthTest is DSTest, DSAuthEvents {
    FakeVault vault = new FakeVault();
    BooleanAuthority rejector = new BooleanAuthority(false);

    function test_owner() public {
        expectEventsExact(address(vault));
        vault.access();
        vault.setOwner(address(0));
        emit LogSetOwner(address(0));
    }

    function testFail_non_owner_1() public {
        vault.setOwner(address(0));
        vault.access();
    }

    function testFail_non_owner_2() public {
        vault.setOwner(address(0));
        vault.setOwner(address(0));
    }

    function test_accepting_authority() public {
        vault.setAuthority(new BooleanAuthority(true));
        vault.setOwner(address(0));
        vault.access();
    }

    function testFail_rejecting_authority_1() public {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(address(0));
        vault.access();
    }

    function testFail_rejecting_authority_2() public {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(address(0));
        vault.setOwner(address(0));
    }
}
