// SPDX-License-Identifier: GPL

pragma solidity ^0.8.0;


//https://github.com/willitscale/solidity-util/blob/000a42d4d7c1491cde4381c29d4b775fa7e99aac/lib/Strings.sol#L317-L336

/**
 * Strings Library
 * 
 * In summary this is a simple library of string functions which make simple 
 * string operations less tedious in solidity.
 * 
 * Please be aware these functions can be quite gas heavy so use them only when
 * necessary not to clog the blockchain with expensive transactions.
 * 
 * @author James Lockhart <james@n3tw0rk.co.uk>
 */
library Strings {

    /**
     * Concat (High gas cost)
     * 
     * Appends two strings together and returns a new value
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string which will be the concatenated
     *              prefix
     * @param _value The value to be the concatenated suffix
     * @return string The resulting string from combinging the base and value
     */
    function concat(string memory _base, string memory _value)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length > 0);

        string memory _tmpValue = new string(_baseBytes.length +
            _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param _value The needle to search for, at present this is currently
     *               limited to one character
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function indexOf(string memory _base, string memory _value)
        internal
        pure
        returns (int) {
        return _indexOf(_base, _value, 0);
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string starting
     * from a defined offset
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param _value The needle to search for, at present this is currently
     *               limited to one character
     * @param _offset The starting point to start searching from which can start
     *                from 0, but must not exceed the length of the string
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function _indexOf(string memory _base, string memory _value, uint _offset)
        internal
        pure
        returns (int) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length == 1);

        for (uint i = _offset; i < _baseBytes.length; i++) {
            if (_baseBytes[i] == _valueBytes[0]) {
                return int(i);
            }
        }

        return -1;
    }

    /**
     * Length
     * 
     * Returns the length of the specified string
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string to be measured
     * @return uint The length of the passed string
     */
    function length(string memory _base)
        internal
        pure
        returns (uint) {
        bytes memory _baseBytes = bytes(_base);
        return _baseBytes.length;
    }

    /**
     * Sub String
     * 
     * Extracts the beginning part of a string based on the desired length
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string that will be used for 
     *              extracting the sub string from
     * @param _length The length of the sub string to be extracted from the base
     * @return string The extracted sub string
     */
    function substring(string memory _base, int _length)
        internal
        pure
        returns (string memory) {
        return _substring(_base, _length, 0);
    }

    /**
     * Sub String
     * 
     * Extracts the part of a string based on the desired length and offset. The
     * offset and length must not exceed the lenth of the base string.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string that will be used for 
     *              extracting the sub string from
     * @param _length The length of the sub string to be extracted from the base
     * @param _offset The starting point to extract the sub string from
     * @return string The extracted sub string
     */
    function _substring(string memory _base, int _length, int _offset)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);

        assert(uint(_offset + _length) <= _baseBytes.length);

        string memory _tmp = new string(uint(_length));
        bytes memory _tmpBytes = bytes(_tmp);

        uint j = 0;
        for (uint i = uint(_offset); i < uint(_offset + _length); i++) {
            _tmpBytes[j++] = _baseBytes[i];
        }

        return string(_tmpBytes);
    }
    
    function split(string memory _base, string memory _value)
        internal
        pure
        returns (string[] memory splitArr) {
        bytes memory _baseBytes = bytes(_base);

        uint _offset = 0;
        uint _splitsCount = 1;
        while (_offset < _baseBytes.length - 1) {
            int _limit = _indexOf(_base, _value, _offset);
            if (_limit == -1)
                break;
            else {
                _splitsCount++;
                _offset = uint(_limit) + 1;
            }
        }

        splitArr = new string[](_splitsCount);

        _offset = 0;
        _splitsCount = 0;
        while (_offset < _baseBytes.length - 1) {

            int _limit = _indexOf(_base, _value, _offset);
            if (_limit == - 1) {
                _limit = int(_baseBytes.length);
            }

            string memory _tmp = new string(uint(_limit) - _offset);
            bytes memory _tmpBytes = bytes(_tmp);

            uint j = 0;
            for (uint i = _offset; i < uint(_limit); i++) {
                _tmpBytes[j++] = _baseBytes[i];
            }
            _offset = uint(_limit) + 1;
            splitArr[_splitsCount++] = string(_tmpBytes);
        }
        return splitArr;
    }

    /**
     * Compare To
     * 
     * Compares the characters of two strings, to ensure that they have an 
     * identical footprint
     * 
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string base to compare against
     * @param _value The string the base is being compared to
     * @return bool Simply notates if the two string have an equivalent
     */
    function compareTo(string memory _base, string memory _value)
        internal
        pure
        returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i]) {
                return false;
            }
        }

        return true;
    }

    /**
     * Compare To Ignore Case (High gas cost)
     * 
     * Compares the characters of two strings, converting them to the same case
     * where applicable to alphabetic characters to distinguish if the values
     * match.
     * 
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string base to compare against
     * @param _value The string the base is being compared to
     * @return bool Simply notates if the two string have an equivalent value
     *              discarding case
     */
    function compareToIgnoreCase(string memory _base, string memory _value)
        internal
        pure
        returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i] &&
            _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
                return false;
            }
        }

        return true;
    }

    /**
     * Upper
     * 
     * Converts all the values of a string to their corresponding upper case
     * value.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string base to convert to upper case
     * @return string 
     */
    function upper(string memory _base)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _upper(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
     * Lower
     * 
     * Converts all the values of a string to their corresponding lower case
     * value.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string base to convert to lower case
     * @return string 
     */
    function lower(string memory _base)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _lower(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
     * Upper
     * 
     * Convert an alphabetic character to upper case and return the original
     * value when not alphabetic
     * 
     * @param _b1 The byte to be converted to upper case
     * @return bytes1 The converted value if the passed value was alphabetic
     *                and in a lower case otherwise returns the original value
     */
    function _upper(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }

        return _b1;
    }

    /**
     * Lower
     * 
     * Convert an alphabetic character to lower case and return the original
     * value when not alphabetic
     * 
     * @param _b1 The byte to be converted to lower case
     * @return bytes1 The converted value if the passed value was alphabetic
     *                and in a upper case otherwise returns the original value
     */
    function _lower(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x41 && _b1 <= 0x5A) {
            return bytes1(uint8(_b1) + 32);
        }

        return _b1;
    }
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

