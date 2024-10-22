// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 1 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.conversionRate() >= minimumUsd,
            "You need to spend more ETH!"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        /**
         * How to send ether
         * 1. transfer
         * 2. send
         * 3. call
         */
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Failed to send Ether");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}
