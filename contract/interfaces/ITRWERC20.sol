pragma solidity ^0.5.6;

interface ITRWERC20 {
    function totalSupply() external returns (uint supply);
    function balanceOf( address who ) external returns (uint value);
    function allowance( address owner, address spender ) external returns (uint _allowance);

    function transfer( address to, uint value) external returns (bool ok);
    function transferFrom( address from, address to, uint value) external returns (bool ok);
    function approve( address spender, uint value ) external returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}