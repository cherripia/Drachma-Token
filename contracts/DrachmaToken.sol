// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

contract DrachmaToken is ERC20, ERC20Burnable, Ownable {

    using SafeMath for uint256;

    mapping(address => bool) private _excludeFromFees;

    address private _charityWallet = address(0x0D75c77DF0De81399C921B65262d9Ed4b23D1236);
    address private _burnWallet = address(0xF4113a6e003061Ae82D0c12Cb948C5cfcb3aE987);

    uint256 _developerFee = 2; // Percentage of trades on exchanges to developer wallets.
    uint256 _liquidityFee = 1; // Liquidity Fee 
    uint256 _charityFee = 2;
    uint256 _burnFee = 2;

    constructor(uint256 _supply) ERC20("Drachma", "DRC") {
        _mint(_msgSender(), _supply * (10 ** decimals()));
        _excludeFromFees[_msgSender()] = true;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if ((_excludeFromFees[_msgSender()]) || (_excludeFromFees[recipient])) {
            _transfer(_msgSender(), recipient, amount);
        } else {

            
            // Burn 2% to charity wallet.
            uint256 charityAmount = amount.mul(_charityFee).div(100);
            _transfer(_msgSender(), _charityWallet, amount.sub(charityAmount));
            

            // Burn 2% on all transactions.
            uint256 burnAmount = amount.mul(_burnFee).div(100);
            //_burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), _burnWallet, amount.sub(burnAmount));

            _transfer(_msgSender(), recipient, amount.sub(burnAmount));
        }
        return true;
    }

    receive() external payable {}
}