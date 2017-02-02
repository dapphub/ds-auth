import "dapple/test.sol";

import "auth.sol";

contract FakeVault is DSAuth30 {
    function access() auth {}
}

contract DSAuthTest is Test, DSAuthEvents {
    FakeVault vault = new FakeVault();

    function test_owner() {
        expectEventsExact(vault);
        vault.access();
        LogDSAuthTransfer(address(this), DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
        vault.access();
        LogDSAuthTransfer(address(0), DSAuthority(0));
        vault.setOwner(address(0));
    }

    function testFail_non_owner_1() {
        vault.setOwner(address(0));
        vault.access();
    }

    function testFail_non_owner_2() {
        vault.setOwner(address(0));
        vault.setOwner(address(0));
    }

    function testFail_non_owner_3() {
        vault.setOwner(address(0));
        vault.setAuthority(DSIAuthority7(0));
    }

    function test_accepting_authority() {    
        vault.setAuthority(new BooleanAuthority(true));
        vault.setOwner(address(0));
        vault.access();
        vault.setOwner(address(0));
        vault.setAuthority(DSAuthority(0));
    }

    function testFail_rejecting_authority_1() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(address(0));
        vault.access();
    }

    function testFail_rejecting_authority_2() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(address(0));
        vault.setOwner(address(0));
    }

    function testFail_rejecting_authority_3() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setOwner(address(0));
        vault.setAuthority(DSAuthority(0));
    }
}

