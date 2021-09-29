pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Multicall is Ownable {
    struct Call {
        address target;
        bytes callData;
    }

    function aggregate(Call[] memory calls)
        public
        onlyOwner
        returns (uint256 blockNumber, bytes[] memory returnData)
    {
        blockNumber = block.number;
        returnData = new bytes[](calls.length);
        for (uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(
                calls[i].callData
            );
            require(success);
            returnData[i] = ret;
        }
    }

    function call(address target, bytes memory callData)
        public
        onlyOwner
        returns (bytes memory)
    {
        (bool success, bytes memory ret) = target.call(callData);
        require(success);
        return ret;
    }

    // Helper functions
    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }

    function getBlockHash(uint256 blockNumber)
        public
        view
        returns (bytes32 blockHash)
    {
        blockHash = blockhash(blockNumber);
    }

    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }

    function getCurrentBlockTimestamp()
        public
        view
        returns (uint256 timestamp)
    {
        timestamp = block.timestamp;
    }

    function getCurrentBlockDifficulty()
        public
        view
        returns (uint256 difficulty)
    {
        difficulty = block.difficulty;
    }

    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }

    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }
}
