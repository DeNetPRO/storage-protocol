// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


library BaseMath {
    /**
        @dev Returns the max of two.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a > b) return a;
        return b;
    }
    /**
        @dev Returns the min of two.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a > b) return b;
        return a;
    }
}