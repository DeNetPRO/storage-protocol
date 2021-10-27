// SPDX-License-Identifier: MIT

/*
    Created by DeNet

    Proof Of Storage  - Consensus for Decentralized Storage.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "./interfaces/IUserStorage.sol";
import "./interfaces/IPayments.sol";
import "./interfaces/INodeNFT.sol";


// TODO: sha256 => keccak256
contract CryptoProofs {
    event WrongError(bytes32 wrong_hash);

    uint256 public base_difficulty;

    constructor(uint256 _baseDifficulty) {
        base_difficulty = _baseDifficulty;
    }

    function isValidSign(
        address _signer,
        bytes memory message,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (signature.length == 65) {
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
        } else if (signature.length == 64) {
            assembly {
                let vs := mload(add(signature, 0x40))
                r := mload(add(signature, 0x20))
                s := and(
                    vs,
                    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                )
                v := add(shr(255, vs), 27)
            }
        } else {
            revert("ECDSA: invalid signature length");
        }

        return _signer == ecrecover(sha256(message), v, r, s);
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
    uint256 public maxDepositPerUser = 1000000; // 1 USDC
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
        uint32 curDate = uint32(block.timestamp % timeLimit);
        _amount = getAvailableDeposit(msg.sender, _amount, curDate);
        require(_amount > 0, "Amout exceeded for this week");

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

    address public user_storage_address;
    uint256 private _max_blocks_after_proof = 100;
    address public node_nft_address = address(0);
    
    /*
        This Parametr using to get amount of reward per one mined block.

        Formula (60 * 60 * 24 * 365) / AvBlockTime

        For Ethereum - 2102400
        For Matic - 15768000
        For BSC - 6307200

    */
    uint256 public REWARD_DIFFICULTY = 15768000;  

    constructor(
        address _storage_address,
        address _payments,
        uint256 _baseDifficulty
    ) CryptoProofs(_baseDifficulty) Depositable(_payments) {
        user_storage_address = _storage_address;
    }

    function setNodeNFTAddress(address _new) public onlyOwner {
        node_nft_address = _new;
    }

    function updateRewardDifficulty(uint256 _new) public onlyOwner {
        REWARD_DIFFICULTY = _new;
    }

    function sendProof(
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
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
            _user_root_hash_nonce,
            _user_signature,
            _file,
            merkleProof
        );
    }

    function sendProofFrom(
        address _node_address,
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
        uint64 _user_root_hash_nonce,
        bytes calldata _user_signature,
        bytes calldata _file,
        bytes32[] calldata merkleProof
    ) public {
        // TODO: switch to keccak256
        address signer = ECDSA.recover(
            sha256(abi.encodePacked(
                _user_root_hash,
                uint256(_user_root_hash_nonce)
            )),
            _user_signature
        );
        require(_user_address == signer);

        _sendProofFrom(
            _node_address,
            _user_address,
            _block_number,
            _user_root_hash,
            _user_root_hash_nonce,
            _file,
            merkleProof
        );
    }

    function _updateRootHash(
        address _user,
        address _updater,
        bytes32 new_hash,
        uint64 new_nonce
    ) private {
        bytes32 _cur_user_root_hash;
        uint256 _cur_user_root_hash_nonce;
        (_cur_user_root_hash, _cur_user_root_hash_nonce) = getUserRootHash(
            _user
        );

        require(new_nonce >= _cur_user_root_hash_nonce, "Too old root hash");

        // update root hash if it needed
        if (new_hash != _cur_user_root_hash) {
            _updateLastRootHash(_user, new_hash, new_nonce, _updater);
        }
    }

    function verifyFileProof(
        address _sender,
        bytes calldata _file,
        uint32 _block_number,
        uint256 _blocks_complited
    ) public view returns (bool) {
        require (blockhash(_block_number) != 0x0, "Wrong blockhash");

        bytes32 _file_proof = sha256(
            abi.encodePacked(_file, _sender, blockhash(_block_number))
        );
        return isMatchDifficulty(uint256(_file_proof), _blocks_complited);
    }
    function _checkoutNFT(address _proofer) internal { 
        if (node_nft_address != address(0)) {
            IDeNetNodeNFT NFT = IDeNetNodeNFT(node_nft_address);
            uint timeFromLastProof = block.timestamp - NFT.getLastUpdateByAddress(_proofer);
            /* 
                100% = 4320000
                2% = 86400 (1 day)

                Difficulty += 0-2% per proof if it faster than one day
            */
            if (timeFromLastProof <= 86400) {
                base_difficulty = base_difficulty.mul(4320000 + (86400 - timeFromLastProof)).div(4320000);
            } else {
                timeFromLastProof = timeFromLastProof % 86400;
                base_difficulty = base_difficulty.mul(8640000 - (86400 - timeFromLastProof)).div(8640000);
            }

            /* 
                100% = 8640000
                1% = 86400
                difficulty -= 0-1% (pseudo randomly) per proof if it slower than one day
            */
            NFT.addSuccessProof(_proofer);
        }
    }
    function _sendProofFrom(
        address _proofer,
        address _user_address,
        uint32 _block_number,
        bytes32 _user_root_hash,
        uint64 _user_root_hash_nonce,
        bytes calldata _file,
        bytes32[] calldata merkleProof
    ) private {
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
            _user_root_hash_nonce
        );

        bytes32 _file_hash = sha256(_file);
        (
            address _token_to_pay,
            uint256 _amount_returns,
            uint256 _blocks_complited
        ) = getUserRewardInfo(_user_address);

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

        _takePay(_token_to_pay, _user_address, _proofer, _amount_returns);
        _updateLastBlockNumber(_user_address, uint32(block.number));
        _checkoutNFT(_proofer);
    }

    function setUserPlan(address _token) public {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.setUserPlan(msg.sender, _token);
    }

    /*
     Returns info about user reward for ProofOfStorage

        # Input
            @_user - User Address

        # Output
            @_token_ddress - Token Address
            @_amount - Total Token Amount for PoS
            @_cur_block - Last Proof Block
    */
    function getUserRewardInfo(address _user)
        public
        view
        returns (
            address,
            uint256,
            uint256
        )
    {
        IPayments _payment = IPayments(paymentsAddress);

        IUserStorage _storage = IUserStorage(user_storage_address);
        address _tokenPay = _storage.getUserPayToken(_user);
        uint256 _userBalance = _payment.getBalance(_tokenPay, _user);

        uint256 _amountPerBlock = _userBalance / REWARD_DIFFICULTY; 
        uint256 _lastBlockNumber = _storage.getUserLastBlockNumber(_user);
        uint256 _proovedBlocks = block.number - _lastBlockNumber;
        uint256 _amountReturns = _proovedBlocks * _amountPerBlock;

        return (_tokenPay, _amountReturns, _proovedBlocks);
    }

    function _takePay(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) private {
        IPayments _payment = IPayments(paymentsAddress);
        _payment.localTransferFrom(_token, _from, _to, _amount);
    }

    function getUserRootHash(address _user)
        public
        view
        returns (bytes32, uint256)
    {
        IUserStorage _storage = IUserStorage(user_storage_address);
        return _storage.getUserRootHash(_user);
    }

    function _updateLastBlockNumber(address _user_address, uint32 _block_number)
        private
    {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.updateLastBlockNumber(_user_address, _block_number);
    }

    function _updateLastRootHash(
        address _user_address,
        bytes32 _user_root_hash,
        uint64 _nonce,
        address _updater
    ) private {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.updateRootHash(
            _user_address,
            _user_root_hash,
            _nonce,
            _updater
        );
    }

    function updateBaseDifficulty(uint256 _new_difficulty) public onlyOwner {
        base_difficulty = _new_difficulty;
    }


    /* 
        test for AUTOTEST
    */
    function admin_set_user_data(address _from, address _user, address _token, uint256 _amount) public onlyOwner {
        IUserStorage _storage = IUserStorage(user_storage_address);
        _storage.setUserPlan(_user, _token);
        IPayments _payment = IPayments(paymentsAddress);
        _payment.localTransferFrom(_token, _from, _user, _amount);
    }

    function changeSystemAddresses(
        address _storage_address,
        address _payments_address
    ) public onlyOwner {
        user_storage_address = _storage_address;
        paymentsAddress = _payments_address;
    }
}
