ds-auth
===


The `auth` module contains contracts for the access control pattern used in several places throughout dappsys.

`DSAuth` is like `owned`, except it performs a separate permission lookup if the initial owner check fails.

In other words, the `auth` modifier behaves roughly as:

`assert( msg.sender == _authority
      || msg.sender == this
      || _authority.canCall(msg.sender, this, msg.sig) 
       );`

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

