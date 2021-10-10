//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KittygotchiMumbai is ERC721, Ownable {
    using Counters for Counters.Counter;
    uint256 constant MAX_SUPPLY = 100000;
    uint256 constant PRICE = 100;
    Counters.Counter private _tokenIdCounter;
    // DexKit on Mumbai
    address constant DEXKIT = 0xdf2e4383363609351637d262f6963D385b387340;
    // Properties used for games
    mapping(uint256 => uint256) private _attack;
    mapping(uint256 => uint256) private _defense;
    mapping(uint256 => uint256) private _run;
    mapping(uint256 => uint256) private _lastUpdate;

    // If user holds 100 KIT, the feed will return double of points
    uint256 constant POWER_HOLDING_AMOUNT = 100*(10**18);
                                  
    constructor() ERC721("KittyGotchi", "Kitty") {}

    function safeMint() public payable {
        require(msg.value == PRICE, "Sent exact price");
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Max Supply reached" );
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();       
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://mumbai-kittygotchi.dexkit.com/api";
    }

    function contractURI() public view returns (string memory) { 
        return "https://mumbai-kittygotchi.dexkit.com/info";
    }

    function feed(uint256 tokenId) external {
        require(block.timestamp >= _lastUpdate[tokenId] + 24 hours, "You can not feed yet");
        _lastUpdate[tokenId] = block.timestamp;
        require(ownerOf(tokenId) == msg.sender, "Only owner can feed");
        if(IERC20(DEXKIT).balanceOf(msg.sender) >= POWER_HOLDING_AMOUNT){
              _attack[tokenId] = _attack[tokenId] + 2 * (_random(tokenId * 10) % 5);
              _defense[tokenId] = _defense[tokenId] + 2 * (_random(tokenId* 30) % 5);
              _run[tokenId] = _run[tokenId] + 2 * (_random(tokenId * 50) % 5);
        }else{
              _attack[tokenId] = _attack[tokenId] + _random(tokenId * 10 ) % 5;
              _defense[tokenId] = _defense[tokenId] + _random(tokenId * 30) % 5;
              _run[tokenId] = _run[tokenId] + _random(tokenId * 50) % 5;
        } 
    }
    /**
    *
    * If Cat is tired return half of attack
    *
    */
    function getAttackOf(uint256 tokenId) external view  returns (uint256){
        if(block.timestamp > _lastUpdate[tokenId] + 24 hours ){
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
    function getRunOf(uint256 tokenId) external view returns (uint256){
        if(block.timestamp > _lastUpdate[tokenId] + 24 hours ){
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
    function getDefenseOf(uint256 tokenId) external view returns (uint256){
        if(block.timestamp > _lastUpdate[tokenId] + 24 hours ){
            return _defense[tokenId]/2;
        }else{
            return _defense[tokenId];
        }
    }

    /**
    *
    * Cat last update
    *
     */
    function getLastUpdateOf(uint256 tokenId) external view returns (uint256){
       return _lastUpdate[tokenId];
    }

    // We generate a pseudo random number, just for fun
    function _random(uint256 tokenId) private view returns (uint) {   
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, tokenId)));   
    }

    
    function withdrawETH() external payable onlyOwner(){
       (bool sent, ) = owner().call{
            value: address(this).balance
        }("");
        require(sent, "Failed to send Ether");
    }


}