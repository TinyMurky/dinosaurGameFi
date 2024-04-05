// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";
import "./IERC20.sol";

/**
 * @dev Ref:
 *  https://semaphoreci.com/blog/erc20-token-hardhat
 *  https://docs.openzeppelin.com/upgrades-plugins/1.x/hardhat-upgrades
 *  https://docs.openzeppelin.com/contracts/4.x/erc20
 *  https://solidity-by-example.org/app/erc20/
 *  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol#L87
 *  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
 */

contract DinoToken is IERC20, Ownable {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    string public name = "DinoToken";
    string public symbol = "DINO";
    uint8 public decimals = 18;
    uint256 _totalSupply = 65000000;
    mapping(address => uint256) _balanceOf;
    mapping(address => mapping(address => uint256)) _allowance;

    // Init I have all the tokens
    constructor() Ownable(msg.sender) {
        _balanceOf[msg.sender] = _totalSupply;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balanceOf[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {}

    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {}

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {}
}
