// SPDX-License-Identifier: MIT

/*
    Created by DeNet

    Proof Of Storage  - Consensus for Decentralized Storage.
*/

pragma solidity ^0.8.9;
pragma abicoder v1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "./interfaces/IUserStorage.sol";
import "./interfaces/IPayments.sol";
import "./interfaces/IOldPayments.sol";
import "./interfaces/INodeNFT.sol";


// TODO: sha256 => keccak256
contract CryptoProofs {
    event WrongError(bytes32 wrong_hash);

    /*
        Proof period < 1D, base_difficulty++
        Proof period > 1D, base_difficulty--

        Using for 'randomly" proof verification.
    */
    uint256 public base_difficulty;

    constructor(uint256 _baseDifficulty) {
        base_difficulty = _baseDifficulty;
    }

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
    function isMatchDifficulty(uint256 _proof, uint256 _targetDifficulty)
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

    function getDifficulty() public view returns(uint256) {
        return base_difficulty;
    }
}

contract Depositable {
    using SafeMath for uint;

    address public paymentsAddress;
    uint256 public maxDepositPerUser = 100000000; // 100 USDC
    uint256 public timeLimit = 604800; // 7 days
    
    mapping(address => mapping(uint32 => uint256)) public limitReached; // time 

    constructor (address _payments) {
        paymentsAddress = _payments;
    }

    function getAvailableDeposit(address _user, uint256 _amount, uint32 _curDate) public view returns (uint256) {
        if (limitReached[_user][_curDate] + _amount >=maxDepositPerUser) {
            return maxDepositPerUser.sub(limitReached[_user][_curDate]);
        }
        return _amount;
    }

    function makeDeposit(address _token, uint256 _amount) public {

        /* Checking Limits */
        uint32 curDate = uint32(block.timestamp.div(timeLimit));
        _amount = getAvailableDeposit(msg.sender, _amount, curDate);
        require(_amount > 0, "Reached deposit limit for this period");

        limitReached[msg.sender][curDate] = limitReached[msg.sender][curDate].add(_amount);
        IPayments _payment = IPayments(paymentsAddress);
        _payment.depositToLocal(msg.sender, _token, _amount);
    }

    function closeDeposit(address _token) public {
        IPayments _payment = IPayments(paymentsAddress);
        _payment.closeDeposit(msg.sender, _token);
    }
}



