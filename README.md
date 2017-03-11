ds-auth
=======

The `DSAuth` mixin is a widely-used Ethereum access control pattern.

The critical functionality is summarized by this part of the code:

    modifier auth {
        assert(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal returns (bool) {
        if (src == address(authority)) {
            return true;
        } else {
            return authority.canCall(src, this, sig);
        }
    }

The `canCall` interface is defined on `DSIAuthority`:

    contract DSAuthority {
        function canCall(
            address caller, address code, bytes4 sig
        ) returns (bool);
    }

This gives fine-grained access control to contracts grouped together.

Examples of `DSAuthority` implementations:

  * [ds-guard](https://github.com/dapphub/ds-guard)
  * [ds-roles](https://github.com/dapphub/ds-roles)
