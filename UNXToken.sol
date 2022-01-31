pragma solidity ^0.5.0;

import "./TRC20.sol";
import "./TRC20Detailed.sol";

contract UNXToken is TRC20 {
    constructor () public TRC20Detailed(msg.sender,"UNION FINEX", "UNX", 8) {
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }
}
