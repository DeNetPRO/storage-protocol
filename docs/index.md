# Solidity API

## Ownable

_Contract module which provides a basic access control mechanism, where
there is an account (an owner) that can be granted exclusive access to
specific functions.

By default, the owner account will be the one that deploys the contract. This
can later be changed with {transferOwnership}.

This module is used through inheritance. It will make available the modifier
`onlyOwner`, which can be applied to your functions to restrict their use to
the owner._

### _owner

```solidity
address _owner
```

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```

### constructor

```solidity
constructor() internal
```

_Initializes the contract setting the deployer as the initial owner._

### owner

```solidity
function owner() public view virtual returns (address)
```

_Returns the address of the current owner._

### onlyOwner

```solidity
modifier onlyOwner()
```

_Throws if called by any account other than the owner._

### renounceOwnership

```solidity
function renounceOwnership() public virtual
```

_Leaves the contract without owner. It will not be possible to call
`onlyOwner` functions anymore. Can only be called by the current owner.

NOTE: Renouncing ownership will leave the contract without an owner,
thereby removing any functionality that is only available to the owner._

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Can only be called by the current owner._

### _setOwner

```solidity
function _setOwner(address newOwner) private
```

## ERC20

_Implementation of the {IERC20} interface.

This implementation is agnostic to the way tokens are created. This means
that a supply mechanism has to be added in a derived contract using {_mint}.
For a generic mechanism see {ERC20PresetMinterPauser}.

TIP: For a detailed writeup see our guide
https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
to implement supply mechanisms].

We have followed general OpenZeppelin Contracts guidelines: functions revert
instead returning `false` on failure. This behavior is nonetheless
conventional and does not conflict with the expectations of ERC20
applications.

Additionally, an {Approval} event is emitted on calls to {transferFrom}.
This allows applications to reconstruct the allowance for all accounts just
by listening to said events. Other implementations of the EIP may not emit
these events, as it isn't required by the specification.

Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
functions have been added to mitigate the well-known issues around setting
allowances. See {IERC20-approve}._

### _balances

```solidity
mapping(address => uint256) _balances
```

### _allowances

```solidity
mapping(address => mapping(address => uint256)) _allowances
```

### _totalSupply

```solidity
uint256 _totalSupply
```

### _name

```solidity
string _name
```

### _symbol

```solidity
string _symbol
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

_Sets the values for {name} and {symbol}.

The default value of {decimals} is 18. To select a different value for
{decimals} you should overload it.

All two of these values are immutable: they can only be set once during
construction._

### name

```solidity
function name() public view virtual returns (string)
```

_Returns the name of the token._

### symbol

```solidity
function symbol() public view virtual returns (string)
```

_Returns the symbol of the token, usually a shorter version of the
name._

### decimals

```solidity
function decimals() public view virtual returns (uint8)
```

_Returns the number of decimals used to get its user representation.
For example, if `decimals` equals `2`, a balance of `505` tokens should
be displayed to a user as `5.05` (`505 / 10 ** 2`).

Tokens usually opt for a value of 18, imitating the relationship between
Ether and Wei. This is the value {ERC20} uses, unless this function is
overridden;

NOTE: This information is only used for _display_ purposes: it in
no way affects any of the arithmetic of the contract, including
{IERC20-balanceOf} and {IERC20-transfer}._

### totalSupply

```solidity
function totalSupply() public view virtual returns (uint256)
```

_See {IERC20-totalSupply}._

### balanceOf

```solidity
function balanceOf(address account) public view virtual returns (uint256)
```

_See {IERC20-balanceOf}._

### transfer

```solidity
function transfer(address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transfer}.

Requirements:

- `recipient` cannot be the zero address.
- the caller must have a balance of at least `amount`._

### allowance

```solidity
function allowance(address owner, address spender) public view virtual returns (uint256)
```

_See {IERC20-allowance}._

### approve

```solidity
function approve(address spender, uint256 amount) public virtual returns (bool)
```

_See {IERC20-approve}.

Requirements:

- `spender` cannot be the zero address._

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transferFrom}.

Emits an {Approval} event indicating the updated allowance. This is not
required by the EIP. See the note at the beginning of {ERC20}.

Requirements:

- `sender` and `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`.
- the caller must have allowance for ``sender``'s tokens of at least
`amount`._

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
```

_Atomically increases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address._

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
```

_Atomically decreases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address.
- `spender` must have allowance for the caller of at least
`subtractedValue`._

### _transfer

```solidity
function _transfer(address sender, address recipient, uint256 amount) internal virtual
```

_Moves `amount` of tokens from `sender` to `recipient`.

This internal function is equivalent to {transfer}, and can be used to
e.g. implement automatic token fees, slashing mechanisms, etc.

Emits a {Transfer} event.

Requirements:

- `sender` cannot be the zero address.
- `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`._

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Creates `amount` tokens and assigns them to `account`, increasing
the total supply.

Emits a {Transfer} event with `from` set to the zero address.

Requirements:

- `account` cannot be the zero address._

### _burn

```solidity
function _burn(address account, uint256 amount) internal virtual
```

_Destroys `amount` tokens from `account`, reducing the
total supply.

Emits a {Transfer} event with `to` set to the zero address.

Requirements:

- `account` cannot be the zero address.
- `account` must have at least `amount` tokens._

### _approve

```solidity
function _approve(address owner, address spender, uint256 amount) internal virtual
```

_Sets `amount` as the allowance of `spender` over the `owner` s tokens.

This internal function is equivalent to `approve`, and can be used to
e.g. set automatic allowances for certain subsystems, etc.

Emits an {Approval} event.

Requirements:

- `owner` cannot be the zero address.
- `spender` cannot be the zero address._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual
```

