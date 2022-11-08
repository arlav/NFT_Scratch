pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";


contract ArchNFT is ERC721, VRFConsumerBase {


    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public 
    VRFConsumer(_VRFCoordinator, _LinkToken)
    ERC721("ArchNFT", "ARCH")
    {

    }

    //@dev tokenURI might point to an API as well
    //@dev this creates the NFT token
    function createCollectible(uint256 userProvidedSeed, string memory tokenURI)
    public returns (bytes32) 
    {

    }


}