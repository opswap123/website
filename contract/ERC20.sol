pragma solidity =0.5.16;

import './UniswapV2ERC20.sol';

contract ERC20 is UniswapV2ERC20 {
    constructor(string memory _name, string memory _symbol, uint _totalSupply) public {
        name = _name;
        symbol = _symbol;
        _mint(msg.sender, _totalSupply * 10 ** uint256(decimals));
    }
}