// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity 0.8.9;

interface IProofOfStorage {

    /*
        @dev Returns true/false of rooth hash contains in _proof via sha256

        INPUT
            @_root_hash - root hash of merkleTree
            @_proof - Merkletree array
        OUTPUT
            @result (bool) - is valid merkletree proof
    */
    function isValidMerkleTreeProof(
        bytes32 _root_hash,
        bytes32[] calldata _proof
    ) external view returns (bool);

    /*
        Matching diffuclty, where _targetDifficulty = some growing number, 
        for example _targetDiffuculty = seconds from last proof for selected user
        
        _proof = sha256 of something
        _targetDiffuculty = seconds from last proof 
        base_difficult
        
    */
    function isMatchDifficulty(uint256 _proof, uint256 _targetDifficulty)
        external
        view
        returns (bool);

    /*
        @dev Returns info about user reward for ProofOfStorage

        INPUT
            @_user - User Address
            @_user_storage_size - User Storage Size

        OUTPUT
            @_amount - Total Token Amount for PoS
            @_last_rroof_time - Last Proof Time
    */


    function getUserRewardInfo(address _user, uint _user_storage_size)
        external
        view
        returns (
            uint,
            uint
        );
    
    /*
        @dev Returns last user root hash and nonce.

        INPUT
            @_user - User Address
        
        OUTPUT
            @_hash - Last user root hash
            @_nonce - Noce of root hash
    */
    function getUserRootHash(address _user)
        external
        view
        returns (bytes32, uint);
    

}
