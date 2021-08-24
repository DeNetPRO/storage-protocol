# Storage Protocol

Storage Protocol made by DeNet Team.


[![Build Status](https://github.com/denetpro/storage-protocol/workflows/CI/badge.svg)](https://github.com/denetpro/storage-protocol/actions)
[![Coverage Status](https://coveralls.io/repos/github/denetpro/storage-protocol/badge.svg?branch=to-deploy)](https://coveralls.io/github/denetpro/storage-protocol/?branch=to-deploy)


Storage protocol consist of two dependent applications - storage node, and ProofOfStorage validation algorithm.. The ProofOfStorage contract is the core feature that allows you to build decentralized storage on top of any EVM.

## Main features of PoS contract

> Proof Of Storage contract helps nodes and clients achieve consensus and auto-scalability without 100% uptime from client side. But the node must always be online.

- No fees
- No scaling limit
- No need to create your own blockchain
- No system-requirements for creating proof 
- Works with any EVM 
- Support any ERC20 tokens for payments
- Gas limit of one proof lower than usual token swap.

## Dev Statuses

|Contract|Current Network|Status
|---|---|---|
|UserStorage|[Kovan Testnet](https://kovan.etherscan.io/address/0x6C5eb19854A80037C7E911128CFF13E81841A40F#events)|beta
|Payments|[Kovan Testnet](https://kovan.etherscan.io/address/0xA260B0aD50fB996cEffa614bAb75846E06991622#events)|beta
|ProofOfStorage|[Kovan Testnet](https://kovan.etherscan.io/address/0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B)|alpha

## Problem

> Need to made consensus algorithm that works next conditionals

- Minimum system requirements
- Minimum blockchain using
- Infinity scalability 
- Decentralized 
- ZeroKnowlage Proofs (no sending full file for proof, or no using third-party)
- Proving files without any metadata storing in blockchain
- The complexity of the security of your own blockchain

## Step By Step create and verify proof

> Node can prove data without third side.

1. Load MerkleTree from user *FS*
2. Select any file from user *FS*
3. Make proof for selected file and one of 100 latest blocks
4. Verify proof % base_diff < selected user difficulty
5. Send proof on Smart Contract and get reward

*user FS - user filesystem merkletree of selected user.*

> proof = f(MerkleTree8kb, RHFS, nonce, digsig) (returns sha256(node address + file + blockhash)
> user difficulty = (selected block number).sub(last proof block number for this user)
> base_diff = constanta or dynamicly updatable number
> reward = min((1/365 x days from last proof), 7) x deposited amount


## Contracts Info

Name|Description|Network|Address|Updated
|---|---|---|---|---|
|UserStorage|contract for storing last version of storage root hash and emit data about updater for nodes uppdate|Kovan|[0x6C5eb19854A80037C7E911128CFF13E81841A40F](https://kovan.etherscan.io/address/0x6C5eb19854A80037C7E911128CFF13E81841A40F)|May-26-2021 
|Payments|contract for make local transfers for rewarding for PoS actions|Kovan|[0xA260B0aD50fB996cEffa614bAb75846E06991622](https://kovan.etherscan.io/address/0xA260B0aD50fB996cEffa614bAb75846E06991622)|Jul-02-2021
|ProofOfStorage|Main contract for getting reward by ProofOfStorage|Kovan|[0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B](https://kovan.etherscan.io/address/0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B)|May-22-2021
|DFILE Testnet Token|Ready to Use|Kovan|[0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848](https://kovan.etherscan.io/address/0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848)|May-21-2021

### User Storage

Contract for storing last version of storage root hash and emit data about updater for nodes uppdate, calling only from ProofOfStorage.

Available methods:

- updateRootHash (call from PoS, if updated user root hash from valid proof or signature)
- updateLastBlockNumber (call from PoS, if valid proof)
- setUserPlan (call from PoS, if updated Token for payments)


### Payments

Contract for make local transfers for rewarding for PoS actions, calling only from ProofOfStorage.

Available methods:

- localTransferFrom (call from PoS if valid proof)
- depositToLocal (deposit funds from other token, call from PoS if deposit)
- closeDeposit (withdraw funds, call from PoS if closing deposit)

### ProofOfStorage

Main contract for getting reward by ProofOfStorage.

Available methods:

- makeDeposit (deposit reward for storage)
- closeDeposit (withdraw rewards)
- sendProof (Send proof from node)
- sendProofFrom (Send proof for other node)
- getUserRewardInfo (Returns info about user reward for ProofOfStorage)
- getUserRootHash (get last uploaded user root hash)


![image](https://user-images.githubusercontent.com/9944728/130633580-071a0333-bb7b-4381-b8fc-6d386cb4154a.png)

More about PoS will available [in docs](/docs/digital%20paper.pdf)

## Benchmarks

 **Est Gas Amount to send proof**
 
|Part Size|Gas|TX|Save on blockchain|
|---|---|---|---|
|8kb|163,969 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xeeac74efd55becef0c70d4f0e599d37c43a848bcf2fbd6527f356e1e21282607)|No|
|16kb|300,038 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xf48703c458954ba0e4609f18dce721a24a003db68565a9f354472e4edf687113)|No|
|16kb|10,581,008 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xcdca6a4c3b8db736a4c75925255423bdffeddd4b12c38f3e68caa5b083c8f7fe)|Yes|
 
![image](https://user-images.githubusercontent.com/9944728/130641639-c150d81b-2090-4945-8949-82a2d8a5ffaf.png)