_Hook that is called before any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
will be transferred to `to`.
- when `from` is zero, `amount` tokens will be minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens will be burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

### _afterTokenTransfer

```solidity
function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual
```

_Hook that is called after any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
has been transferred to `to`.
- when `from` is zero, `amount` tokens have been minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens have been burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

## IERC20

_Interface of the ERC20 standard as defined in the EIP._

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

_Returns the amount of tokens in existence._

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

_Returns the amount of tokens owned by `account`._

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

_Moves `amount` tokens from the caller's account to `recipient`.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event._

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

_Returns the remaining number of tokens that `spender` will be
allowed to spend on behalf of `owner` through {transferFrom}. This is
zero by default.

This value changes when {approve} or {transferFrom} are called._

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

_Sets `amount` as the allowance of `spender` over the caller's tokens.

Returns a boolean value indicating whether the operation succeeded.

IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender's allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

Emits an {Approval} event._

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

_Moves `amount` tokens from `sender` to `recipient` using the
allowance mechanism. `amount` is then deducted from the caller's
allowance.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event._

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

_Emitted when `value` tokens are moved from one account (`from`) to
another (`to`).

Note that `value` may be zero._

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

_Emitted when the allowance of a `spender` for an `owner` is set by
a call to {approve}. `value` is the new allowance._

## IERC20Metadata

_Interface for the optional metadata functions from the ERC20 standard.

_Available since v4.1.__

### name

```solidity
function name() external view returns (string)
```

_Returns the name of the token._

### symbol

```solidity
function symbol() external view returns (string)
```

_Returns the symbol of the token._

### decimals

```solidity
function decimals() external view returns (uint8)
```

_Returns the decimals places of the token._

## Context

_Provides information about the current execution context, including the
sender of the transaction and its data. While these are generally available
via msg.sender and msg.data, they should not be accessed in such a direct
manner, since when dealing with meta-transactions the account sending and
paying for execution may not be the actual sender (as far as an application
is concerned).

This contract is only required for intermediate, library-like contracts._

### _msgSender

```solidity
function _msgSender() internal view virtual returns (address)
```

### _msgData

```solidity
function _msgData() internal view virtual returns (bytes)
```

## ECDSA

_Elliptic Curve Digital Signature Algorithm (ECDSA) operations.

These functions can be used to verify that a message was signed by the holder
of the private keys of a given address._

### RecoverError

```solidity
enum RecoverError {
  NoError,
  InvalidSignature,
  InvalidSignatureLength,
  InvalidSignatureS,
  InvalidSignatureV
}
```

### _throwError

```solidity
function _throwError(enum ECDSA.RecoverError error) private pure
```

### tryRecover

```solidity
function tryRecover(bytes32 hash, bytes signature) internal pure returns (address, enum ECDSA.RecoverError)
```

_Returns the address that signed a hashed message (`hash`) with
`signature` or error string. This address can then be used for verification purposes.

The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
this function rejects them by requiring the `s` value to be in the lower
half order, and the `v` value to be either 27 or 28.

IMPORTANT: `hash` _must_ be the result of a hash operation for the
verification to be secure: it is possible to craft signatures that
recover to arbitrary addresses for non-hashed data. A safe way to ensure
this is by receiving a hash of the original message (which may otherwise
be too long), and then calling {toEthSignedMessageHash} on it.

Documentation for signature generation:
- with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
- with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]

_Available since v4.3.__

### recover

```solidity
function recover(bytes32 hash, bytes signature) internal pure returns (address)
```

_Returns the address that signed a hashed message (`hash`) with
`signature`. This address can then be used for verification purposes.

The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
this function rejects them by requiring the `s` value to be in the lower
half order, and the `v` value to be either 27 or 28.

IMPORTANT: `hash` _must_ be the result of a hash operation for the
verification to be secure: it is possible to craft signatures that
recover to arbitrary addresses for non-hashed data. A safe way to ensure
this is by receiving a hash of the original message (which may otherwise
be too long), and then calling {toEthSignedMessageHash} on it._

### tryRecover

```solidity
function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, enum ECDSA.RecoverError)
```

_Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.

See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]

_Available since v4.3.__

### recover

```solidity
function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address)
```

_Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.

_Available since v4.2.__

### tryRecover

```solidity
function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, enum ECDSA.RecoverError)
```

_Overload of {ECDSA-tryRecover} that receives the `v`,
`r` and `s` signature fields separately.

_Available since v4.3.__

### recover

```solidity
function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address)
```

_Overload of {ECDSA-recover} that receives the `v`,
`r` and `s` signature fields separately.
/_

### toEthSignedMessageHash

```solidity
function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32)
```

_Returns an Ethereum Signed Message, created from a `hash`. This
produces hash corresponding to the one signed with the
https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
JSON-RPC method as part of EIP-191.

See {recover}.
/_

### toTypedDataHash

```solidity
function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32)
```

_Returns an Ethereum Signed Typed Data, created from a
`domainSeparator` and a `structHash`. This produces hash corresponding
to the one signed with the
https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
JSON-RPC method as part of EIP-712.

See {recover}.
/_

## Math

_Standard math utilities missing in the Solidity language._

### max

