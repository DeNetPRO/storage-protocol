pragma solidity ^0.8.0;

contract DifficultyManufacturing {
    /*
        Proof period < 1D, base_difficulty++
        Proof period > 1D, base_difficulty--

        Using for 'randomly" proof verification.

        10,000,000 is start value for difficulty 
    */
    uint256 private base_difficulty = 10000000;

    function setDifficulty(uint _new_difficulty) internal {
        base_difficulty = _new_difficulty;
    }

    function getDifficulty() public view returns(uint){
        return base_difficulty;
    }
}

contract CryptoProofs is DifficultyManufacturing {
    event WrongError(bytes32 wrong_hash);

    // TODO: transform merkle proof verification to efficient as OZ
    function isValidMerkleTreeProof(
        bytes32 _root_hash,
        bytes32[] calldata proof
    ) public pure returns (bool) {
        bytes32 next_proof = 0;
        for (uint32 i = 0; i < proof.length / 2; i++) {
            next_proof = sha256(
                abi.encodePacked(proof[i * 2], proof[i * 2 + 1])
            );
            if (proof.length - 1 > i * 2 + 3) {
                if (
                    proof[i * 2 + 2] == next_proof &&
                    proof[i * 2 + 3] == next_proof
                ) {
                    return false;
                }
            } else if (proof.length - 1 > i * 2 + 2) {
                if (proof[i * 2 + 2] != next_proof) {
                    return false;
                }
            }
        }
        return _root_hash == next_proof;
    }

    /*
        Matching diffuclty, where _targetDifficulty = some growing number, 
        for example _targetDiffuculty = seconds from last proof for selected user
        
        _proof = sha256 of something
        _targetDiffuculty = seconds from last proof 
        base_difficult
        
    */
    function isMatchDifficulty(uint base_difficulty, uint256 _proof, uint256 _targetDifficulty)
        public
        view
        returns (bool)
    {
        if (_proof % base_difficulty < _targetDifficulty) {
            return true;
        }
        return false;
    }

    function getBlockNumber() public view returns (uint32) {
        return uint32(block.number);
    }

     // Show Proof for Test
    function getProof(bytes calldata _file, address _sender, uint256 _block_number) public view returns(bytes memory, bytes32) {
        bytes memory _packed = abi.encodePacked(_file, _sender, blockhash(_block_number));
        bytes32 _proof = sha256(_packed);
        return (_packed, _proof);
    }

    function getBlockHash(uint32 _n) public view returns (bytes32) {
        return blockhash(_n);
    }
}