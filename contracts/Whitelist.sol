pragma solidity ^0.8.0;
pragma abicoder v2;

// SPDX-License-Identifier: MIT

import "./include/IWhitelist.sol";
import "./lib/ContractOwner.sol";

contract Whitelist is ContractOwner, IWhitelist {
    mapping(address => uint256) whitelist;

    address public mainAddr;

    function add(address[] calldata list) external OwnerOnly {
        for (uint256 i = 0; i != list.length; i++) {
            whitelist[list[i]] = 1;
        }
    }

    function setMainAddr(address addr) external OwnerOnly {
        require(addr != address(0), "addr zero address");
        mainAddr = addr;
    }

    function checkAddress(address target) external view override returns (bool) {
        uint256 v = whitelist[target];
        return v == 1;
    }

    function withdraw(address target) external override returns (bool) {
        require(msg.sender == mainAddr, "only allow main contract");
        whitelist[target] = 2;
        return true;
    }
}
