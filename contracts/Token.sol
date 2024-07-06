// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(address user, uint amount) public returns (uint) {
        require(amount > 0, "Amount must be greater than 0");
        _mint(user, amount);
        // _safeTransfer(msg.sender, user, amount);
        // emit Transfer(address(0), user, amount);
        return amount;
    }
}
