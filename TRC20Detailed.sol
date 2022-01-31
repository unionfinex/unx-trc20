pragma solidity ^0.5.0;

import "./ITRC20.sol";

contract TRC20Detailed is ITRC20 {
    address private _owner;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping (address => bool) private _blackList;
    
    constructor (address owner,string memory name, string memory symbol, uint8 decimals) public {
        _owner = owner;
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function owner() public view returns(address) {
        return _owner;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function _setOwner(address newOwner) internal {
        require(msg.sender == owner(), "TRC20Detailed: caller is not the owner");
        _owner = newOwner;
    }

    function _getBlackList(address addr) internal view returns(bool) {
        return _blackList[addr];
    }

    function _setBlackList(address addr,bool status) internal {
        require(msg.sender == owner(), "TRC20Detailed: caller is not the owner");
        _blackList[addr] = status;
    }
}

