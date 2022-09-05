// SPDX-License-Identifier: GPL

pragma solidity ^0.8.12;

import "https://github.com/Dexaran/CallistoNFT/blob/main/CallistoNFT.sol";

interface IClassifiedNFT is ICallistoNFT  {
    function setClassForTokenID(uint256 _tokenID, uint256 _tokenClass) external;
    function addNewTokenClass() external;
    function addTokenClassProperties(uint256 _propertiesCount) external;
    function modifyClassProperty(uint256 _classID, uint256 _propertyID, string memory _content) external;
    function getClassProperty(uint256 _classID, uint256 _propertyID) external view returns (string memory);
    function addClassProperty(uint256 _classID) external;
    function getClassProperties(uint256 _classID) external view returns (string[] memory);
    function getClassForTokenID(uint256 _tokenID) external view returns (uint256);
    function getClassPropertiesForTokenID(uint256 _tokenID) external view returns (string[] memory);
    function getClassPropertyForTokenID(uint256 _tokenID, uint256 _propertyID) external view returns (string memory);
    function mintWithClass(address _to, uint256 _tokenId, uint256 _classId)  external;
    function appendClassProperty(uint256 _classID, uint256 _propertyID, string memory _content) external;
}

/**
 * @title CallistoNFT Classified NFT
 * @dev This extension adds propeties to NFTs based on classes.
 */
abstract contract ClassifiedNFT is CallistoNFT, IClassifiedNFT {

    mapping (uint256 => string[]) public class_properties;
    mapping (uint256 => uint256)  public token_classes;

    uint256 private nextClassIndex = 0;

    modifier onlyExistingClasses(uint256 classId)
    {
        require(classId < nextClassIndex, "Queried class does not exist");
        _;
    }

    function setClassForTokenID(uint256 _tokenID, uint256 _tokenClass) public override /* onlyOwner */
    {
        token_classes[_tokenID] = _tokenClass;
    }

    function addNewTokenClass() public override /* onlyOwner */
    {
        class_properties[nextClassIndex].push("");
        nextClassIndex++;
    }

    function addTokenClassProperties(uint256 _classId, uint256 _propertiesCount) public override /* onlyOwner */
    {
        for (uint i = 0; i < _propertiesCount; i++)
        {
            class_properties[_classId].push("");
        }
    }

    function modifyClassProperty(uint256 _classID, uint256 _propertyID, string memory _content) public override /* onlyOwner */ onlyExistingClasses(_classID)
    {
        class_properties[_classID][_propertyID] = _content;
    }

    function getClassProperty(uint256 _classID, uint256 _propertyID) public override view onlyExistingClasses(_classID) returns (string memory)
    {
        return class_properties[_classID][_propertyID];
    }

    function addClassProperty(uint256 _classID) public override /* onlyOwner */ onlyExistingClasses(_classID)
    {
        class_properties[_classID].push("");
    }

    function getClassProperties(uint256 _classID) public override view onlyExistingClasses(_classID) returns (string[] memory)
    {
        return class_properties[_classID];
    }

    function getClassForTokenID(uint256 _tokenID) public override view onlyExistingClasses(token_classes[_tokenID]) returns (uint256)
    {
        return token_classes[_tokenID];
    }

    function getClassPropertiesForTokenID(uint256 _tokenID) public override view onlyExistingClasses(token_classes[_tokenID]) returns (string[] memory)
    {
        return class_properties[token_classes[_tokenID]];
    }

    function getClassPropertyForTokenID(uint256 _tokenID, uint256 _propertyID) public override view onlyExistingClasses(token_classes[_tokenID]) returns (string memory)
    {
        return class_properties[token_classes[_tokenID]][_propertyID];
    }
    
    function mintWithClass(address to, uint256 tokenId, uint256 classId)  public override /* onlyOwner */ onlyExistingClasses(classId)
    {
        _mint(to, tokenId);
        token_classes[tokenId] = classId;
    }

    function appendClassProperty(uint256 _classID, uint256 _propertyID, string memory _content) public override /* onlyOwner */ onlyExistingClasses(_classID)
    {
        class_properties[_classID][_propertyID] = string.concat(class_properties[_classID][_propertyID], _content);
    }
}
