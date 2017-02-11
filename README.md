ds-auth
===


`auth` is an access control pattern for Ethereum contract systems.

The critical functionality is summarized by this section of `DSAuth`:
```
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

```

The `canCall` interface is defined on `DSIAuthority`:

```
contract DSAuthority {
    function canCall(address caller, address code, bytes4 sig) returns (bool);
}
```

This gives fine-grained access control to contracts grouped together.

Examples of authority implementations are [ds-whitelist](https://github.com/nexusdev/ds-whitelist)
(which maintains simple mappings) and [ds-roles](https://github.com/nexusdev/ds-roles) (RBAC).

Testing
---

Tests can be run with [`dapple-quicktest`](https://github.com/nexusdev/dapple-quicktest).

