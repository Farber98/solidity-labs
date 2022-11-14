pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "../src/soupr4.sol";

contract Soupr4Test is Test {
    SOUPR4 soupr4;

    function setUp() public {
        soupr4 = new SOUPR4();
    }

    function testNameIsSoupr4() public {
        assertEq(soupr4.name(), "SOUPR4");
    }

    function testMintingNFTs() public {
        soupr4.safeMint(
            msg.sender,
            "QmNu8vQ3yXBykzJMy88sWnd2VKwfHDFqHHCNSoFVimpY2J"
        );
        assertEq(soupr4.ownerOf(0), msg.sender);
        assertEq(
            soupr4.tokenURI(0),
            "https://gateway.pinata.cloud/ipfs/QmNu8vQ3yXBykzJMy88sWnd2VKwfHDFqHHCNSoFVimpY2J"
        );
    }

    function testNftCreationWrongOwner() public {
        vm.startPrank(address(0x1));
        vm.expectRevert("Ownable: caller is not the owner");
        soupr4.safeMint(
            address(0x1),
            "QmNu8vQ3yXBykzJMy88sWnd2VKwfHDFqHHCNSoFVimpY2J"
        );
        vm.stopPrank();
    }
}
