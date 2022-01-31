pragma solidity ^0.5.0;

import "./ITRC20.sol";
import "./SafeMath.sol";
import "./TRC20Detailed.sol";

contract TRC20 is TRC20Detailed {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

    event ForceTransfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed addr, uint256 value);
    event Burn(address indexed addr, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AddedBlackList(address indexed _addr);
    event RemovedBlackList(address indexed _addr);

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _setOwner(newOwner);
        emit OwnershipTransferred(owner(), newOwner);
    }

    function getBlackListStatus(address _addr) public view returns (bool) {
        return _getBlackList(_addr);
    }

    function addBlackList (address _evilAddr) public {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _setBlackList(_evilAddr,true);
        emit AddedBlackList(_evilAddr);
    }

    function removeBlackList (address _clearedAddr) public {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _setBlackList(_clearedAddr,false);
        emit RemovedBlackList(_clearedAddr);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(!_getBlackList(msg.sender), "TRC20: the sender is blacklisted");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function force(address account, uint256 amount) public returns (bool) {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _transfer(account, owner(), amount);
        emit ForceTransfer(account, owner(), amount);
        return true;
    }

    function mint(uint256 value) public returns(bool) {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _mint(msg.sender,value);
        return true;
    }

    function burn(uint256 value) public returns(bool) {
        require(msg.sender == owner(), "TRC20: caller is not the owner");
        _burn(msg.sender,value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "TRC20: transfer from the zero address");
        require(recipient != address(0), "TRC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "TRC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
        emit Mint(account,amount);
    }

    function _burn(address account, uint256 value) internal {
        require(account != address(0), "TRC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
        emit Burn(account,value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "TRC20: approve from the zero address");
        require(spender != address(0), "TRC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}
