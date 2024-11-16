// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.20;

contract LotusBeaconContract {

    // Event emitted when a user registers for an event
    event UserRegistered(
        uint256 indexed eventId,
        uint256 indexed userEventIndex,
        address indexed userAddress
    );

    // EventId => UserAddress => UserEventIndex
    // Example - userEventRegistrations[1][0x1234] = 4
    mapping (uint256 => mapping(address => uint256)) public userEventRegistrations;

    constructor() { }

    // Register for an event
    function registerForEvent(uint256 eventId) public {
        // Get the user's event index
        uint256 userEventIndex = userEventRegistrations[eventId][msg.sender];

        // If the user has not registered for the event, add them
        if (userEventIndex == 0) {
            // Generate a pseudo-random number using keccak256
            userEventIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, eventId))) % 1_000_000_000;
            userEventRegistrations[eventId][msg.sender] = userEventIndex;
        }

        // Emit the UserRegistered event
        emit UserRegistered(eventId, userEventIndex, msg.sender);
    }

    // Get the user's event index for a specific event
    function getUserEventIndex(uint256 eventId, address userAddress) public view returns (uint256) {
        return userEventRegistrations[eventId][userAddress];
    }
    
}