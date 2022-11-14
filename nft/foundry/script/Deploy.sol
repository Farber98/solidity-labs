pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/soupr4.sol";

contract Soupr4Script is Script {
    function setUp() public {}

    function run() public {
        string memory seedPhrase = vm.readFile(".secret");
        uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        vm.startBroadcast(privateKey);
        SOUPR4 soupr4 = new SOUPR4();

        vm.stopBroadcast();
    }
}
