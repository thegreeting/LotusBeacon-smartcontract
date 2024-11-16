# LotusBeacon - Smart Contract

## Useful command

**To compile**

```sh
npx hardhat compile
```

**To test**

```sh
npx hardhat test ./test/LotusBeaconContract.test.ts
```

**To deploy**

```sh
npx hardhat ignition deploy ./ignition/modules/LotusBeaconContract.ts --network sepolia
```

You can switch the destination network by passing the network name followed by `--network`.


**To verify the contract on Explorer**

```sh
npx hardhat ignition verify chain-11155111 # For Sepolia
```

before type command, make sure that `ETHERSCAN_API_KEY` is set in the `.env`