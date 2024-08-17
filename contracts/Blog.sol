// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "hardhat/console.sol";

contract Blog {
  string public name;
  address public owner;

  uint private _postIds;

  struct Post {
    uint id;
    string title;
    string content;
    bool published;
  }

  mapping(uint => Post) private idToPost;
  mapping(string => Post) private hashToPost;

  event PostCreated(uint id, string title, string hash);
  event PostUpdated(uint id, string title, string hash, bool published);

  constructor(string memory _name) {
    console.log("Deploying Blog with name:", _name);
    name = _name;
    owner = msg.sender;
    _postIds = 0;
  }

  function updateName(string memory _name) public {
    name = _name;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }

  function fetchPost(string memory hash) public view returns(Post memory) {
    return hashToPost[hash];
  }

  function createPost(string memory title, string memory hash) public onlyOwner {
     _postIds += 1;
    Post storage post = idToPost[_postIds];
    post.id = _postIds;
    post.title = title;
    post.published = true;
    post.content = hash;
    hashToPost[hash] = post;
    emit PostCreated(_postIds, title, hash);
  }

  function updatePost(uint postId, string memory title, string memory hash, bool published) public onlyOwner {
    Post storage post = idToPost[postId];
    post.title = title;
    post.published = published;
    post.content = hash;
    idToPost[postId] = post;
    hashToPost[hash] = post;
    emit PostUpdated(postId, title, hash, published);
  }

  function fetchPosts() public view returns (Post[] memory) {
    Post[] memory posts = new Post[](_postIds);
    for(uint i = 0; i < _postIds; i++) {
      uint currentId = i + 1;
      Post storage currentItem = idToPost[currentId];
      posts[i] = currentItem;
    }
    return posts;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}