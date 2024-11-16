import { ethers } from "hardhat";
import { expect } from "chai";
import { LotusBeaconContract, LotusBeaconContract__factory } from "../typechain-types";

describe("LotusBeaconContract", function () {
    let lotusBeaconContract: LotusBeaconContract;
    let owner: any;
    let addr1: any;

    beforeEach(async function () {
        const LotusBeaconContractFactory: LotusBeaconContract__factory = await ethers.getContractFactory("LotusBeaconContract");
        [owner, addr1] = await ethers.getSigners();
        lotusBeaconContract = await LotusBeaconContractFactory.deploy();
    });

    it("should register a user for an event", async function () {
        await lotusBeaconContract.connect(addr1).registerForEvent("event1");
        const userEventIndex = await lotusBeaconContract.getUserEventIndex("event1", addr1.address);
        expect(userEventIndex).to.not.equal(0);
    });

    it("should greet another user", async function () {
        await lotusBeaconContract.connect(addr1).registerForEvent("event1");
        const userEventIndex = await lotusBeaconContract.getUserEventIndex("event1", addr1.address);

        const physicalSensingData: LotusBeaconContract.PhysicalSensingDataStruct[] = [
            { RPID: 123, RSSI: 456, transmitPower: 789 },
            { RPID: 124, RSSI: 457, transmitPower: 790 },
            { RPID: 125, RSSI: 458, transmitPower: 791 },
        ];

        await lotusBeaconContract.connect(addr1).greet("event1", userEventIndex, physicalSensingData);
        const greetData = await lotusBeaconContract.greetDataRecords("event1", 0);
        expect(greetData.eventId).to.equal("event1");
        expect(greetData.myUserEventIndex).to.equal(userEventIndex);
        expect(greetData.greetedUserEventIndex).to.equal(userEventIndex);
        expect(greetData.physicalSensingData1.RPID).to.equal(123);
        expect(greetData.physicalSensingData2.RPID).to.equal(124);
        expect(greetData.physicalSensingData3.RPID).to.equal(125);
        expect(greetData.physicalSensingData4.RPID).to.equal(0);
        expect(greetData.physicalSensingData5.RPID).to.equal(0);
    });

    it("should not greet the same user twice", async function () {
        await lotusBeaconContract.connect(addr1).registerForEvent("event1");
        const userEventIndex = await lotusBeaconContract.getUserEventIndex("event1", addr1.address);

        const physicalSensingData: LotusBeaconContract.PhysicalSensingDataStruct[] = [
            { RPID: 123, RSSI: 456, transmitPower: 789 }
        ];

        await lotusBeaconContract.connect(addr1).greet("event1", userEventIndex, physicalSensingData);
        await expect(
            lotusBeaconContract.connect(addr1).greet("event1", userEventIndex, physicalSensingData)
        ).to.be.revertedWith("User already greeted to this user");
    });
});