contract ProofOfStorage is Ownable, CryptoProofs, Depositable {
    using SafeMath for uint;


    /*
        Address of smart contract, where User Storage placed
    */
    address public user_storage_address;
   
    /*
        Address of smart contract, where NFT of nodes placed
    */
    address public node_nft_address = address(0);
    
    /*
        Max blocks after proof needs to use newest proof as it possible
        For other netowrks it will be:

        Expanse ~ 1.5H
        Ethereum ~ 54 min
        Optimistic ~ 54 min
        Ethereum Classic ~ 54 min
        POA Netowrk ~ 20 min
        Kovan Testnet ~ 16 min
        BinanceSmart Chain ~ 12.5 min
        Polygon ~ 8 min
        Avalanche ~ 8 min
    */
    uint256 private _max_blocks_after_proof = 250;
    
    /*
        Debug mode using only for test's. 
        Check it parametr before any deposits!
        
        What is using for, when it true:
            - Disabling verification of User Signature 
    */
    bool public debug_mode = false;

    /*
        Minimal sotrage size for proof. 

        in Polygon netowrk best min storage size ~10GB (~0.03 USD or more per month).
        if user store less than 10GB, user storage size will increased to min_storage_require
        
    */
    uint public min_storage_require = 10240;

    /*
        Old payments support from v0.3.0
    */
    bool public isOldPayments = true;
    
    /*
        REWARD_DIFFICULTY
        This Parametr using to get amount of reward per one mined block.

        Formula (60 * 60 * 24 * 365) / AvBlockTime

        For Ethereum - 2102400
        For Matic - 15768000
        For BSC - 6307200

        This parametr is depricated, because we updated proof system.
        Now it based on storage time.
    */
    constructor(
        address _storage_address,
        address _payments,
        uint256 _baseDifficulty
    ) CryptoProofs(_baseDifficulty) Depositable(_payments) {
        user_storage_address = _storage_address;
    }

    /*
        Owner Zone Start
    */

    function changePaymentsVersion() public onlyOwner {
        isOldPayments = !isOldPayments;
    }

    function setNodeNFTAddress(address _new) public onlyOwner {
        node_nft_address = _new;
    }

    function _updateNodeRank(address _proofer, uint current_difficulty) internal returns(uint256) { 
        if (node_nft_address != address(0)) {
            IDeNetNodeNFT NFT = IDeNetNodeNFT(node_nft_address);
            uint timeFromLastProof = block.timestamp - NFT.getLastUpdateByAddress(_proofer);
            
            NFT.addSuccessProof(_proofer);
           
            if (timeFromLastProof <= 86400) {
                /* 
                    100% = 4320000
                    2% = 86400 (1 day)

                    Difficulty += 0-2% per proof if it faster than one day
                */
                return current_difficulty.mul(4320000 + (86400 - timeFromLastProof)).div(4320000);
            } else {
                /* 
                    100% = 8640000
                    1% = 86400
                    difficulty -= 0-1% (pseudo randomly) per proof if it slower than one day
                */
                timeFromLastProof = timeFromLastProof % 86400;
                return current_difficulty.mul(8640000 - (86400 - timeFromLastProof)).div(8640000);
            }

            
        }
        return current_difficulty;
    }

    /*
        Function to disable user signature checking.
    */
    function turnDebugMode() public onlyOwner {
        if (debug_mode) debug_mode = false;
        else debug_mode = true;
    }

    /*
        ToDO:
            - Move it into documentation
        
        Increase, if network fees growing
        Decreese, if network fees down

        For example:
            MATIC:
                Matic price: 2$
                Avg gas price: 30 GWEI
                Avg proof gasused: 300,000
                Avg tx cost: 30 x 300,000  = 0,009 MATIC 
                Avg tx price: 0.009 MATIC x 2$ = 0.018$
                1TB/year Price ~30$
                Max period for proof: 30 days. (~2.5$ / TB / Month)
                Min storage size = 0.018 / 2.5$ = 0.0072 TB
            Ethereum:
                Matic price: 4000$
                Avg gas price: 100 GWEI
                Avg proof gasused: 300,000
                Avg tx cost: 100 x 300,000  = 0,03 ETH 
                Avg tx price: 0.03 ETH x 4000$ = 120$
                1TB/year Price ~30$
                Max period for proof: 30 days. (~2.5$ / TB / Month)
                Min storage size = 120 / 2.5$ = 48 TB
            Binance Smart Chain:
                BNB price: 500$
                Avg gas price: 5 GWEI
                Avg proof gasused: 300,000
                Avg tx cost: 5 x 300,000  = 0.0014 BNB 
                Avg tx price: 0.0014 BNB x 500$ = 0.7$
                1TB/year Price ~30$
                Max period for proof: 30 days. (~2.5$ / TB / Month)
                Min storage size = 0.7 / 2.5$ = 0.27 TB
    */
    function setMinStorage(uint _size) public onlyOwner {
        min_storage_require = _size;
    }

    /*
        More base_difficulty = more random for nodes.
    */
    function updateBaseDifficulty(uint256 _new_difficulty) public onlyOwner {
        base_difficulty = _new_difficulty;
    }

    /*
        Function to invisible mint TB/Year for some user;
        will removed after audits and final tests.
    */
    function invisibleMintGasToken(address _from, address _user,  uint256 _amount) public onlyOwner {
        IPayments _payment = IPayments(paymentsAddress);
        _payment.localTransferFrom(_from, _user, _amount);
    }

    /*
        Update Storage Address or Payments Address for something updates
    */
    function changeSystemAddresses(
        address _storage_address,
        address _payments_address
    ) public onlyOwner {
        user_storage_address = _storage_address;
        paymentsAddress = _payments_address;
    }

    /*
        Owner Zone End
    */

    /*
        Send proof use sendProofFrom with msg.sender address as node
    */
    function sendProof(
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
        uint64 _user_storage_size,
        uint64 _user_root_hash_nonce,
        bytes calldata _user_signature,
        bytes calldata _file,
        bytes32[] calldata merkleProof
    ) public {
        sendProofFrom(
            msg.sender,
            _user_address,
            _block_number,
            _user_root_hash,
            _user_storage_size,
            _user_root_hash_nonce,
            _user_signature,
            _file,
            merkleProof
        );
    }

    /*
        Send Proof From - proof of storage mechanism, that look like TransferFrom
        but in case transferFrom, user creating approve transactions. in PoS you don't need to do it.

        _node_address - Who will recieve reward in success case
        _user_address - Who is payer
        _block_number - Block number, to approve tx with newest data (see _max_blocks_after_proof)
        _user_root_hash - root hash, signed by payer
        _user_storage_size - Storage size in MB. or files count (because all files size 1 MB)
        _user_root_hash_nonce - parametr to proof, that is newest data proof
        _user_signature - approve, that root hash, storage size and nonce is correct.
        _file - part of file
        _merkleProof - proof start from part of file, and edns with user_root_hash
    */
    function sendProofFrom(
        address _node_address,
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
        uint64 _user_storage_size,
        uint64 _user_root_hash_nonce,
        bytes calldata _user_signature,
        bytes calldata _file,
        bytes32[] calldata merkleProof
    ) public {
        /* Skip for test only */
        if (!debug_mode) {

            address signer = ECDSA.recover(
                sha256(abi.encodePacked(
                    _user_root_hash,
                    uint256(_user_storage_size),
                    uint256(_user_root_hash_nonce)
                )),
                _user_signature
            );
            require(_user_address == signer, "User address not signer");
        }

        /*
            _amount_returns = amount of TB/Year token

            if something wrong, transaction will rejected
        */
        uint256 _amount_returns = _sendProofFrom (
            _node_address,
            _user_address,
            _block_number,
            _user_root_hash,
            _user_storage_size,
            _user_root_hash_nonce,
            _file,
            merkleProof
        );

        /*
            Transfer deposit from user to node
        */
        _takePay(_user_address, _node_address, _amount_returns);

        /*
            Set last proof time to current timestamp.
            Same like moving user difficulty to zero.
        */
        _updateLastProofTime(_user_address);

        /*
            +1 To Node Success proofs, also return new difficulty for all nodes (+- 2%)
        */
        base_difficulty = _updateNodeRank(_node_address, base_difficulty);
    }

    /*
        Update Root Hash for user.

        _user - target user
        _updater - address of node or user, who update root_hash
        _new_hash - new root hash
        _new_storage_size 
        _new_nonce
    */
    function _updateRootHash(
        address _user,
        address _updater,
        bytes32 _new_hash,
        uint64 _new_storage_size,
        uint64 _new_nonce
    ) private {
        bytes32 _cur_user_root_hash;
        uint256 _cur_user_root_hash_nonce;
        (_cur_user_root_hash, _cur_user_root_hash_nonce) = getUserRootHash(_user);

        require(_new_nonce >= _cur_user_root_hash_nonce, "Too old root hash");

        // update root hash if it needed
        if (_new_hash != _cur_user_root_hash) {
            _updateLastRootHash(_user, _new_hash, _new_storage_size, _new_nonce, _updater);
        }
    }

    /*
        Proof Verification
        _sender - node
        _file
        _block_number 
        _time_passed - time from last proof to now
    */
    function verifyFileProof(
        address _sender,
        bytes calldata _file,
        uint32 _block_number,
        uint256 _time_passed
    ) public view returns (bool) {
        /*
            If some blockchain habe limits to blocks
            for example, ethereum shows last 256 blockhashes from now
        */
        require (blockhash(_block_number) != 0x0, "Wrong blockhash");

        /*
            make _file_proof with hash from _file + _node_address + blockhash
        */
        bytes32 _file_proof = sha256(
            abi.encodePacked(_file, _sender, blockhash(_block_number))
        );

        /*
            Verify with difficulty, (more in isMatchDifficulty)
        */
        return isMatchDifficulty(uint256(_file_proof), _time_passed);
    }    

    function _sendProofFrom(
        address _proofer,
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
        uint64 _user_storage_size,
        uint64 _user_root_hash_nonce,
        bytes calldata _file,
        bytes32[] calldata merkleProof
    ) private returns(uint256) {
        // not need, with using signature checking
        require(
            _proofer != address(0) && _user_address != address(0),
            "address can't be zero"
        );

        // warning test function without checking  DigitalSIgnature from User SEnding File
        _updateRootHash(
            _user_address,
            _proofer,
            _user_root_hash,
            _user_storage_size,
            _user_root_hash_nonce
        );
        
        bytes32 _file_hash = sha256(_file);
        (
            uint256 _amount_returns,
            uint256 _blocks_complited
        ) = getUserRewardInfo(_user_address, _user_storage_size);

        require(
            _block_number > block.number - _max_blocks_after_proof,
            "Too old proof"
        );
        require(
            isValidMerkleTreeProof(_user_root_hash, merkleProof),
            "Wrong merkleProof"
        );
        require(
            verifyFileProof(
                _proofer,
                _file,
                _block_number,
                _blocks_complited
            ),
            "Not match difficulty"
        );
        require(
            _file_hash == merkleProof[0] || _file_hash == merkleProof[1],
            "not found _file_hash in merkleProof"
        );

        return (_amount_returns);
    }

    /*
        @dev Returns info about user reward for ProofOfStorage

        # Input
            @_user - User Address
            @_user_storage_size - User Storage Size

        # Output
            @_amount - Total Token Amount for PoS
            @_last_rroof_time - Last Proof Time
    */
    function getUserRewardInfo(address _user, uint _user_storage_size)
        public
        view
        returns (
            uint,
            uint
        )
    {
        require(_user_storage_size != 0, "storage size is zero");
        
        
        /*
            IPayments _payment = IPayments(paymentsAddress);

            Depricated, because, now it using only for storage data
        */

        IUserStorage _storage = IUserStorage(user_storage_address);
        
        uint _timePassed = _storage.getPeriodFromLastProof(_user);
        
        /*
            Increase user storage size to min_storage_require (10 GB) if it less
        */
        if (_user_storage_size < min_storage_require) {
            _user_storage_size = min_storage_require;
        }

        /*
            Set timePassed to 30 days, if it more
        */
        if (_timePassed > 2592000) {
            _timePassed = 2592000;
        }
        
        /*
            TODO: Move it into documentation 

            10e18 - decimals for TB/Year
            31536000 - one year in seconds
            storage size - in megabytes
            1048576 = 1024 x 1024 
            
            Simple:
                amount = timePassed x storage size / one year
            
            True:
                                timePassed x storage size 
                amount = 0e18 x __________________________
                                    31536000 x 1048576
        */
        uint _amountReturns = uint(10e18).div(31536000).mul(_timePassed).mul(_user_storage_size).div(1048576);

        return (_amountReturns, _timePassed);
    }

    /*
        Function move part of deposit  _from to _to
    */
    function _takePay(
        address _from,
        address _to,
        uint _amount
    ) private {
        if (isOldPayments) {
            IOldPayments _payment = IOldPayments(paymentsAddress);
            _payment.localTransferFrom(address(0), _from, _to, _amount);
        } else {
            IPayments _payment = IPayments(paymentsAddress);
            _payment.localTransferFrom(_from, _to, _amount);
        }
    }

    /*
        Returns User Root Hash
    */
    function getUserRootHash(address _user)
        public
        view
        returns (bytes32, uint)
    {
        IUserStorage _storage = IUserStorage(user_storage_address);
        return _storage.getUserRootHash(_user);
    }

    /*
        Set last proof time to current timestamp.
    */
    function _updateLastProofTime(address _user_address)
        private
    {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.updateLastProofTime(_user_address);
    }

    /*
        Set root hash, user_storage size and nonce
    */
    function _updateLastRootHash(
        address _user_address,
        bytes32 _user_root_hash,
        uint64 _user_storage_size,
        uint64 _nonce,
        address _updater
    ) private {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.updateRootHash(
            _user_address,
            _user_root_hash,
            _user_storage_size,
            _nonce,
            _updater
        );
    }
}