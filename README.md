ds-auth
===


The `auth` module contains contract for the access control pattern used in several places throughout dappsys.

`DSAuth` is like `owned`, except it performs a separate permission lookup if the initial owner check fails.

In other words, the `auth` modifier behaves roughly as:

`assert(msg.sender == _authority || _authority.canCall(msg.sender, this, msg.sig));`

The `canCall` interface is defined on `DSAuthority`:

```
contract DSAuthority {
    function canCall(address caller, address code, bytes4 sig) returns (bool);
}
```

This gives fine-grained access control to contracts grouped together.


Testing
---

Tests can be run with [`dapple-quicktest`](https://github.com/nexusdev/dapple-quicktest).


The `DSBasicAuthority` implements an authority that rejects by default and has a `(caller,callee,sig) => bool` mapping.

Two examples of more complex authorities live in [ds-whitelist](https://github.com/nexusdev/ds-whitelist) (which only discriminates by caller) and [ds-roles](https://github.com/nexusdev/ds-roles) (basic RBAC).
