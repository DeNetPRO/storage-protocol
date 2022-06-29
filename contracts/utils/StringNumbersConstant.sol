pragma solidity ^0.8.0;

contract StringNumbersConstant {

   uint public constant DECIMALS_18 = 10e18;
   uint public constant TIME_7D = 60*60*24*7;
   uint public constant START_DEPOSIT_LIMIT = DECIMALS_18 * 100; // 100 DAI
  
   /**

        @notice Max blocks after proof needs to use newest proof as it possible
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
   */
   uint public constant MAX_BLOCKS_AFTER_PROOF = 256;

   /*
      Polygon Network Settigns
   */
   address public constant PAIR_TOKEN_START_ADDRESS = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063; // DAI in Polygon
   uint public constant STORAGE_10GB_IN_MB = 10240; // 10 GB;

}