// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TxVault is Ownable {
    struct StoredTx {
        string txid;        // arbitrary tx id string
        address sender;     // who submitted
        uint256 value;      // wei value attached
        string metadata;    // optional metadata
        uint256 timestamp;  // block timestamp
    }

    StoredTx[] private _txs;

    event TxRecorded(uint256 indexed index, string txid, address indexed sender, uint256 value, string metadata);
    event Withdraw(address indexed to, uint256 amount);

    // allow deposits with a txid and optional metadata
    function deposit(string calldata txid, string calldata metadata) external payable {
        StoredTx memory s = StoredTx({
            txid: txid,
            sender: msg.sender,
            value: msg.value,
            metadata: metadata,
            timestamp: block.timestamp
        });
        _txs.push(s);
        emit TxRecorded(_txs.length - 1, txid, msg.sender, msg.value, metadata);
    }

    function getTxCount() external view returns (uint256) {
        return _txs.length;
    }

    function getTx(uint256 index) external view returns (StoredTx memory) {
        require(index < _txs.length, "Index out of range");
        return _txs[index];
    }

    // owner can withdraw collected ETH
    function withdraw(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "Transfer failed");
        emit Withdraw(to, amount);
    }

    // fallback/receive so plain ETH can be sent
    receive() external payable {}
}+
