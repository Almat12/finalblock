// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Staking {
    // State variables
    address public owner;
    uint public stakingPeriod;
    uint public totalRewards;
    mapping(address => uint) public userBalances;
    mapping(address => uint) public stakedBalances;
    mapping(address => uint) public stakingStartTimes;
    address[] public stakedUsers;

    // Constructor
    constructor(uint _stakingPeriod, uint _totalRewards) {
        owner = msg.sender;
        stakingPeriod = _stakingPeriod;
        totalRewards = _totalRewards;
    }

    // Stake function
    function stake(uint _amount) public {
        // Validate inputs
        require(_amount > 0, "Staked amount must be greater than zero");
        require(userBalances[msg.sender] >= _amount, "Insufficient balance");

        // Update user balances
        userBalances[msg.sender] -= _amount;
        stakedBalances[msg.sender] += _amount;
        stakingStartTimes[msg.sender] = block.timestamp;

        // Add user to stakedUsers if not already present
        if (stakingStartTimes[msg.sender] > 0) {
            stakedUsers.push(msg.sender);
        }
    }

    // Calculate rewards function
    function calculateRewards(address _user) public view returns (uint) {
        // Retrieve staking details
        uint stakedAmount = stakedBalances[_user];
        uint startTime = stakingStartTimes[_user];
        uint currentTime = block.timestamp;

        // Check for invalid scenarios
        if (startTime == 0 || currentTime < startTime + stakingPeriod) {
            return 0;
        }

        // Calculate rewards based on staking duration
        uint timeStaked = currentTime - startTime;
        return (stakedAmount * timeStaked) / stakingPeriod;
    }

    // Distribute rewards function
    function distributeRewards() public {
        // Validate access
        require(msg.sender == owner, "Only the owner can distribute rewards");
        require(totalRewards > 0, "No rewards to distribute");

        // Loop through staked users and distribute rewards
        for (uint i = 0; i < stakedUsers.length; i++) {
            address user = stakedUsers[i];
            uint rewards = calculateRewards(user);

            // Update balances and total rewards
            userBalances[user] += rewards;
            totalRewards -= rewards;
            stakedBalances[user] = 0;
            stakingStartTimes[user] = 0;
        }

        // Clear stakedUsers array
        delete stakedUsers;
    }

    // Withdraw function
    function withdraw() public {
        // Retrieve staked and reward amounts
        uint stakedAmount = stakedBalances[msg.sender];
        uint rewards = calculateRewards(msg.sender);
        uint totalAmount = stakedAmount + rewards;

        // Validate and update balances
        require(totalAmount > 0, "No funds to withdraw");
        stakedBalances[msg.sender] = 0;
        stakingStartTimes[msg.sender] = 0;
        userBalances[msg.sender] += totalAmount;
    }
}
