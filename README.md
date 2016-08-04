ds-auth
===

The `auth` module contains contract for the access control pattern used in several places throughout dappsys.

Think of `DSAuthorized` (alias: `DSAuth`) as analagous to `owned` and  the `auth` modifier as analagous to `owner_only`, except that
a `DSAuth` contract can be toggled into "Authority Mode", in which case the protected function works as if you had this line:

`assert(_authority.canCall(msg.sender, this, msg.sig));`
