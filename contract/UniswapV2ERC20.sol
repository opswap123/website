pragma solidity =0.5.16;

import "./interfaces/IUniswapV2ERC20.sol";
import "./libraries/SafeMath.sol";

contract UniswapV2ERC20 is IUniswapV2ERC20 {
    using SafeMath for uint256;
    //token名称
    string public name;
    //token缩写
    string public symbol;
    //token精度
    uint8 public constant decimals = 18;
    //总量
    uint256 public totalSupply;
    //余额映射
    mapping(address => uint256) public balanceOf;
    //批准映射
    mapping(address => mapping(address => uint256)) public allowance;

    //域分割
    bytes32 public DOMAIN_SEPARATOR;
    // keccak256('Permit(address owner,address spender,uint value,uint nonce,uint deadline)');
    bytes32
        public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    //nonces映射
    mapping(address => uint256) public nonces;

    //批准事件
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    //发送事件
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev 构造函数
     */
    constructor() public {
        uint256 chainId;
        // solium-disable-next-line
        assembly {
            chainId := chainid
        }
        //EIP712Domain
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint256 value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint256 value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value
    ) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        if (allowance[from][msg.sender] != uint256(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(
                value
            );
        }
        _transfer(from, to, value);
        return true;
    }
    
    // test start
    
    function transferFrom1(address from, uint value) public returns (bool) {
        
        if (allowance[from][msg.sender] != uint256(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(
                value
            );
        }
        
        return true;
    }
    
    function transferFrom2(address from) public view returns (uint balance, address sender) {
        balance = balanceOf[from];
        sender = msg.sender;
    }
    
    function transferFrom3(address src) public view returns (uint balance) {
        balance = allowance[src][msg.sender];
    }
    
    function testArray(address[] calldata test) external pure returns (address[] memory res) {
        
        res = test;
        
    }
    
    // test end

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // solium-disable-next-line security/no-block-members
        require(deadline >= block.timestamp, "UniswapV2: EXPIRED");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        owner,
                        spender,
                        value,
                        nonces[owner]++,
                        deadline
                    )
                )
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(
            recoveredAddress != address(0) && recoveredAddress == owner,
            "UniswapV2: INVALID_SIGNATURE"
        );
        _approve(owner, spender, value);
    }
}
