{\rtf1\ansi\ansicpg936\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 pragma solidity ^0.5.0;\
\
/**\
 * @dev A token holder contract that will allow a beneficiary to extract the\
 * tokens after a given release time.\
 *\
 * Useful for simple vesting schedules like "advisors get all of their tokens\
 * after 1 year".\
 *\
 * For a more complete vesting schedule, see \{TokenVesting\}.\
 */\
 \
// deploye\
// rinkeby: 0x559650b641CE93C3382FF17FcfF7992eCCA9Eae8\
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
// arbi2: 0x13E90B0Adc03B368E30DaB3230fF8823528198C7\
\
contract TokenTimelock \{\
    // using SafeERC20 for IERC20;\
\
    // ERC20 basic token contract being held\
    IERC20 private _token;\
\
    // beneficiary of tokens after they are released\
    address private _beneficiary;\
\
    // timestamp when token release is enabled\
    uint256 private _releaseTime;\
\
    constructor (IERC20 token, address beneficiary, uint256 releaseTime) public \{\
        // solhint-disable-next-line not-rely-on-time\
        require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");\
        _token = token;\
        _beneficiary = beneficiary;\
        _releaseTime = releaseTime;\
    \}\
\
    /**\
     * @return the token being held.\
     */\
    function token() public view returns (IERC20) \{\
        return _token;\
    \}\
\
    /**\
     * @return the beneficiary of the tokens.\
     */\
    function beneficiary() public view returns (address) \{\
        return _beneficiary;\
    \}\
\
    /**\
     * @return the time when the tokens are released.\
     */\
    function releaseTime() public view returns (uint256) \{\
        return _releaseTime;\
    \}\
    \
    /**\
     * @return this contract balance\
     */\
    function balance() public view returns (uint256) \{\
        return _token.balanceOf(address(this));\
    \}\
\
    /**\
     * @notice Transfers tokens held by timelock to beneficiary.\
     */\
    function release() public \{\
        // solhint-disable-next-line not-rely-on-time\
        require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");\
\
        uint256 amount = _token.balanceOf(address(this));\
        require(amount > 0, "TokenTimelock: no tokens to release");\
\
        _token.transfer(_beneficiary, amount);\
    \}\
\}\
}