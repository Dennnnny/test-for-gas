// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721A} from "ERC721A/ERC721A.sol";
import {ERC721Enumerable} from "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MY_ERC721 is ERC721Enumerable {
  constructor() ERC721 ("erc721","erc721") ERC721Enumerable () {}

  function mint (address _to, uint256 _tokenId) public {
    _safeMint(_to, _tokenId);
  }

  function transfer(address from, address to, uint256 tokenId) public {
    _safeTransfer(from, to, tokenId);
  }


}
contract MY_ERC721A is ERC721A {
  constructor() ERC721A ("erc721a","erc721a") {}

  function mint (address _to, uint256 _quantity) public {
    _safeMint(_to, _quantity);
  }

  function transfer(address from, address to, uint256 tokenId) public {
    transferFrom(from, to, tokenId);
  }

}

contract ERC721Test is Test {

  MY_ERC721 erc721;
  MY_ERC721A erc721a;

  address user1 = makeAddr("user1");
  address user2 = makeAddr("user2");
  address user3 = makeAddr("user3");
  address user4 = makeAddr("user4");

  uint256 mintTimes = 100;

  function setUp() public{
    erc721 = new MY_ERC721();
    erc721a = new MY_ERC721A();
  }

  function testMint() public {
    for (uint256 index = 0; index < mintTimes; index++) {
      erc721.mint(user1, index);
    }

    assertEq(erc721.balanceOf(user1),mintTimes);
  }

  function test721AMint() public {
    erc721a.mint(user2, mintTimes);

    assertEq(erc721a.balanceOf(user2), mintTimes);
  }

  function testTransfer() public {
    uint256 amount = 10;
    uint256 target = 5;
    for (uint256 index = 0; index < amount; index++) {  
      erc721.mint(user1, index);
    }
    assertEq(erc721.balanceOf(user1), amount);
    assertEq(erc721.balanceOf(user3), 0);
    erc721.transfer(user1, user3, target);
    assertEq(erc721.balanceOf(user1), amount - 1);
    assertEq(erc721.balanceOf(user3), 1);
    assertEq(erc721.ownerOf(target), user3);

  }

  function test721ATransfer() public {
    uint256 amount = 10;
    uint256 target = 5;
    erc721a.mint(user2, amount);
    assertEq(erc721a.balanceOf(user2), amount);
    assertEq(erc721a.balanceOf(user4), 0);
    vm.prank(user2);
    erc721a.transfer(user2, user4, target);
    assertEq(erc721a.balanceOf(user2), amount - 1);
    assertEq(erc721a.balanceOf(user4), 1);
    assertEq(erc721a.ownerOf(target), user4);
  }

  function testApprove() public {
    erc721.mint(user1, 0);
    vm.prank(user1);
    erc721.approve(user3, 0);
    assertEq(erc721.getApproved(0), user3);
  }

  function test721aApprove() public {
    erc721a.mint(user2, 1);
    vm.prank(user2);
    erc721a.approve(user4, 0);
    assertEq(erc721a.getApproved(0), user4);
  }

}
