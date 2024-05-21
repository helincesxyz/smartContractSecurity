// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SecuredFindThisHash {
    // Struct is used to store the commit details
    struct Commit {
        bytes32 solutionHash;
        uint256 commitTime;
        bool revealed;
    }

    // The hash that is needed to be solved
    bytes32 public hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    // Address of the winner
    address public winner;

    // Price to be rewarded
    uint256 public reward;

    // Status of game
    bool public ended;

    // Mapping to store the commit details with address
    mapping(address => Commit) commits;

    // Modifier to check if the game is active
    modifier gameActive() {
        require(!ended, "Already ended");
        _;
    }

    constructor() payable {
        reward = msg.value;
    }

    /* 
       Commit function to store the hash calculated using keccak256(address in lowercase + solution + secret). 
       Users can only commit once and if the game is active.
    */
    function commitSolution(bytes32 _solutionHash) public gameActive {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime == 0, "Already committed");
        commit.solutionHash = _solutionHash;
        commit.commitTime = block.timestamp;
        commit.revealed = false;
    }

    /* 
        Function to get the commit details. It returns a tuple of (solutionHash, commitTime, revealStatus);  
        Users can get solution only if the game is active and they have committed a solutionHash
    */
    function getMySolution()
        public
        view
        gameActive
        returns (bytes32, uint256, bool)
    {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Not committed yet");
        return (commit.solutionHash, commit.commitTime, commit.revealed);
    }
    /* 
        Function to reveal the commit and get the reward. 
        Users can get reveal solution only if the game is active and they have committed a solutionHash before this block and not revealed yet.
        It generates an keccak256(msg.sender + solution + secret) and checks it with the previously commited hash.  
        Assuming that a commit was already included on chain, front runners will not be able to pass this check since the msg.sender is different.
        Then the actual solution is checked using keccak256(solution), if the solution matches, the winner is declared, 
        the game is ended and the reward amount is sent to the winner.
    */

    function revealSolution(string memory _solution, string memory _secret)
        public
        gameActive
    {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Not committed yet");
        require(
            commit.commitTime < block.timestamp, "Cannot reveal in the same block"
        );
        require(!commit.revealed, "Already commited and revealed");

        bytes32 solutionHash =
            keccak256(abi.encodePacked(msg.sender, _solution, _secret));
        require(solutionHash == commit.solutionHash, "Hash doesn't match");

        require(
            keccak256(abi.encodePacked(_solution)) == hash, "Incorrect answer"
        );

        winner = msg.sender;
        ended = true;

        (bool sent,) = payable(msg.sender).call{value: reward}("");
        if (!sent) {
            winner = address(0);
            ended = false;
            revert("Failed to send ether.");
        }
    }
}