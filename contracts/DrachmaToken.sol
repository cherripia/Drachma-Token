// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Dream Scenario;
// Burn Fee: 2% (Every transaction)
// Charity Fee: 2% ETH (Every exchange transaction; Only ETH.)
// Liquidity Fee: 1% ETH (Every exchange transaction. Only ETH. Add to liquidity.)

contract DrachmaToken is ERC20, ERC20Burnable, Ownable{

    using SafeMath for uint256;

    mapping(address => bool) private _excludeFromFees;
    uint256 CharityFee = 2; // Percentage of transactions moved to charity wallet.
    uint256 BurnFee = 2; // Percentage of transactions removed every transaction.

    constructor(uint256 _supply) ERC20("Drachma", "DRC") {
        _mint(msg.sender, _supply * (10 ** decimals()));
        _excludeFromFees[msg.sender] = true;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if (_excludeFromFees[_msgSender()]) {
            _transfer(_msgSender(), recipient, amount);
        } else {

            // Burn 2% on ALL transactions.
            uint256 burnAmount = amount.mul(BurnFee).div(100);
            _burn(_msgSender(), burnAmount);

            _transfer(_msgSender(), recipient, amount.sub(burnAmount));
        }
        return true;
    }

    receive() external payable {}
}