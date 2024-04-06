// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

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
 *  https://www.geeksforgeeks.org/solidity-comments/
 */

contract DinoToken is IERC20, Ownable {
    /**
     * @dev Init Arguments
     */
    string public name = "DinoToken";
    string public symbol = "DINO";
    uint8 public decimals = 18;
    uint256 _totalSupply = 65000000;

    /**
     * @dev Init Mapping
     */
    mapping(address => uint256) _balanceOf;
    mapping(address => mapping(address => uint256)) _allowances;

    /**
     * @dev Init Event
     */

    /**
     * @param from Address that Tokens will be collected from
     * @param to  Address that Tokens will be gived to
     * @param value Value of Tokens will be transfer from "From" to "To"
     */
    event Transform(address indexed from, address indexed to, uint256 value);

    /**
     * @param owner owner is the address who gave spender to use it's Tokens
     * @param spender spender then can transfer money from owner to other address
     * @param value value is amount of Token allow by onwer to give spender abillity to control
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @notice if the player complete game, the palyer can get some tokens
     * @param player address of player
     * @param value tokens player will get
     */
    event Reward(address indexed player, uint256 value);

    /**
     * @dev owner set to who create this contract
     * @notice all Tokens will be transfer to contract itself, not owner
     */
    constructor() Ownable(msg.sender) {
        _balanceOf[address(this)] = _totalSupply;
    }

    /**
     *  @dev Private Function
     */
    /**
     * @dev transfer certain amount of token from "from" address to "to" address
     * @param from address that will send out token
     * @param to address that "from" address will transfer money to
     * @param value how many Tokens transfer to "To" address
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(_balanceOf[from] >= value, "Insufficient balance");
        _balanceOf[from] -= value;
        _balanceOf[to] += value;
    }

    /**
     * @param owner owner is the address who gave spender to use it's Tokens
     * @param spender spender then can transfer money from owner to other address
     * @param value value is amount of Tokens allow by onwer to give spender abillity to control
     * @param emitEvent will emit event Approval if true
     */
    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal {
        if (owner == address(0)) {
            revert("ERC20: approve from the zero address");
        }

        if (spender == address(0)) {
            revert("ERC20: approve from the zero address");
        }

        _allowances[owner][spender] = value;

        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev return how many Tokens an owner allow a spender to use
     * @param owner who give allowance to spender, so that spender can use certain amount of tokens
     * @param spender who are allowed to use certain amount of tokens an owner have
     * @return uint256 how many Tokens an owner allow a spender to use
     */
    function _allowance(
        address owner,
        address spender
    ) internal view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev add substract value from allowance, this function won't trigger transaction, need to call after transaction
     * @param owner who give allowance to spender, so that spender can use certain amount of token
     * @param spender who are allowed to use certain amount of token an owner have
     * @param value amount of tokens need to be substract from allowance
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal {
        uint256 currentAllowance = _allowances[owner][spender];
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert("transaction exist allowance");
            }

            // 0.8.0以上每次都會檢查是否溢出，我們可以把他用unchecked跳過, 並省錢
            unchecked {
                _approve(owner, spender, currentAllowance - value, true);
            }
        }
    }

    /**
     *  @dev ERC20 Function
     */

    /**
     * @return Return total amounts of Tokens
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @notice Check how many Tokens an account have
     * @param account address you whan to know how many Token does it have
     * @return uint256 total Tokens an account have
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balanceOf[account];
    }

    /**
     * @param to address that msg.sender will transfer money to
     * @param value how many Tokens transfer to "To" address
     * @return bool true if transaction success
     */
    function transfer(
        address to,
        uint256 value
    ) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev return how many Tokens an owner allow a spender to use
     * @param owner who give allowance to spender, so that spender can use certain amount of tokens
     * @param spender who are allowed to use certain amount of tokens an owner have
     * @return uint256 how many Tokens an owner allow a spender to use
     */
    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowance(owner, spender);
    }

    /**
     * @notice You can allow an spender to transfer certain amount of Tokens for you(won't transfer in this function)
     * @param spender who are allowed to use certain amount of tokens that you have
     * @param value how many tokens you want to transfer
     * @return boolean true if success
     */
    function approve(
        address spender,
        uint256 value
    ) external override returns (bool) {
        _approve(msg.sender, spender, value, true);
        return true;
    }

    /**
     * @notice if you get allowance from somebody, use this function to transfer their money to other account
     * @param from the owner give you allowance
     * @param to the destiny of tokens you decide to transfer to
     * @param value certain amount of tokens you want to transfer
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        _spendAllowance(from, msg.sender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @notice only can execute by contract owner
     * @param player winner that can get some token from this contract
     * @param value amount of Tokens player can get from this contract as reward
     */
    function rewardPlayer(address player, uint256 value) public onlyOwner {
        require(
            _balanceOf[address(this)] >= value,
            "Not enough tokens in contract for reward"
        );
        _transfer(address(this), player, value);
        emit Reward(player, value);
    }
}
