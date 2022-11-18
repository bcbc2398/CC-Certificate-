// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";


contract CarbonNFT is ERC721URIStorage, Ownable, AutomationCompatibleInterface {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(string => uint8) hashes;
    uint256 public tokenCounter;
    uint256 public interval;
    uint256 public lastTimeStamp;


    constructor (uint256 _interval) ERC721("CC", "CC") {
        tokenCounter = 0;
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }

    function awardItem(address recipient, string memory hash, string memory metadata)

    public

    returns (uint256)

    { 

    require(hashes[hash] != 1); 

    hashes[hash] = 1; 

    _tokenIds.increment(); 

    uint256 newItemId = _tokenIds.current(); 

    _mint(recipient, newItemId);  _setTokenURI(newItemId, metadata); 

    return newItemId;

          } 

    function tokenURI(uint256 tokenId)

     public

     view

     override(ERC721URIStorage)

     returns (string memory)

    {

        return super.tokenURI(tokenId);

    }

    function checkUpkeep (bytes calldata) external override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep(bytes calldata) external override  {
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;
        }
    }

}