interface INFT {
    
    struct Properties {
        
        // In this example properties of the given NFT are stored
        // in a dynamically sized array of strings
        // properties can be re-defined for any specific info
        // that a particular NFT is intended to store.
        
        /* Properties could look like this:
        bytes   property1;
        bytes   property2;
        address property3;
        */
        
        string[] properties;
    }
    
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function standard() external view returns (string memory);
    function balanceOf(address _who) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function transfer(address _to, uint256 _tokenId, bytes calldata _data) external returns (bool);
    function silentTransfer(address _to, uint256 _tokenId) external returns (bool);
    
    function priceOf(uint256 _tokenId) external view returns (uint256);
    function bidOf(uint256 _tokenId) external view returns (uint256 price, address payable bidder, uint256 timestamp);
    function getTokenProperties(uint256 _tokenId) external view returns (Properties memory);
    
    function setBid(uint256 _tokenId, bytes calldata _data) payable external; // bid amount is defined by msg.value
    function setPrice(uint256 _tokenId, uint256 _amountInWEI) external;
    function withdrawBid(uint256 _tokenId) external returns (bool);
}

abstract contract NFTReceiver {
    function nftReceived(address _from, uint256 _tokenId, bytes calldata _data) external virtual;
}

// ExtendedNFT is a version of the CallistoNFT standard token
// that implements a set of function for NFT content management
contract ExtendedNFT is INFT {
    using Strings for string;
    using Address for address;
    
    event Transfer     (address indexed from, address indexed to, uint256 indexed tokenId);
    event TransferData (bytes data);
    
    mapping (uint256 => Properties) private _tokenProperties;
    mapping (uint32 => Fee)         public feeLevels; // level # => (fee receiver, fee percentage)
    
    uint256 public bidLock = 1 days; // Time required for a bid to become withdrawable.
    
    struct Bid {
        address payable bidder;
        uint256 amountInWEI;
        uint256 timestamp;
    }
    
    struct Fee {
        address payable feeReceiver;
        uint256 feePercentage; // Will be divided by 100000 during calculations
                               // feePercentage of 100 means 0.1% fee
                               // feePercentage of 2500 means 2.5% fee
    }
    
    mapping (uint256 => uint256) private _asks; // tokenID => price of this token (in WEI)
    mapping (uint256 => Bid)     private _bids; // tokenID => price of this token (in WEI)
    mapping (uint256 => uint32)  private _tokenFeeLevels; // tokenID => level ID / 0 by default

    uint256 private next_mint_id;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;
    
    modifier checkTrade(uint256 _tokenId)
    {
        _;
        (uint256 _bid, address payable _bidder,) = bidOf(_tokenId);
        if(priceOf(_tokenId) > 0 && priceOf(_tokenId) <= _bid)
        {
            uint256 _reward = _bid - _claimFee(_bid, _tokenId);
            payable(ownerOf(_tokenId)).transfer(_reward);
            delete _bids[_tokenId];
            delete _asks[_tokenId];
            _transfer(ownerOf(_tokenId), _bidder, _tokenId);
            if(address(_bidder).isContract())
            {
                NFTReceiver(_bidder).nftReceived(ownerOf(_tokenId), _tokenId, hex"000000");
            }
        }
    }
    
    function standard() public view virtual override returns (string memory)
    {
        return "NFT X";
    }

    function mint() public /* onlyOwner or onlyAdmin */ returns (uint256 _mintedId)
    {
        _safeMint(msg.sender, next_mint_id);
        _mintedId = next_mint_id;
        next_mint_id++;
    }
    
    function priceOf(uint256 _tokenId) public view virtual override returns (uint256)
    {
        address owner = _owners[_tokenId];
        require(owner != address(0), "NFT: owner query for nonexistent token");
        return _asks[_tokenId];
    }
    
    function bidOf(uint256 _tokenId) public view virtual override returns (uint256 price, address payable bidder, uint256 timestamp)
    {
        address owner = _owners[_tokenId];
        require(owner != address(0), "NFT: owner query for nonexistent token");
        return (_bids[_tokenId].amountInWEI, _bids[_tokenId].bidder, _bids[_tokenId].timestamp);
    }
    
    function getTokenProperties(uint256 _tokenId) public view virtual override returns (Properties memory)
    {
        return _tokenProperties[_tokenId];
    }

    function getTokenProperty(uint256 _tokenId, uint256 _propertyId)  public view virtual returns (string memory)
    {
        return _tokenProperties[_tokenId].properties[_propertyId];
    }

    function addPropertyWithContent(uint256 _tokenId, string calldata _content) public /* onlyOwner or onlyTokenOwner */
    {
        // Check permission criteria

        _tokenProperties[_tokenId].properties.push(_content);
    }

    function modifyProperty(uint256 _tokenId, uint256 _propertyId, string calldata _content) public /* onlyOwner or onlyTokenOwner*/
    {
        _tokenProperties[_tokenId].properties[_propertyId] = _content;
    }

    function appendProperty(uint256 _tokenId, uint256 _propertyId, string calldata _content) public /* onlyOwner or onlyTokenOwner*/
    {
        _tokenProperties[_tokenId].properties[_propertyId] = _tokenProperties[_tokenId].properties[_propertyId].concat(_content);
    }
    
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "NFT: balance query for the zero address");
        return _balances[owner];
    }
    
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "NFT: owner query for nonexistent token");
        return owner;
    }
    
    function setPrice(uint256 _tokenId, uint256 _amountInWEI) checkTrade(_tokenId) public virtual override {
        require(ownerOf(_tokenId) == msg.sender, "Setting asks is only allowed for owned NFTs!");
        _asks[_tokenId] = _amountInWEI;
    }
    
    function setBid(uint256 _tokenId, bytes calldata _data) payable checkTrade(_tokenId) public virtual override
    {
        (uint256 _previousBid, address payable _previousBidder, ) = bidOf(_tokenId);
        require(msg.value > _previousBid, "New bid must exceed the existing one");
        
        // Return previous bid if the current one exceeds it.
        if(_previousBid != 0)
        {
            _previousBidder.transfer(_previousBid);
        }
        _bids[_tokenId].amountInWEI = msg.value;
        _bids[_tokenId].bidder      = payable(msg.sender);
        _bids[_tokenId].timestamp   = block.timestamp;
    }
    
    function withdrawBid(uint256 _tokenId) public virtual override returns (bool)
    {
        (uint256 _bid, address payable _bidder, uint256 _timestamp) = bidOf(_tokenId);
        require(msg.sender == _bidder, "Can not withdraw someone elses bid");
        require(block.timestamp > _timestamp + bidLock, "Bid is time-locked");
        
        _bidder.transfer(_bid);
        delete _bids[_tokenId];
        return true;
    }
    
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    
    function transfer(address _to, uint256 _tokenId, bytes calldata _data) public override returns (bool)
    {
        _transfer(msg.sender, _to, _tokenId);
        if(_to.isContract())
        {
            NFTReceiver(_to).nftReceived(msg.sender, _tokenId, _data);
        }
        emit TransferData(_data);
        return true;
    }
    
    function silentTransfer(address _to, uint256 _tokenId) public override returns (bool)
    {
        _transfer(msg.sender, _to, _tokenId);
        return true;
    }
    
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    
    function _claimFee(uint256 _amountFrom, uint256 _tokenId) internal returns (uint256)
    {
        uint32 _level          = _tokenFeeLevels[_tokenId];
        address _feeReceiver   = feeLevels[_level].feeReceiver;
        uint256 _feePercentage = feeLevels[_level].feePercentage;
        
        uint256 _feeAmount = _amountFrom * _feePercentage / 100000;
        payable(_feeReceiver).transfer(_feeAmount);
        return _feeAmount;        
    }
    
    function _safeMint(
        address to,
        uint256 tokenId
    ) internal virtual {
        _mint(to, tokenId);
    }
    
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "NFT: mint to the zero address");
        require(!_exists(tokenId), "NFT: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
    
    function _burn(uint256 tokenId) internal virtual {
        address owner = ExtendedNFT.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);
        

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
    
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ExtendedNFT.ownerOf(tokenId) == from, "NFT: transfer of token that is not own");
        require(to != address(0), "NFT: transfer to the zero address");
        
        _asks[tokenId] = 0; // Zero out price on transfer
        
        // When a user transfers the NFT to another user
        // it does not automatically mean that the new owner
        // would like to sell this NFT at a price
        // specified by the previous owner.
        
        // However bids persist regardless of token transfers
        // because we assume that the bidder still wants to buy the NFT
        // no matter from whom.

        _beforeTokenTransfer(from, to, tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}


contract NFTSimpleAuction {

    address public nft_contract;

    uint256 public max_supply = 1; // This auction will sell exactly this number of NFTs.
    uint256 public amount_sold = 0; // Increments on each successful NFT purchase until it reachess `max_supply`.

    uint256 public start_timestamp = 1643125054; // UNIX timestamp of the auction start event.
    uint256 public duration = 3 days;

    uint public priceInWEI = 1e18; // 1 ether per NFT.

    address payable public revenue = payable(0x01000B5fE61411C466b70631d7fF070187179Bbf); // This address has the rights to withdraw funds from the auction.

    function buyNFT() public payable
    {
        require(msg.value >= priceInWEI, "Insufficient funds");
        require(amount_sold < max_supply, "This auction has already sold all allocated NFTs");

        uint256 _mintedId = ExtendedNFT(nft_contract).mint();
        configureNFT(_mintedId);
        amount_sold++;
    }

    function configureNFT(uint256 _tokenId) internal
    {

    }

    function withdrawRevenue() public
    {
        require(msg.sender == revenue, "This action requires revenue permission");
        revenue.transfer(address(this).balance);
    }
}
