# Storage Protocol

Storage Protocol made by DFILE Team with support from 1inch network.

## Dev Statuses

|Contract|Current Network|Status
|---|---|---|
|UserStorage|Kovan Testnet|pre-beta
|Payments|Kovan Testnet|pre-beta
|ProofOfStorage|WIP|beta


## Contracts Info

Name|Description|Network|Address|
|---|---|---|---|
|UserStorage|contract for storing last version of storage root hash and emit data about updater for nodes uppdate|Kovan|0x9be9d2adbfbd631b3c344d225ad4b13ffdf8d9a5
|Payments|contract for make local transfers for rewarding for PoS actions|Kovan|0x814c424F99B39BA7D5AF62274022253a9a8df1C4
|ProofOfStorage|Main contract for getting reward by ProofOfStorage|Kovan|0x2E8630780A231E8bCf12Ba1172bEB9055deEBF8B
|DFILE Testnet Token|Ready to Use|Kovan|0x0d3C95079Ff0B4cf055a65EF4b63BbB047456848
|dUSDC Testnet Token [need to update]||Kovan|0xeCcc839f3D03357be443D072660dbe307da0608C

## Benchmarks

 **Est Gas Amount to send proof**
 
|Part Size|Gas|TX|Save on blockchain|
|---|---|---|---|
|8kb|163,969 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xeeac74efd55becef0c70d4f0e599d37c43a848bcf2fbd6527f356e1e21282607)|No|
|16kb|300,038 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xf48703c458954ba0e4609f18dce721a24a003db68565a9f354472e4edf687113)|No|
|16kb|10,581,008 gas|[Kovan Testnet](https://kovan.etherscan.io/tx/0xcdca6a4c3b8db736a4c75925255423bdffeddd4b12c38f3e68caa5b083c8f7fe)|Yes|

 **Est Gas Amount to saving and updating storage root hash**

|op type|Gas|
|---|---|
|First Set|41,974 gas|
|Update|26,974 gas|


## WIP 

 **ProofOfStorage.sol**

- VDF (not using)
