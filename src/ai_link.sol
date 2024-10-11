// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.3;

contract AILink {
    address public admin;
    address public server;
    mapping(address => bool) private registeredClients;

    // address > round > hash
    mapping(address => mapping(uint256 => string)) private localModelHashes;
    mapping(uint256 => string) private globalModelHashes;

    // Events
    event LocalModelSubmitted(address indexed client, string modelHash, uint256 round);
    event GlobalModelSubmitted(string modelHash, uint256 round);
    event ClientRegistered(address indexed client);
    event ClientDeregistered(address indexed client);
    event ServerUpdated(address indexed newServer);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Access restricted to the admin.");
        _;
    }

    modifier onlyServer() {
        require(msg.sender == server, "Access restricted to the server.");
        _;
    }

    modifier onlyRegisteredClient() {
        require(registeredClients[msg.sender], "Access restricted to registered clients.");
        _;
    }

    modifier isValidSha256(string memory _modelHash) {
        require(bytes(_modelHash).length == 64, "Invalid SHA-256 hash length.");
        _;
    }

    // Constructor
    constructor(address _admin, address _server) {
        admin = _admin;
        server = _server;
    }

    // Functions
    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "New admin cannot be the zero address.");
        emit AdminTransferred(admin, _newAdmin);
        admin = _newAdmin;
    }

    function updateServer(address _newServer) public onlyAdmin {
        require(_newServer != address(0), "Server cannot be the zero address.");
        server = _newServer;
        emit ServerUpdated(_newServer);
    }

    function registerClient(address _client) public onlyAdmin {
        require(!registeredClients[_client], "Client is already registered.");
        registeredClients[_client] = true;
        emit ClientRegistered(_client);
    }

    function deregisterClient(address _client) public onlyAdmin {
        require(registeredClients[_client], "Client is not registered.");
        registeredClients[_client] = false;
        emit ClientDeregistered(_client);
    }

    function submitLocalModelHash(string memory _modelHash, uint256 _round) public onlyRegisteredClient isValidSha256(_modelHash) {
        localModelHashes[msg.sender][_round] = _modelHash;
        emit LocalModelSubmitted(msg.sender, _modelHash, _round);
    }

    function submitGlobalModelHash(string memory _modelHash, uint256 _round) public onlyServer isValidSha256(_modelHash) {
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
