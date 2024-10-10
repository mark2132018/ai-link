// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

contract AILink {
    // address > round > hash
    mapping(address => mapping(uint256 => string)) private localModelHashes;

    mapping(uint256 => string) private globalModelHashes;

    event LocalModelSubmitted(address indexed client, string modelHash, uint256 round);

    event GlobalModelSubmitted(string modelHash, uint256 round);

    function submitLocalModelHash(string memory _modelHash, uint256 _round) public {
        localModelHashes[msg.sender][_round] = _modelHash;
        emit LocalModelSubmitted(msg.sender, _modelHash, _round);
    }

    function submitGlobalModelHash(string memory _modelHash, uint256 _round) public {
        globalModelHashes[_round] = _modelHash;
        emit GlobalModelSubmitted(_modelHash, _round);
    }

    function getLocalModelHashAtRound(address _client, uint256 _round) public view returns (string memory) {
        string memory hash = localModelHashes[_client][_round];
        require(bytes(hash).length > 0, "Model hash not found for the given round.");
        return hash;
    }

    function getGlobalModelHash(uint256 _round) public view returns (string memory) {
        string memory hash = globalModelHashes[_round];
        require(bytes(hash).length > 0, "Global model hash not found for the given round.");
        return hash;
    }
}
