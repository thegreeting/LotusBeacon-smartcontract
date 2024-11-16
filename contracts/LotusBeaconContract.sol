// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.20;

contract LotusBeaconContract {

    struct PhysicalSensingData {
        // Random Peripheral ID
        uint256 RPID; 
        // Received Signal Strength Indicator
        uint256 RSSI; 
        // Sender's Transmit Power
        uint256 transmitPower; 
    }

    struct GreetData {
        string eventId; // updated from uint256 to string
        uint256 myUserEventIndex;
        uint256 greetedUserEventIndex;
        // PhysicalSensingData should be an array, but unfortunaltely nested array is not supported in Solidity, so it's needed to be flatten.
        PhysicalSensingData physicalSensingData1;
        PhysicalSensingData physicalSensingData2;
        PhysicalSensingData physicalSensingData3;
        PhysicalSensingData physicalSensingData4;
        PhysicalSensingData physicalSensingData5;
    }

    // Event emitted when a user registers for an event
    event UserRegistered(
        string indexed eventId,
        uint256 indexed userEventIndex,
        address indexed userAddress
    );

    event Greeted(
        string indexed eventId,
        uint256 indexed greetedUserEventIndex,
        uint256 indexed myUserEventIndex
    );

    // EventId => UserAddress => UserEventIndex
    // Example - userEventRegistrations[1][0x1234] = 4
    mapping (string => mapping(address => uint256)) public userEventRegistrations;

    // EventId => UserEventIndex => GreetedUserEventIndex => boolean
    // Example - isUserGreetedTo[1][4][5] = true
    mapping (string => mapping(uint256 => mapping (uint256 => bool))) public isUserGreetedTo;

    // EventId => GreetData[]
    mapping (string => GreetData[]) public greetDataRecords;

    // constructor
    // as of now, do nothing here.
    constructor() { }


    function greet(string memory eventId, uint256 greetedUserEventIndex, PhysicalSensingData[] calldata physicalSensingData) public {

        require(greetedUserEventIndex != 0, "greetedUserEventIndex cannot be 0");

        // Get the user's event index
        // TODO: Remove this line for demonstration purposes
        uint256 myUserEventIndex = userEventRegistrations[eventId][msg.sender];
        require(myUserEventIndex != 0, "User not registered for the event");

        // Check if the user has already greeted to this user
        require(!isUserGreetedTo[eventId][myUserEventIndex][greetedUserEventIndex], "User already greeted to this user");
        isUserGreetedTo[eventId][myUserEventIndex][greetedUserEventIndex] = true;

        // Save the greet data
        GreetData storage newGreetData = greetDataRecords[eventId].push();
        newGreetData.eventId = eventId;
        newGreetData.myUserEventIndex = myUserEventIndex;
        newGreetData.greetedUserEventIndex = greetedUserEventIndex;

        // Copy PhysicalSensingData from calldata to storage
        for (uint256 i = 0; i < physicalSensingData.length; i++) {
            if (i == 0) {
                newGreetData.physicalSensingData1 = physicalSensingData[i];
            } else if (i == 1) {
                newGreetData.physicalSensingData2 = physicalSensingData[i];
            } else if (i == 2) {
                newGreetData.physicalSensingData3 = physicalSensingData[i];
            } else if (i == 3) {
                newGreetData.physicalSensingData4 = physicalSensingData[i];
            } else if (i == 4) {
                newGreetData.physicalSensingData5 = physicalSensingData[i];
            }
        }

        // Emit the UserRegistered event
        emit Greeted(eventId, greetedUserEventIndex, myUserEventIndex);
    }


    // Register for an event
    function registerForEvent(string memory eventId) public {
        // Get the user's event index
        uint256 userEventIndex = userEventRegistrations[eventId][msg.sender];

        // If the user has not registered for the event, add them
        if (userEventIndex == 0) {
            // Generate a pseudo-random number using keccak256
            userEventIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, eventId))) % 100; // Obviously, 100 is not enough, but for the better recongnication in the Hackathon judgement, intentionally the number was set to a small one.
            userEventRegistrations[eventId][msg.sender] = userEventIndex;
    
            // Emit the UserRegistered event
            emit UserRegistered(eventId, userEventIndex, msg.sender);
        }

    }

    // Get the user's event index for a specific event
    function getUserEventIndex(string memory eventId, address userAddress) public view returns (uint256) {
        return userEventRegistrations[eventId][userAddress];
    }
    
}