pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

import "./include/IERC20.sol";
import "./include/IWhitelist.sol";
import "./lib/ContractOwner.sol";

contract Airdrop is ContractOwner {
    IERC20 public token;
    IWhitelist public whitelist;

    uint256 public perAddress;
    uint256 public startTime;
    uint256 public endTime;

    event Withdraw(address indexed from, uint256 value, bool status);

    function setAddress(address _token, address _whitelist) external OwnerOnly {
        require(_token != address(0), "_token zero address");
        require(_whitelist != address(0), "_whitelist zero address");
        token = IERC20(_token);
        whitelist = IWhitelist(_whitelist);
    }

    function setParas(
        uint256 _perAddress,
        uint256 _startTime,
        uint256 _endTime
    ) external OwnerOnly {
        require(_startTime < _endTime, "_endTime is less than _startTime");
        require(_perAddress > 0, "_perAddress must be greater than 0");
        startTime = _startTime;
        endTime = _endTime;
        perAddress = _perAddress;
    }

    function withdraw() external {
        require(address(token) != address(0), "token zero address");
        require(address(whitelist) != address(0), "whitelist zero address");
        require(whitelist.checkAddress(msg.sender), "You have already withdraw it");
        uint256 _now = block.timestamp;
        require(_now > startTime && _now <= endTime, "It's not the time to pick up or it has expired");

        bool status = whitelist.withdraw(msg.sender);
        if (status) {
            status = token.transfer(msg.sender, perAddress);
            emit Withdraw(msg.sender, perAddress, status);
        }
    }
}
