//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CoinsLeagueChampions is ERC721, ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 constant MAX_SUPPLY = 15000;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    // rinkeby: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
    address public LinkToken;
    // rinkeby: 0x01BE23585060835E02B77ef475b0Cc51aA1e0709a
    mapping(uint256 => uint256) public rarity;
    mapping(bytes32 => address) requestToSender;
    mapping(bytes32 => uint256) requestToTokenId;

    uint256 [] accumulated_rarity = [0, 250, 410, 525, 595, 655, 710, 760, 805, 840, 870, 895, 915, 930, 942, 950, 955];
                                  
    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
    ERC721("CoinsLeagueChampions", "Champions")
    VRFConsumerBase(
            _VRFCoordinator, // VRF Coordinator
            _LinkToken  // LINK Token
        ) public
     {
        VRFCoordinator = _VRFCoordinator;
        LinkToken = _LinkToken;
        keyHash = _keyhash;
        fee = 0.1 * 10**18; // 0.1 LINK

    }

    function safeMint() public payable returns (bytes32 requestId)  {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );

        require(_tokenIdCounter.current() <= MAX_SUPPLY, "Max Supply reached" );
        uint256 requiredAmount = 20 ether;

        if(_tokenIdCounter.current() > 5000){
           requiredAmount = 30 ether;
        }

        if(_tokenIdCounter.current() > 10000){
           requiredAmount = 40 ether;
        }
        require(msg.value >= requiredAmount, "Not enough amount" );
     
        requestId = requestRandomness(keyHash, fee);
        requestToSender[requestId] = msg.sender;
        requestToTokenId[requestId] = _tokenIdCounter.current();
        _tokenIdCounter.increment();       
        return requestId;   
    }

    function price() external returns (uint256 memory _price){
        uint256 _price = 20 ether;

        if(_tokenIdCounter.current() > 5000){
           _price = 30 ether;
        }

        if(_tokenIdCounter.current() > 10000){
           _price = 40 ether;
        }
        return _price;
    }


    function _baseURI() internal pure override returns (string memory) {
        return "https://coinsleaguechampions.dexkit.com";
    }

    function contractURI() public view returns (string memory) { 
        return "https://coinsleaguechampions.dexkit.com/info";
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 id = requestToTokenId[requestId];
        uint256 randomRarity = (randomNumber % 1000);
        uint256 index = 0;
        for(uint256 i = 0; i < accumulated_rarity.length; i++){
            if(accumulated_rarity[i] >= randomRarity && accumulated_rarity[i] < randomRarity){
                index = i;
                break;
            }
        }
        rarity[id] = index +1;
        _safeMint(requestToSender[requestId], requestToTokenId[requestId]);
    }
    


}