```solidity
function max(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the largest of two numbers._

### min

```solidity
function min(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the smallest of two numbers._

### average

```solidity
function average(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the average of two numbers. The result is rounded towards
zero._

### ceilDiv

```solidity
function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the ceiling of the division of two numbers.

This differs from standard division with `/` in that it rounds up instead
of rounding down._

## SafeMath

_Wrappers over Solidity's arithmetic operations.

NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
now has built in overflow checking._

### tryAdd

```solidity
function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the addition of two unsigned integers, with an overflow flag.

_Available since v3.4.__

### trySub

```solidity
function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the substraction of two unsigned integers, with an overflow flag.

_Available since v3.4.__

### tryMul

```solidity
function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the multiplication of two unsigned integers, with an overflow flag.

_Available since v3.4.__

### tryDiv

```solidity
function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the division of two unsigned integers, with a division by zero flag.

_Available since v3.4.__

### tryMod

```solidity
function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the remainder of dividing two unsigned integers, with a division by zero flag.

_Available since v3.4.__

### add

```solidity
function add(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the addition of two unsigned integers, reverting on
overflow.

Counterpart to Solidity's `+` operator.

Requirements:

- Addition cannot overflow._

### sub

```solidity
function sub(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the subtraction of two unsigned integers, reverting on
overflow (when the result is negative).

Counterpart to Solidity's `-` operator.

Requirements:

- Subtraction cannot overflow._

### mul

```solidity
function mul(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the multiplication of two unsigned integers, reverting on
overflow.

Counterpart to Solidity's `*` operator.

Requirements:

- Multiplication cannot overflow._

### div

```solidity
function div(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the integer division of two unsigned integers, reverting on
division by zero. The result is rounded towards zero.

Counterpart to Solidity's `/` operator.

Requirements:

- The divisor cannot be zero._

### mod

```solidity
function mod(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
reverting when dividing by zero.

Counterpart to Solidity's `%` operator. This function uses a `revert`
opcode (which leaves remaining gas untouched) while Solidity uses an
invalid opcode to revert (consuming all remaining gas).

Requirements:

- The divisor cannot be zero._

### sub

```solidity
function sub(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the subtraction of two unsigned integers, reverting with custom message on
overflow (when the result is negative).

CAUTION: This function is deprecated because it requires allocating memory for the error
message unnecessarily. For custom revert reasons use {trySub}.

Counterpart to Solidity's `-` operator.

Requirements:

- Subtraction cannot overflow._

### div

```solidity
function div(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the integer division of two unsigned integers, reverting with custom message on
division by zero. The result is rounded towards zero.

Counterpart to Solidity's `/` operator. Note: this function uses a
`revert` opcode (which leaves remaining gas untouched) while Solidity
uses an invalid opcode to revert (consuming all remaining gas).

Requirements:

- The divisor cannot be zero._

### mod

```solidity
function mod(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
reverting with custom message when dividing by zero.

CAUTION: This function is deprecated because it requires allocating memory for the error
message unnecessarily. For custom revert reasons use {tryMod}.

Counterpart to Solidity's `%` operator. This function uses a `revert`
opcode (which leaves remaining gas untouched) while Solidity uses an
invalid opcode to revert (consuming all remaining gas).

Requirements:

- The divisor cannot be zero._

## ContractStorage

_ContractStorage is storing addresses of main contracts.

    Add & Update contracts via updateVersion()
    Get contract address via getContractAddressViaName()_

### _contractVector

```solidity
mapping(bytes32 => mapping(uint256 => address[])) _contractVector
```

__contractVector is vector for last version smart contracts
        
        last version = _contractVector[sha256(contractName)].last_

### _contractNames

```solidity
mapping(uint256 => string[]) _contractNames
```

### _knownNetworkIds

```solidity
uint256[] _knownNetworkIds
```

### getContractAddress

```solidity
function getContractAddress(bytes32 contractName, uint256 networkId) public view returns (address)
```

_Returns address of contract in selected network by keccak name

        @param contractName - keccak name of contract (with encodepacked);_

### getContractAddressViaName

```solidity
function getContractAddressViaName(string contractString, uint256 networkId) public view returns (address)
```

_Returns address of contract in selected network by string name

        @param contractString - string name of contract_

### _updateVersion

```solidity
function _updateVersion(bytes32 contractName, address newAddress, uint256 networkId) internal
```

_updateVersion is function to update address of contracts_

### stringToContractName

```solidity
function stringToContractName(string nameString) public pure returns (bytes32)
```

_function returns keccak256 of named contract

        @param nameString - name of core contract, examples:
            "proofofstorage" - ProofOfStorage 
            "gastoken" - TB/Year gas token
            "userstorage" - UserStorage Address
            "nodenft" - node nft address

        @return bytes32 - keccak256(nameString)_

### updateVersion

```solidity
function updateVersion(string contractNameString, address newContractAddress, uint256 networkId) public
```

_Compex function to update contracts on all networks

        @param contractNameString - name of core contract, examples:
            "proofofstorage" - ProofOfStorage 
            "gastoken" - TB/Year gas token
            "userstorage" - UserStorage Address
            "nodenft" - node nft address
            "pairtoken" - DFILE Token (as main token). If not available, using USDC or other.
            "userstorage" - User Storage address (Contract where stored data like Nonce and root hash)
        @param newContractAddress - new address of contract
        @param networkId - ID of network, examples:
            1 - Ethereum Mainnet
            3 - Ropsten Testnet
            10 - Optimism
            42 - Kovan Testnet
            56 - Binance Smart Chain
            57 - Syscoin Mainnet
            61 - Ethereum Classic Mainnet
            66 - OKXChain Mainnet
            100 - Gnosis
            128 - Huobi ECO Chain Mainnet
            137 - Polygon Mainne
            250 - Fantom Opera
            1285 - Moonriver
            1313161554 - Aurora Mainnet_

### getContractListOfNetwork

```solidity
function getContractListOfNetwork(uint256 networkId) public view returns (string[])
```

### getNetworkLists

```solidity
function getNetworkLists() public view returns (uint256[])
```

## ERC20

_Implementation of the {IERC20} interface.

This implementation is agnostic to the way tokens are created. This means
that a supply mechanism has to be added in a derived contract using {_mint}.
For a generic mechanism see {ERC20PresetMinterPauser}.

TIP: For a detailed writeup see our guide
https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
to implement supply mechanisms].

We have followed general OpenZeppelin guidelines: functions revert instead
of returning `false` on failure. This behavior is nonetheless conventional
and does not conflict with the expectations of ERC20 applications.

Additionally, an {Approval} event is emitted on calls to {transferFrom}.
This allows applications to reconstruct the allowance for all accounts just
by listening to said events. Other implementations of the EIP may not emit
these events, as it isn't required by the specification.

Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
functions have been added to mitigate the well-known issues around setting
allowances. See {IERC20-approve}._

### _balances

```solidity
mapping(address => uint256) _balances
```

### _allowances

```solidity
mapping(address => mapping(address => uint256)) _allowances
```

### _totalSupply

```solidity
uint256 _totalSupply
```

### _name

```solidity
string _name
```

### _symbol

```solidity
string _symbol
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

_Sets the values for {name} and {symbol}.

The defaut value of {decimals} is 18. To select a different value for
{decimals} you should overload it.

All three of these values are immutable: they can only be set once during
construction._

### name

```solidity
function name() public view virtual returns (string)
```

_Returns the name of the token._

### symbol

```solidity
function symbol() public view virtual returns (string)
```

_Returns the symbol of the token, usually a shorter version of the
name._

### decimals

```solidity
function decimals() public view virtual returns (uint8)
```

_Returns the number of decimals used to get its user representation.
For example, if `decimals` equals `2`, a balance of `505` tokens should
be displayed to a user as `5,05` (`505 / 10 ** 2`).

Tokens usually opt for a value of 18, imitating the relationship between
Ether and Wei. This is the value {ERC20} uses, unless this function is
overloaded;

NOTE: This information is only used for _display_ purposes: it in
no way affects any of the arithmetic of the contract, including
{IERC20-balanceOf} and {IERC20-transfer}._

### totalSupply

```solidity
function totalSupply() public view virtual returns (uint256)
```

_See {IERC20-totalSupply}._

### balanceOf

```solidity
function balanceOf(address account) public view virtual returns (uint256)
```

_See {IERC20-balanceOf}._

### transfer

```solidity
function transfer(address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transfer}.

Requirements:

- `recipient` cannot be the zero address.
- the caller must have a balance of at least `amount`._

### allowance

```solidity
function allowance(address owner, address spender) public view virtual returns (uint256)
```

_See {IERC20-allowance}._

### approve

```solidity
function approve(address spender, uint256 amount) public virtual returns (bool)
```

_See {IERC20-approve}.

Requirements:

- `spender` cannot be the zero address._

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transferFrom}.

Emits an {Approval} event indicating the updated allowance. This is not
required by the EIP. See the note at the beginning of {ERC20}.

Requirements:

- `sender` and `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`.
- the caller must have allowance for ``sender``'s tokens of at least
`amount`._

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
```

_Atomically increases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address._

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
```

_Atomically decreases the allowance granted to `spender` by the caller.

This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.

Emits an {Approval} event indicating the updated allowance.

Requirements:

- `spender` cannot be the zero address.
- `spender` must have allowance for the caller of at least
`subtractedValue`._

### _transfer

```solidity
function _transfer(address sender, address recipient, uint256 amount) internal virtual
```

_Moves tokens `amount` from `sender` to `recipient`.

This is internal function is equivalent to {transfer}, and can be used to
e.g. implement automatic token fees, slashing mechanisms, etc.

Emits a {Transfer} event.

Requirements:

- `sender` cannot be the zero address.
- `recipient` cannot be the zero address.
- `sender` must have a balance of at least `amount`._

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Creates `amount` tokens and assigns them to `account`, increasing
the total supply.

Emits a {Transfer} event with `from` set to the zero address.

Requirements:

- `to` cannot be the zero address._

### _burn

```solidity
function _burn(address account, uint256 amount) internal virtual
```

_Destroys `amount` tokens from `account`, reducing the
total supply.

Emits a {Transfer} event with `to` set to the zero address.

Requirements:

- `account` cannot be the zero address.
- `account` must have at least `amount` tokens._

### _approve

```solidity
function _approve(address owner, address spender, uint256 amount) internal virtual
```

_Sets `amount` as the allowance of `spender` over the `owner` s tokens.

This internal function is equivalent to `approve`, and can be used to
e.g. set automatic allowances for certain subsystems, etc.

Emits an {Approval} event.

Requirements:

- `owner` cannot be the zero address.
- `spender` cannot be the zero address._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual
```

_Hook that is called before any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
will be to transferred to `to`.
- when `from` is zero, `amount` tokens will be minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens will be burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

## ERC20Vesting

### vestingToken

```solidity
address vestingToken
```

### VestingProfile

```solidity
struct VestingProfile {
  uint64 timeStart;
  uint64 timeEnd;
  uint256 amount;
  uint256 payed;
}
```

### vestingStatus

```solidity
mapping(address => struct ERC20Vesting.VestingProfile) vestingStatus
```

### createVesting

```solidity
function createVesting(address _user, struct ERC20Vesting.VestingProfile info) public
```

### getAmountToWithdraw

```solidity
function getAmountToWithdraw(address _user) public view returns (uint256)
```

### withdraw

```solidity
function withdraw() public
```

## Selection

### timeVote

```solidity
mapping(address => uint256) timeVote
```

### votesCount

```solidity
uint256 votesCount
```

### votesAmount

```solidity
uint256 votesAmount
```

### lastVotePeriod

```solidity
uint256 lastVotePeriod
```

### minVote

```solidity
uint256 minVote
```

### maxVote

```solidity
uint256 maxVote
```

### votePeriod

```solidity
uint256 votePeriod
```

### currentState

```solidity
uint256 currentState
```

### contractName

```solidity
string contractName
```

### constructor

```solidity
constructor(uint256 _minVote, uint256 _maxVote, string _name, uint256 _period) public
```

### getCurPeriod

```solidity
function getCurPeriod() public view returns (uint256)
```

### getCurrentState

```solidity
function getCurrentState() public view returns (uint256)
```

### _updateVotes

```solidity
function _updateVotes() internal
```

### voteFor

```solidity
function voteFor(address account, uint256 vote, uint256 votePower) public
```

## Governance

### depositTokenAddresss

```solidity
address depositTokenAddresss
```

### depositedBalance

```solidity
mapping(address => uint256) depositedBalance
```

### lockedAmounts

```solidity
mapping(address => uint256) lockedAmounts
```

### unlockTime

```solidity
mapping(address => uint256) unlockTime
```

### votes

```solidity
mapping(uint256 => uint256) votes
```

### lockPeriod

```solidity
uint256 lockPeriod
```

### constructor

```solidity
constructor(address _token) public
```

### updateLockTime

```solidity
function updateLockTime(uint256 newPeriod) public
```

### balanceOf

```solidity
function balanceOf(address account) public view returns (uint256)
```

### vote

```solidity
function vote(uint256 voteID, uint256 votePower) public
```

### depositToken

```solidity
function depositToken(uint256 amount) public
```

### withdrawToken

```solidity
function withdrawToken(uint256 amount) public
```

## SimpleNFT

### _tokenOwner

```solidity
mapping(uint256 => address) _tokenOwner
```

### _ownedTokensCount

```solidity
mapping(address => uint256) _ownedTokensCount
```

### nodeByAddress

```solidity
mapping(address => uint256) nodeByAddress
```

### balanceOf

```solidity
function balanceOf(address owner) public view returns (uint256)
```

### getNodeIDByAddress

```solidity
function getNodeIDByAddress(address _node) public view returns (uint256)
```

### ownerOf

```solidity
function ownerOf(uint256 tokenId) public view returns (address)
```

### _mint

```solidity
function _mint(address to, uint256 tokenId) internal
```

### _burn

```solidity
function _burn(address owner, uint256 tokenId) internal
```

### _removeTokenFrom

```solidity
function _removeTokenFrom(address _from, uint256 tokenId) internal
```

### _transferFrom

```solidity
function _transferFrom(address _from, address _to, uint256 _tokenID) internal
```

### _addTokenTo

```solidity
function _addTokenTo(address to, uint256 tokenId) internal
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view returns (bool)
```

## SimpleMetaData

### _name

```solidity
string _name
```

### _symbol

```solidity
string _symbol
```

### _degradation

```solidity
uint256 _degradation
```

### _node

```solidity
mapping(uint256 => struct IMetaData.DeNetNode) _node
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

### name

```solidity
function name() external view returns (string)
```

### symbol

```solidity
function symbol() external view returns (string)
```

### nodeInfo

```solidity
function nodeInfo(uint256 tokenId) public view returns (struct IMetaData.DeNetNode)
```

### _setNodeInfo

```solidity
function _setNodeInfo(uint256 tokenId, uint8[4] ip, uint16 port) internal
```

### _burnNode

```solidity
function _burnNode(address owner, uint256 tokenId) internal
```

### _increaseRank

```solidity
function _increaseRank(uint256 tokenId) internal
```

## DeNetNodeNFT

### nextNodeID

```solidity
uint256 nextNodeID
```

### maxNodeID

```solidity
uint256 maxNodeID
```

### nodesAvailable

```solidity
uint256 nodesAvailable
```

### maxAlivePeriod

```solidity
uint256 maxAlivePeriod
```

### proofsBeforeIncreaseMaxNodeID

```solidity
uint256 proofsBeforeIncreaseMaxNodeID
```

### successProofsCount

```solidity
uint256 successProofsCount
```

### usingWhiteList

```solidity
bool usingWhiteList
```

### _isWhiteListed

```solidity
mapping(address => bool) _isWhiteListed
```

### constructor

```solidity
constructor(string _name, string _symbol, address _pos, uint256 nodeLimit) public
```

### changeWhiteListStatus

```solidity
function changeWhiteListStatus(bool _newStatus) public
```

### addToWhiteList

```solidity
function addToWhiteList(address _node) public
```

### whiteListMany

```solidity
function whiteListMany(address[] _nodes) public
```

### updateNodesLimit

```solidity
function updateNodesLimit(uint256 _newLimit) public
```

### addSuccessProof

```solidity
function addSuccessProof(address _nodeOwner) public
```

### createNode

```solidity
function createNode(uint8[4] ip, uint16 port) public returns (uint256)
```

### updateNode

```solidity
function updateNode(uint256 nodeID, uint8[4] ip, uint16 port) public
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

### stealNode

```solidity
function stealNode(uint256 _nodeID, address _to) public
```

### getLastUpdateByAddress

```solidity
function getLastUpdateByAddress(address _user) public view returns (uint256)
```

## Payments

### _tokensCount

```solidity
uint256 _tokensCount
```

### constructor

```solidity
constructor(address _address, string _tokenName, string _tokenSymbol) public
```

### getBalance

```solidity
function getBalance(address _address) public view returns (uint256 result)
```

### localTransferFrom

```solidity
function localTransferFrom(address _from, address _to, uint256 _amount) public
```

### depositToLocal

```solidity
function depositToLocal(address _user_address, address _token, uint256 _amount) public
```

### closeDeposit

```solidity
function closeDeposit(address _account, address _token) public
```

TODO:
            - add vesting/unlockable balance

## PoSAdmin

### proofOfStorageAddress

```solidity
address proofOfStorageAddress
```

### constructor

```solidity
constructor(address _pos) public
```

### onlyPoS

```solidity
modifier onlyPoS()
```

### changePoS

```solidity
function changePoS(address _newAddress) public
```

## Depositable

### paymentsAddress

```solidity
address paymentsAddress
```

### maxDepositPerUser

```solidity
uint256 maxDepositPerUser
```

### timeLimit

```solidity
uint256 timeLimit
```

### limitReached

```solidity
mapping(address => mapping(uint32 => uint256)) limitReached
```

### constructor

```solidity
constructor(address _payments) public
```

### getAvailableDeposit

```solidity
function getAvailableDeposit(address _user, uint256 _amount, uint32 _curDate) public view returns (uint256)
```

Show available amount for deposit

### makeDeposit

```solidity
function makeDeposit(uint256 _amount) public
```

make deposit function.

        @param _amount - Amount of  Pair Token

        @dev Require approve from Pair Token to paymentsAddress

### closeDeposit

```solidity
function closeDeposit() public
```

close deposit functuin. Will burn part of gastoken and return pair token to msg.sender

### updateDepositLimits

```solidity
function updateDepositLimits(uint256 _newLimit) internal
```

UpdateDepositLimits for all users

## ProofOfStorage

### user_storage_address

```solidity
address user_storage_address
```

Address of smart contract, where User Storage placed

### node_nft_address

```solidity
address node_nft_address
```

Address of smart contract, where NFT of nodes placed

### _max_blocks_after_proof

```solidity
uint256 _max_blocks_after_proof
```

Max blocks after proof needs to use newest proof as it possible
        
        see more, in StringNumbersConstant

### debug_mode

```solidity
bool debug_mode
```

_Debug mode using only for test's. 
        Check it parametr before any deposits!
        
        What is using for, when it true:
            - Disabling verification of User Signature_

### min_storage_require

```solidity
uint256 min_storage_require
```

_Minimal sotrage size for proof. 

        in Polygon netowrk best min storage size ~10GB (~0.03 USD or more per month).
        if user store less than 10GB, user storage size will increased to min_storage_require

        @notice min_storage_require in megabytes._

### constructor

```solidity
constructor(address _storage_address, address _payments) public
```

### setMaxDeposit

```solidity
function setMaxDeposit(uint256 _newLimit) public
```

### _updateNodeRank

```solidity
function _updateNodeRank(address _proofer, uint256 current_difficulty) internal returns (uint256)
```

this function updating Node Rank.

        TODO: Move it to DifficultyManufacturing

        @return current_difficulty - new difficulty for all nodes.

### turnDebugMode

```solidity
function turnDebugMode() public
```

Function to disable user signature checking.

        TODO: Will removed, if tests will work correctly without it.

### setMinStorage

```solidity
function setMinStorage(uint256 _size) public
```

### updateBaseDifficulty

```solidity
function updateBaseDifficulty(uint256 _new_difficulty) public
```

More _new_difficulty = more random for nodes. Less _new_difficulty more proofs and less randomize.

### changeSystemAddresses

```solidity
function changeSystemAddresses(address _storage_address, address _payments_address) public
```

_Update Storage Address or Payments Address for something updates

        TODO: Ned to replace to storage contract_

### sendProof

```solidity
function sendProof(address _user_address, uint32 _block_number, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _user_root_hash_nonce, bytes _user_signature, bytes _file, bytes32[] merkleProof) public
```

_Send proof use sendProofFrom with msg.sender address as node

       @param _user_address - address of owner data
       @param _block_number - blocknumber for proof (max 256 from current block)
       @param _user_root_hash - last user root_hash 
       @param _user_storage_size - user storage size in megabytes
       @param _user_root_hash_nonce - nonce from userside, need for verify last root_hash
       @param _user_signature - signature with root_hash, storage_size, nonce from user
       @param _file - 8kb of data.
       @param merkleProof - merkle proof from _file to root_hash_

### sendProofFrom

```solidity
function sendProofFrom(address _node_address, address _user_address, uint32 _block_number, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _user_root_hash_nonce, bytes _user_signature, bytes _file, bytes32[] merkleProof) public
```

### _updateRootHash

```solidity
function _updateRootHash(address _user, address _updater, bytes32 _new_hash, uint64 _new_storage_size, uint64 _new_nonce) private
```

### verifyFileProof

```solidity
function verifyFileProof(address _sender, bytes _file, uint32 _block_number, uint256 _time_passed) public view returns (bool)
```

### _sendProofFrom

```solidity
function _sendProofFrom(address _proofer, address _user_address, uint32 _block_number, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _user_root_hash_nonce, bytes _file, bytes32[] merkleProof) private returns (uint256)
```

### getUserRewardInfo

```solidity
function getUserRewardInfo(address _user, uint256 _user_storage_size) public view returns (uint256, uint256)
```

Returns info about user reward for ProofOfStorage

        @param _user - User Address
        @param _user_storage_size - User Storage Size
        
        @return _amount - Total Token Amount for PoS
        @return _last_rroof_time - Last Proof Time

### _takePay

```solidity
function _takePay(address _from, address _to, uint256 _amount) private
```

### getUserRootHash

```solidity
function getUserRootHash(address _user) public view returns (bytes32, uint256)
```

### _updateLastProofTime

```solidity
function _updateLastProofTime(address _user_address) private
```

### _updateLastRootHash

```solidity
function _updateLastRootHash(address _user_address, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _nonce, address _updater) private
```

## Reward

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### storageTokenAddress

```solidity
address storageTokenAddress
```

### rewardLimit

```solidity
uint256 rewardLimit
```

### rewarded

```solidity
mapping(address => uint256) rewarded
```

### constructor

```solidity
constructor(address _tokAddress) public
```

### addReward

```solidity
function addReward(address _reciever, uint256 _amount) public
```

## feeCollector

### div_fee

```solidity
uint16 div_fee
```

### payout_fee

```solidity
uint16 payout_fee
```

### payin_fee

```solidity
uint16 payin_fee
```

### mint_percent

```solidity
uint16 mint_percent
```

### _mint_daily_limit_of_totalSupply

```solidity
uint16 _mint_daily_limit_of_totalSupply
```

### recipient_fee

```solidity
address recipient_fee
```

### fee_limit

```solidity
uint256 fee_limit
```

### fee_collected

```solidity
uint256 fee_collected
```

### _addFee

```solidity
function _addFee(uint256 amount) internal
```

### calc_payout_fee

```solidity
function calc_payout_fee(uint256 amount) public view returns (uint256)
```

### toFeelessPayout

```solidity
function toFeelessPayout(uint256 amount) public view returns (uint256)
```

### change_fee_limit

```solidity
function change_fee_limit(uint256 new_fee_limit) public
```

### change_payout_fee

```solidity
function change_payout_fee(uint16 new_fee) public
```

### change_payin_fee

```solidity
function change_payin_fee(uint16 new_fee) public
```

### change_recipient_fee

```solidity
function change_recipient_fee(address _new_recipient_fee) public
```

## StorageToken

### pairTokenBalance

```solidity
uint256 pairTokenBalance
```

### pairTokenAddress

```solidity
address pairTokenAddress
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

### changeTokenAddress

```solidity
function changeTokenAddress(address newAddress) public
```

### _getDepositReturns

```solidity
function _getDepositReturns(uint256 amount) internal view returns (uint256)
```

### _getWidthdrawithReturns

```solidity
function _getWidthdrawithReturns(uint256 amount) internal view returns (uint256)
```

### feelessBalance

```solidity
function feelessBalance(address account) public view returns (uint256)
```

### getWidthdrawtReturns

```solidity
function getWidthdrawtReturns(uint256 amount) public view returns (uint256)
```

### _deposit

```solidity
function _deposit(uint256 amount) internal
```

### _depositByAddress

```solidity
function _depositByAddress(address _account, uint256 amount) internal
```

### _updatePairTokenBalance

```solidity
function _updatePairTokenBalance() internal
```

### _closeAllDeposit

```solidity
function _closeAllDeposit() internal
```

### _closeAllDeposiByAddresst

```solidity
function _closeAllDeposiByAddresst(address account) internal
```

### _closePartOfDeposit

```solidity
function _closePartOfDeposit(uint256 amount) internal
```

### _closePartOfDepositByAddress

```solidity
function _closePartOfDepositByAddress(address account, uint256 amount) internal
```

### testMint

```solidity
function testMint(address to, uint256 amount) public
```

### testBurn

```solidity
function testBurn(address to, uint256 amount) public
```

### distruct

```solidity
function distruct() public
```

### _collectFee

```solidity
function _collectFee() internal virtual
```

## UserStorage

### UserData

```solidity
struct UserData {
  uint256 last_proof_time;
  uint256 user_storage_size;
  uint256 nonce;
  bytes32 user_root_hash;
}
```

### name

```solidity
string name
```

### PoS_Contract_Address

```solidity
address PoS_Contract_Address
```

### _users

```solidity
mapping(address => struct UserStorage.UserData) _users
```

### onlyPoS

```solidity
modifier onlyPoS()
```

### constructor

```solidity
constructor(string _name, address _address) public
```

### changePoS

```solidity
function changePoS(address _new_address) public
```

### getUserRootHash

```solidity
function getUserRootHash(address _user_address) public view returns (bytes32, uint256)
```

### updateRootHash

```solidity
function updateRootHash(address _user_address, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _nonce, address _updater) public
```

### updateLastProofTime

```solidity
function updateLastProofTime(address _user_address) public
```

### getPeriodFromLastProof

```solidity
function getPeriodFromLastProof(address _user_address) external view returns (uint256)
```

## IContractStorage

### stringToContractName

```solidity
function stringToContractName(string nameString) external pure returns (bytes32)
```

### getContractAddress

```solidity
function getContractAddress(bytes32 contractName, uint256 networkId) external view returns (address)
```

### getContractAddressViaName

```solidity
function getContractAddressViaName(string contractString, uint256 networkId) external view returns (address)
```

## IGovernance

### Deposit

```solidity
event Deposit(address to, uint256 amount)
```

### Withdraw

```solidity
event Withdraw(address to, uint256 amount)
```

## ISimpleINFT

### Transfer

```solidity
event Transfer(address from, address to, uint256 tokenId)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### getNodeIDByAddress

```solidity
function getNodeIDByAddress(address _node) external view returns (uint256)
```

### ownerOf

```solidity
function ownerOf(uint256 tokenId) external view returns (address)
```

## IMetaData

### UpdateNodeStatus

```solidity
event UpdateNodeStatus(address from, uint256 tokenId, uint8[4] ipAddress, uint16 port)
```

### DeNetNode

```solidity
struct DeNetNode {
  uint8[4] ipAddress;
  uint16 port;
  uint256 createdAt;
  uint256 updatedAt;
  uint256 updatesCount;
  uint256 rank;
}
```

### nodeInfo

```solidity
function nodeInfo(uint256 tokenId) external view returns (struct IMetaData.DeNetNode)
```

## IDeNetNodeNFT

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### addSuccessProof

```solidity
function addSuccessProof(address _nodeOwner) external
```

### getLastUpdateByAddress

```solidity
function getLastUpdateByAddress(address _user) external view returns (uint256)
```

## IOldPayments

### LocalTransferFrom

```solidity
event LocalTransferFrom(address _token, address _from, address _to, uint256 _value)
```

### ChangePoSContract

```solidity
event ChangePoSContract(address PoS_Contract_Address)
```

### RegisterToken

```solidity
event RegisterToken(address _token, uint256 _id)
```

### getBalance

```solidity
function getBalance(address _token, address _address) external view returns (uint256 result)
```

### localTransferFrom

```solidity
function localTransferFrom(address _token, address _from, address _to, uint256 _amount) external
```

### depositToLocal

```solidity
function depositToLocal(address _user_address, address _token, uint256 _amount) external
```

### closeDeposit

```solidity
function closeDeposit(address _user_address, address _token) external
```

## IPayments

### LocalTransferFrom

```solidity
event LocalTransferFrom(address _from, address _to, uint256 _value)
```

### ChangePoSContract

```solidity
event ChangePoSContract(address PoS_Contract_Address)
```

### RegisterToken

```solidity
event RegisterToken(address _token, uint256 _id)
```

### getBalance

```solidity
function getBalance(address _address) external view returns (uint256 result)
```

### localTransferFrom

```solidity
function localTransferFrom(address _from, address _to, uint256 _amount) external
```

### depositToLocal

```solidity
function depositToLocal(address _user_address, address _token, uint256 _amount) external
```

### closeDeposit

```solidity
function closeDeposit(address _user_address, address _token) external
```

## IPoSAdmin

### ChangePoSAddress

```solidity
event ChangePoSAddress(address newPoSAddress)
```

## IStorageToken

### getDepositRate

```solidity
function getDepositRate(uint256 amount) external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address _user) external view returns (uint256)
```

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

## IUserStorage

### ChangeRootHash

```solidity
event ChangeRootHash(address user_address, address node_address, bytes32 new_root_hash)
```

### ChangePoSContract

```solidity
event ChangePoSContract(address PoS_Contract_Address)
```

### ChangePaymentMethod

```solidity
event ChangePaymentMethod(address user_address, address token)
```

### getUserRootHash

```solidity
function getUserRootHash(address _user_address) external view returns (bytes32, uint256)
```

### updateRootHash

```solidity
function updateRootHash(address _user_address, bytes32 _user_root_hash, uint64 _user_storage_size, uint64 _nonce, address _updater) external
```

### updateLastProofTime

```solidity
function updateLastProofTime(address userAddress) external
```

### getPeriodFromLastProof

```solidity
function getPeriodFromLastProof(address userAddress) external view returns (uint256)
```

## IDifficultyManufacturing

### UpdateDifficulty

```solidity
event UpdateDifficulty(uint256 _new_difficulty)
```

## DifficultyManufacturing

### base_difficulty

```solidity
uint256 base_difficulty
```

_Proof period < 1D, base_difficulty++
        Proof period > 1D, base_difficulty--

        Using for 'randomly" proof verification.

        1,000,000 is start value for difficulty_

### upgradingDifficulty

```solidity
uint256 upgradingDifficulty
```

### setDifficulty

```solidity
function setDifficulty(uint256 _new_difficulty) internal
```

### getDifficulty

```solidity
function getDifficulty() public view returns (uint256)
```

### getUpgradingDifficulty

```solidity
function getUpgradingDifficulty() public view returns (uint256)
```

## CryptoProofs

### WrongError

```solidity
event WrongError(bytes32 wrong_hash)
```

### isValidMerkleTreeProof

```solidity
function isValidMerkleTreeProof(bytes32 _root_hash, bytes32[] proof) public pure returns (bool)
```

### isMatchDifficulty

```solidity
function isMatchDifficulty(uint256 base_difficulty, uint256 _proof, uint256 _targetDifficulty) public view returns (bool)
```

### getBlockNumber

```solidity
function getBlockNumber() public view returns (uint32)
```

### getProof

```solidity
function getProof(bytes _file, address _sender, uint256 _block_number) public view returns (bytes, bytes32)
```

### getBlockHash

```solidity
function getBlockHash(uint32 _n) public view returns (bytes32)
```

## StringNumbersConstant

### DECIMALS_18

```solidity
uint256 DECIMALS_18
```

### TIME_7D

```solidity
uint256 TIME_7D
```

### START_DEPOSIT_LIMIT

```solidity
uint256 START_DEPOSIT_LIMIT
```

### MAX_BLOCKS_AFTER_PROOF

```solidity
uint256 MAX_BLOCKS_AFTER_PROOF
```

Max blocks after proof needs to use newest proof as it possible
        For other netowrks it will be:
        @dev
        Expanse ~ 1.5H
        Ethereum ~ 54 min
        Optimistic ~ 54 min
        Ethereum Classic ~ 54 min
        POA Netowrk ~ 20 min
        Kovan Testnet ~ 16 min
        BinanceSmart Chain ~ 12.5 min
        Polygon ~ 8 min
        Avalanche ~ 8 min

### PAIR_TOKEN_START_ADDRESS

```solidity
address PAIR_TOKEN_START_ADDRESS
```

### STORAGE_10GB_IN_MB

```solidity
uint256 STORAGE_10GB_IN_MB
```

## TokenMock

### constructor

```solidity
constructor(string name, string symbol) public
```

### mint

```solidity
function mint(address account, uint256 amount) external
```

### burn

```solidity
function burn(address account, uint256 amount) external
```

## IProofOfStorage

### isValidMerkleTreeProof

```solidity
function isValidMerkleTreeProof(bytes32 _root_hash, bytes32[] _proof) external view returns (bool)
```

### isMatchDifficulty

```solidity
function isMatchDifficulty(uint256 _proof, uint256 _targetDifficulty) external view returns (bool)
```

### getUserRewardInfo

```solidity
function getUserRewardInfo(address _user, uint256 _user_storage_size) external view returns (uint256, uint256)
```

### getUserRootHash

```solidity
function getUserRootHash(address _user) external view returns (bytes32, uint256)
```

