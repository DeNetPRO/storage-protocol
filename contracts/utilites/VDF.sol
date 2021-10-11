// SPDX-License-Identifier: MIT

/*
    Created by DeNet

    VDF working with numbers less than UINT64 only.

    ToDo:
        add restore mode
            input
                - array of uint64 in n-1 step vdf
            output
                - array of uint64 in 1 step vdf
        
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract VDF {
    using SafeMath for uint;
    
    uint constant public mod_r = 18446743242781407235;

    
    function powModulo(uint n) internal returns(uint) {
        if (n >= mod_r) return n;
        return n.mul(n).mod(mod_r).mul(n).mod(mod_r);
    }

    function restore(bytes calldata data) public view returns(bytes calldata) {
        return data;
    }
}