pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";


contract ArchNFT is ERC721, VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 public fee;
    uint256 public tokenCounter;



    //@dev enumerate architectural styles for the NFT - this gets chosen at mint time
    enum Style
    {
        MODERN,
        ART_DECO,
        DECON,
        CONSTRUCT,
        HIGH_TECH
    }

    //@dev mapping of the random bytes to the address sender and to the token uri
    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    //mapping(uint256 => style) public requestIdToStyle; //delete
    mapping(address => uint256) public requestIdToTokenCounter;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    mapping(uint256 => Style) public tokenIdToStyle; 

    //@dev mapping of the token id to the address sender and
    //@dev emit an event for testing
    event RequestedCollectible(bytes32 indexed requestId);



    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public 
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("ArchNFT", "ARCH")
    {
        keyHash = _keyhash;
        fee = 0.1 * 10 ** 18; // @dev equals 0.1 link
        tokenCounter = 0;
    }

    //@dev tokenURI might point to an API as well
    //@dev this creates the NFT token
    function createCollectible(uint256 userProvidedSeed, string memory tokenURI)
    public returns (bytes32) 
    {
            bytes32 requestId = requestRandomness(keyHash, fee); //@dev request randomness from VRFcoordinaator
            requestIdToSender[requestId] = msg.sender; //@dev return the request id to the activating address
            requestIdToTokenURI[requestId] = tokenURI; //@dev return the request id to the token URI
            emit RequestedCollectible(requestId); //@dev emit event of requestedcollectible - useful for testing

    }

    function fulfillRaandomness(bytes32 requestId, uint256 randomNumber) 
    internal override
    {
        address ArchNFTOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(ArchNFTOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        Style archStyle = Style(randomNumber % 3); //@dev use the remainder left over from the division randomnumber to 3 to select an architectural style from the enum style
        tokenIdToStyle[newItemId] = Style;
        requestIdToTokenId[requestId] = newItemId;
        tokenCounter = tokenCounter + 1;



    }


}