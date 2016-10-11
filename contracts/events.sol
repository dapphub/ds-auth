pragma solidity ^0.4.2;

import 'enum.sol';

contract DSAuthorizedEvents is DSAuthModesEnum {
    event DSAuthUpdate( address indexed auth, DSAuthModes indexed mode );
}

