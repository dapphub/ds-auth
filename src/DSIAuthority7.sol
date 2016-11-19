/// DSIAuthority7.sol -- interface implemented by authorities

pragma solidity ^0.4.4;

contract DSIAuthority7 {
    function canCall(
        address  caller,
        address  callee,
        bytes4   sighash
    ) constant returns (bool);
}
