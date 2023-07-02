//SPDX-License-Identifier: MIT

//1. deploy mocks when we are on a local anvil chain
//2. keep track of contract address across different chains
// sepolia ETH/USD
// mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";


contract HelperConfig is Script{
    //If we are on local, deploy mock
    //otherwise, grab the address from the live network
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }    
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
    NetworkConfig memory sepoliaConfig = NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepoliaConfig;
}

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //price feed address

        // deploy mock contract
        // return the mock address

        if(activeNetworkConfig.priceFeed != address(0)){
           return activeNetworkConfig;
        }
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed= new MockV3Aggregator(
        DECIMALS,
        INITIAL_PRICE
    );
    vm.stopBroadcast();
    NetworkConfig memory anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
    });
    return anvilConfig;

}
}