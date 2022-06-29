pragma solidity ^0.8.0;

interface IDifficultyManufacturing {
    event UpdateDifficulty(
        uint _new_difficulty
    );
}

contract DifficultyManufacturing is IDifficultyManufacturing{
    /**
        @dev Proof period < 1D, base_difficulty++
        Proof period > 1D, base_difficulty--

        Using for 'randomly" proof verification.

        1,000,000 is start value for difficulty 
    */
    uint256 private base_difficulty = 1000000;
    uint256 private upgradingDifficulty = base_difficulty;

    function setDifficulty(uint _new_difficulty) internal {
        // min difficulty = 10000
        if (_new_difficulty < 10000) {
            _new_difficulty = 10000;
        }

        upgradingDifficulty = _new_difficulty;
        uint change_size = base_difficulty * 10200 / upgradingDifficulty;
        
        // if difficulty changed more than 2%, update it
        if (change_size > 10200 || change_size <  9800 ) {
            base_difficulty = upgradingDifficulty;
            emit UpdateDifficulty(base_difficulty);
        }
    }

    function getDifficulty() public view returns(uint){
        return base_difficulty;
    }

    function getUpgradingDifficulty() public view returns(uint) {
        return upgradingDifficulty;
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