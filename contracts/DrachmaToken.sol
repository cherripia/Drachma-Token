// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DrachmaToken is ERC20, ERC20Burnable, Ownable{

    using SafeMath for uint256;

    mapping(address => bool) private _excludeFromFees;
    uint256 CharityFee = 2; // Percentage of transactions given to charity wallet.

    constructor(uint256 _supply) ERC20("Drachma", "DRC") {
        _mint(msg.sender, _supply * (10 ** decimals()));
        _excludeFromFees[msg.sender] = true;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if (_excludeFromFees[_msgSender()]) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint256 charityAmount = amount.mul(CharityFee).div(100);
            _burn(_msgSender(), charityAmount);
            _transfer(_msgSender(), recipient, amount.sub(charityAmount));
        }
        return true;
    }

}