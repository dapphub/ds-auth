ds-auth
=======

The `DSAuth` mixin is a widely-used Ethereum access control pattern.

The critical functionality is summarized by this part of the code:

    modifier auth {
        if (!isAuthorized()) throw;
        _;
    }

    function isAuthorized() internal returns (bool) {
        if (address(authority) == msg.sender) {
            return true;
        } else if (address(authority) == 0) {
            return false;
        } else {
            return authority.canCall(msg.sender, this, msg.sig);
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
