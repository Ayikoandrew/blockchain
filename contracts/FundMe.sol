// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        
        require(msg.value.conversionRate() => minimumUsd, "You need to spend more ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() {
        for (uint256 funderIndex = 0; uint256 funderIndex < funders.length; uint256 funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new adddress[](0);
    }

    constructor() {}
}
