
#######
DS-Auth
#######

.. |readthedocs| image:: https://img.shields.io/badge/view%20docs-readthedocs-blue.svg?style=flat-square
   :target: https://dappsys.readthedocs.io/en/latest/ds_auth.html   

.. |chat| image:: https://img.shields.io/badge/community-chat-blue.svg?style=flat-square
   :target: https://dapphub.chat
   
|readthedocs|  |chat|

DS-Auth is the most fundamental building block of the Dappsys framework. It introduces the concept of contract ownership with two types that work together: ``DSAuth`` and ``DSAuthority``. All the contracts in your system that require some level of authorization to access at least one of their functions should inherit from the ``DSAuth`` type. This is because this type introduces a public ``owner`` member of type ``address``, a public ``authority`` member of type ``DSAuthority``, and a function modifier called ``auth``. 

Any function that is decorated with the ``auth`` modifier will perform an authorization check before granting access to the function. It will perform these checks in order and grant access if any are true:

* If ``msg.sender`` is the contract itself. This will be the case if a contract makes an external call to one of its own functions (e.g. ``this.foo()``)
* If ``msg.sender`` is the contract's ``owner``
* If the contract's ``authority`` member returns ``true`` when making this call:

::

    authority.canCall(msg.sender, this, msg.sig)

The authority will return ``true`` if ``msg.sender`` is authorized to call the function identified by ``msg.sig`` and ``false`` otherwise.  

This is an extremely powerful design pattern because it creates a separation of concerns between authorization and application business logic. The authority could have any number of complex rules that the application contract doesn't need to worry about. For example the authority could be:

* A `simple whitelist <https://github.com/dapphub/ds-guard>`_:
::

    address 0x123abc canCall function mint on 0xdef456

* A timelocked whitelist:
::

    address 0x123abc canCall function mint on 0xdef456 
    two days after proposing the action to the authority

* A `role-based permissioning system <https://github.com/dapphub/ds-roles>`_:
::

    address 0x123abc is a member of group 1 
    which canCall function mint on 0xdef456

* A voter veto system:
::

    address 0x123abc canCall function mint on 0xdef456 
    two days after proposing the action to the authority 
    unless 50% of these token holders veto the action

From the application contract's point of view, it's just asking if ``msg.sender`` ``canCall`` the function it is trying to call. It doesn't need to worry about all these different schemes that the authority contract might be using. Because the authority member is updateable, this means that more complex authorization/governance logic can be introduced to the system later. Conversely, access can be removed once the system is finished and ready to "lockout" privileged administrators.

Updateability is one of the key benefits offered by DS-Auth. Consider a system where backend-contract A is calling an ``auth``-controlled function on another backend-contract B, both owned by authority-contract X. Replacing B with backend-contract C would proceed as follows: 

* Create contract C and set its authority to X
* Store data in X that allows contract A to call ``auth``-controlled functions on C
* Change the pointer in A to point at C instead of B
* Store data in X that disallows anyone from calling B

This ensures that your production system is always consistent and can easily be rolled back to previous configurations.

**TL;DR:** If you use just one package from the Dappsys framework, make it DS-Auth. Your system will remain manageable as it grows in size, each individual component will become much easier to understand, and it will integrate seamlessly with the numerous tools that DappHub is building to work with DS-Auth controlled systems.

**See also:** `DS-Guard <https://github.com/dapphub/ds-guard>`_, `DS-Roles <https://github.com/dapphub/ds-roles>`_


.. _DSAuth:

DSAuth
======

TODO
Your contract should inherit from this class if you want it to be part of a Dappsys Authority system.

Import
------
``import ds-auth/auth.sol``

Parent Types
------------

None


API Reference
-------------

event LogSetAuthority
^^^^^^^^^^^^^^^^^^^^^

This event is logged when setting the contract's ``authority`` member.

::
    
    event LogSetAuthority (address indexed authority)

event LogSetOwner
^^^^^^^^^^^^^^^^^

This event is logged when setting the contract's ``owner`` member.

::
    
    event LogSetOwner (address indexed owner)

function authority
^^^^^^^^^^^^^^^^^^

Returns the contract's public ``authority`` member.

::

    DSAuthority public authority

function owner
^^^^^^^^^^^^^^

Returns the contract's public ``owner`` member.

::

    address public owner

function setAuthority
^^^^^^^^^^^^^^^^^^^^^

This function sets the ``authority`` member that your contract calls when executing the ``auth`` modifier. It is itself ``auth`` controlled.

::

    function setAuthority(DSAuthority authority_) auth

function setOwner
^^^^^^^^^^^^^^^^^

This function sets the ``owner`` member that automatically has access to all the contract's functions. It is itself ``auth`` controlled.

::
    
    function setOwner(address owner_) auth

function isAuthorized
^^^^^^^^^^^^^^^^^^^^^

This function returns ``true`` if the ``src`` address is allowed to call the ``sig`` function(s) on this contract. It is mainly used internally by the ``auth`` and ``authorized`` modifiers. This function first checks if ``src`` is equal to the ``owner`` member, otherwise it calls ``authority.canCall(src, this, sig)`` and returns the result.

::

    function isAuthorized(address src, bytes4 sig) internal returns (bool)

modifier auth
^^^^^^^^^^^^^

This function modifier is the main entrypoint into the logic of ``DSAuth``. Decorate your functions with this modifier when you want to control what addresses can call them. It calls ``isAuthorized(msg.sender, msg.sig)`` and asserts that the return value is ``true``, otherwise it throws an exception.

::

    modifier auth


.. _DSAuthority:

DSAuthority
===========

``DSAuthority`` is an interface that declares just one function: ``canCall``. Contracts that are of this type store authorization data about what addresses can call what specific functions on contracts that are under their authority. Each contract of type ``DSAuth`` consults its ``DSAuthority authority`` member when granting access to its functions.

You should extend ``DSAuthority`` if you want to make new business logic to control access to your system.

Import
------
``import ds-auth/auth.sol``

Parent Types
------------

None

API Reference
-------------

function canCall
^^^^^^^^^^^^^^^^

This function returns ``true`` if the ``src`` address can call the ``sig`` function(s) on the ``dst`` contract.

::

    function canCall(
        address src, address dst, bytes4 sig
    ) constant returns (bool)

