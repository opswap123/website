pragma solidity ^0.5.6;

import "./interfaces/ITRWERC20.sol";

contract TRWERC20 is ITRWERC20 {

    string public name;
    string public symbol;
    uint8  public decimals = 8;

    address _cfo;
    mapping (address => uint256) _balances;
    uint256 _supply;
    mapping (address => mapping (address => uint256)) _approvals;
    
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
        ) 
        public 
    {
        _cfo = msg.sender;
        _supply = initialSupply * 10 ** uint256(decimals);
        _balances[_cfo] = _supply;
        
        name = tokenName;
        symbol = tokenSymbol;
    }

    function totalSupply() public returns (uint256) {
        return _supply;
    }

    function balanceOf(address src) public returns (uint256) {
        return _balances[src];
    }
    
    function allowance(address src, address guy) public returns (uint256) {
        return _approvals[src][guy];
    }
    
    function transfer(address dst, uint wad) public returns (bool) {
        assert(_balances[msg.sender] >= wad);
        
        _balances[msg.sender] = _balances[msg.sender] - wad;
        _balances[dst] = _balances[dst] + wad;
        
        emit Transfer(msg.sender, dst, wad);
        
        return true;
    }
    
    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        assert(_balances[src] >= wad);
        assert(_approvals[src][msg.sender] >= wad);
        
        _approvals[src][msg.sender] = _approvals[src][msg.sender] - wad;
        _balances[src] = _balances[src] - wad;
        _balances[dst] = _balances[dst] + wad;
        
        emit Transfer(src, dst, wad);
        
        return true;
    }
    
    function approve(address guy, uint256 wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;
        
        emit Approval(msg.sender, guy, wad);
        
        return true;
    }
    
}