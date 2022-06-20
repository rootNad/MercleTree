// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;


contract MercleTree {
    bytes32[] public hashes;


    constructor(string[] memory transactions) {
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint count = transactions.length;
        uint offset = 0;

        while(count > 0) {
            for(uint i = 0; i < count - 1; i += 2) {
                hashes.push(keccak256(
                    abi.encodePacked(
                        hashes[offset + i], hashes[offset + i + 1]
                    )
                ));
            }
            offset += count;
            count = count / 2;
        }
    }

    function verify(string calldata transaction, uint index, bytes32 root, bytes32[] calldata proof) external pure returns(bool) {

        bytes32 hash = keccak256(abi.encodePacked(transaction));
        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index = index / 2;
        }
        return hash == root;
    }
} 


