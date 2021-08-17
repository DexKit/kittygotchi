// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Kittygotchi is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address constant DEXKIT = 0x7866E48C74CbFB8183cd1a929cd9b95a7a5CB4F4;
    mapping(address => bool) claims;
    // Properties used for games
    mapping(uint256 => uint256) private _attack;
    mapping(uint256 => uint256) private _defense;
    mapping(uint256 => uint256) private _run;
    mapping(uint256 => uint256) private _lastUpdate;

    // User needs to hold minimum 10 KIT to be able to mint a Kitty
    uint256 constant HOLDING_AMOUNT = 10*(10**18);
    // If user holds 100 KIT, the feed will return double of points
    uint256 constant POWER_HOLDING_AMOUNT = 100*(10**18);
                                  
    constructor() ERC721("Kittygotchi", "Kitty") {}

    function safeMint() public {
        require(IERC20(DEXKIT).balanceOf(msg.sender) >= HOLDING_AMOUNT, "You need 10 KIT to claim");
        require(claims[msg.sender] == false, "Kitty already claimed" );
        claims[msg.sender] = true;
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), baseTokenUri);
        _tokenIdCounter.increment();       
    }

    function feed(uint256 tokenId) external {
        require(block.timestamp >= lastUpdate[msg.sender] + 24 hours, "You can not feed yet");
        lastUpdate[msg.sender] = block.timestamp;
        require(ownerOf(tokenId) == msg.sender, "Only owner can feed");
        if(IERC20(DEXKIT).balanceOf(msg.sender) >= POWER_HOLDING_AMOUNT){
              _attack[tokenId] = _attack[tokenId] + 2;
              _defense[tokenId] = _defense[tokenId] + 2;
              _run[tokenId] = _run[tokenId] + 2;
        }else{
              _attack[tokenId] = _attack[tokenId] + 1;
              _defense[tokenId] = _defense[tokenId] + 1;
              _run[tokenId] = _run[tokenId] +1;
        }
    
    }
    /**
    *
    * If Cat is tired return half of attack
    *
    */
    function getAttackOf(uint256 tokenId) view returns (uint256){
        if(block.timestamp > lastUpdate[msg.sender] + 24 hours ){
            return _attack[tokenId]/2;
        }else{
            return _attack[tokenId];
        }
    }

    /**
    *
    * If Cat is tired return half of Run
    *
     */
    function getRunOf(uint256 tokenId) view returns (uint256){
        if(block.timestamp > lastUpdate[msg.sender] + 24 hours ){
            return _run[tokenId]/2;
        }else{
            return _run[tokenId];
        }
    }

    /**
    *
    * If Cat is tired return half of Defense
    *
     */
    function getDefenseOf(uint256 tokenId) view returns (uint256){
        if(block.timestamp > lastUpdate[msg.sender] + 24 hours ){
            return _defense[tokenId]/2;
        }else{
            return _defense[tokenId];
        }
    }


}