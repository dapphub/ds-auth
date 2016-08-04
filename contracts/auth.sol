import 'authority.sol';
import 'authorized.sol';
import 'util.sol';
import 'events.sol';
import 'enum.sol';

contract DSAuth is DSAuthorized {} //, is DSAuthorizedEvents, DSAuthModesEnum
contract DSAuthUser is DSAuthUtils {} //, is DSAuthModesEnum {}
