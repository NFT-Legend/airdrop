pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

import "./lib/ERC20.sol";

contract NGC is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _maxSupply
    ) ERC20(_name, _symbol, _decimals, _maxSupply) {}
}
