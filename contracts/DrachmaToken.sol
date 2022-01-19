// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DrachmaToken is ERC20, ERC20Burnable{

    constructor(uint256 _supply) ERC20("Drachma", "DRC") {
        _mint(msg.sender, _supply * (10 ** decimals()));
    }

}