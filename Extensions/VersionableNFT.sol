// SPDX-License-Identifier: GPL

pragma solidity ^0.8.0;

//import "../Libraries/Address.sol"; **Address is declared on NFT.sol"
import "../NFT.sol";

abstract contract VersionableNFT is NFT{
    uint256 public relevantVersion = 1;

    mapping (uint256 => uint256) public token_versions;

    function selfUpdate(uint256 _tokenID) internal
    {
        // This function updates token info based on what changed since the token_version to relevantVersion
    }
}
