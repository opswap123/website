{\rtf1\ansi\ansicpg936\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 pragma solidity >=0.4.16;\
\
contract IERC20\{\
    string public symbol;\
    string public name;\
    uint256 public totalSupply;\
    uint8 public decimals;\
\
    function balanceOf(address _owner) public view returns (uint256 balance);\
    function transfer(address _to, uint256 _value) public returns (bool success);\
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\
    function approve(address _spender, uint256 _value) public returns (bool success);\
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\
\
    event Transfer(address indexed _from, address indexed _to, uint256 _value);\
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\
\}\
\
// deploye\
// rinkeby: 0xFfbD22F33AB8cEC3dfc0d97499cE9d6693AA134D\
\
// 
\f1 \'b1\'ea\'d7\'bc
\f0 ERC20\
contract ERC20Token is IERC20 \{\
    \
    constructor(uint256 initialAmount, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) public \{\
        totalSupply = initialAmount * 10 ** uint256(decimalUnits);\
        balances[msg.sender] = totalSupply;\
        \
        name = tokenName;\
        symbol = tokenSymbol;\
        decimals = decimalUnits;\
    \}\
    \
    function transfer(address _to, uint256 _value) public returns (bool success) \{\
        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);\
        require(_to != address(0));\
        balances[msg.sender] -= _value;\
        balances[_to] += _value;\
        emit Transfer(msg.sender, _to, _value);\
        \
        return true;\
    \}\
\
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) \{\
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\
        balances[_to] += _value;\
        balances[_from] -= _value;\
        allowed[_from][msg.sender] -= _value;\
        emit Transfer(_from, _to, _value);\
        \
        return true;\
    \}\
    \
    function balanceOf(address _owner) public view returns (uint256 balance) \{\
        return balances[_owner];\
    \}\
\
    function approve(address _spender, uint256 _value) public returns (bool success) \{ \
        allowed[msg.sender][_spender] = _value;\
        emit Approval(msg.sender, _spender, _value);\
        return true;\
    \}\
\
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) \{\
        return allowed[_owner][_spender];\
    \}\
    \
    mapping (address => uint256) balances;\
    mapping (address => mapping (address => uint256)) allowed;\
\}}