/// DSIAuthorized7.sol -- interface implemented by authorized objects

pragma solidity ^0.4.4;

contract DSIAuthorized7 {
    function canCall(
        address  caller,
        bytes4   sighash
    ) constant returns (bool);
}
