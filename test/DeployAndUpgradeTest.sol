// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {console} from "forge-std/console.sol";
 
contract DeployAndUpgradeTest is Test{
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER;

    address public proxy;
    

    function setUp() public{ 
        deployer= new DeployBox();
        upgrader= new UpgradeBox();

         OWNER = makeAddr("owner");  // Now makeAddr will work
        proxy= deployer.run();
    }

    function testProxyStartsAsBox1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(11);
    }

    function testUpgrade() public{
        // address upgrader = upgrader.run();
        // address original = deployer.run();

        // assertEq(upgrader , original);
        // assertEq(2,BoxV1(proxy).version());
        BoxV2 box2= new BoxV2();


        upgrader.upgradeBox(proxy, address(box2));
        uint256 expectedValue= 2;
        assertEq(expectedValue , BoxV2(proxy).version());

        BoxV2(proxy).setNumber(11);
        // console.log("getNumber", getNumber);
        assertEq(BoxV2(proxy).getNumber() , 11);
    }
}