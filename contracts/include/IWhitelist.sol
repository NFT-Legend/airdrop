pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

interface IWhitelist {
    function checkAddress(address target) external returns (bool);

    function withdraw(address target) external returns (bool);
}
