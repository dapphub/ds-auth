<h2>DSAuth
  <small class="text-muted">
    <a href="https://github.com/dapphub/ds-auth"><span class="fa fa-github"></span></a>
  </small>
</h2>

_Fully updatable unobtrusive auth_

Provides a flexible and updatable auth pattern which is completely separate
from application logic. By default, the `auth` modifier will restrict 
function-call access to the including contract owner and the including
contract itself.

In addition, fine-grained function access can be controlled by specifying an
`authority` - a contract which implements the `DSAuthority` interface to define 
custom access permissions.

Dappsys provides a couple of ready-made authority contracts,
[ds-guard](https://dapp.tools/dappsys/ds-guard.html) and
[ds-roles](https://dapp.tools/dappsys/ds-roles.html), which can be used as 
authorities where updatable fine-grained permissioned auth is required.

### Usage

The `auth` **modifier** provided by DSAuth triggers the internal `isAuthorized` 
function to require that the `msg.sender` is authorized ie. the sender is either:

1. the contract `owner`;
2. the contract itself;
3. or has been granted permission via a specified `authority`.

```solidity
function myProtectedFunction() auth {}
```

### API

#### `setOwner(address owner_)` 
Set a new `owner` (requires auth)

#### `setAuthority(DSAuthority authority_)` 
Set a new `authority` (requires auth)
