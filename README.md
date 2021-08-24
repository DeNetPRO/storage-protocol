# Storage Protocol

Storage Protocol made by DFILE Team with support from 1inch network.


[![Build Status](https://github.com/denetpro/storage-protocol/workflows/CI/badge.svg)](https://github.com/denetpro/storage-protocol/actions)
[![Coverage Status](https://coveralls.io/repos/github/denetpro/storage-protocol/badge.svg?branch=to-deploy)](https://coveralls.io/github/denetpro/storage-protocol/?branch=to-deploy)


## Dev Statuses

|Contract|Current Network|Status
|---|---|---|
|UserStorage|[Kovan Testnet](https://kovan.etherscan.io/address/0x6C5eb19854A80037C7E911128CFF13E81841A40F#events)|beta
|Payments|[Kovan Testnet](https://kovan.etherscan.io/address/0xA260B0aD50fB996cEffa614bAb75846E06991622#events)|beta
|ProofOfStorage|[Kovan Testnet](https://kovan.etherscan.io/address/0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B)|alpha


## Contracts Info

Name|Description|Network|Address|Updated
|---|---|---|---|---|
|UserStorage|contract for storing last version of storage root hash and emit data about updater for nodes uppdate|Kovan|[0x6C5eb19854A80037C7E911128CFF13E81841A40F](https://kovan.etherscan.io/address/0x6C5eb19854A80037C7E911128CFF13E81841A40F)|May-26-2021 
|Payments|contract for make local transfers for rewarding for PoS actions|Kovan|[0xA260B0aD50fB996cEffa614bAb75846E06991622](https://kovan.etherscan.io/address/0xA260B0aD50fB996cEffa614bAb75846E06991622)|Jul-02-2021
|ProofOfStorage|Main contract for getting reward by ProofOfStorage|Kovan|[0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B](https://kovan.etherscan.io/address/0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B)|May-22-2021
|DFILE Testnet Token|Ready to Use|Kovan|[0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848](https://kovan.etherscan.io/address/0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848)|May-21-2021

## User Stroage

Contract for storing last version of storage root hash and emit data about updater for nodes uppdate, calling only from ProofOfStorage.

Available methods:

- updateRootHash (call from PoS, if updated user root hash from valid proof or signature)
- updateLastBlockNumber (call from PoS, if valid proof)
- setUserPlan (call from PoS, if updated Token for payments)


## Payments

Contract for make local transfers for rewarding for PoS actions, calling only from ProofOfStorage.

Available methods:

- localTransferFrom (call from PoS if valid proof)
- depositToLocal (deposit funds from other token, call from PoS if deposit)
- closeDeposit (withdraw funds, call from PoS if closing deposit)

## ProofOfStorage

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

 **Est Gas Amount to saving and updating storage root hash**
 
![image](https://user-images.githubusercontent.com/9944728/130641639-c150d81b-2090-4945-8949-82a2d8a5ffaf.png)

## WIP 

 **ProofOfStorage.sol**

- VDF (not using)
