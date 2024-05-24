// SPDX-License-Identifier: NUST
pragma solidity ^0.8.0;

contract ElectionContract {
    struct Voter {
        string name;
        string voterID;
        string partyName;
    }

    uint public totalVotes = 0;

    string[] private partyNames;

    constructor() {
        partyNames = new string[](0); // Initialize empty array
    }

    mapping(string => Voter) private voters;
    mapping(string => uint) private voteCounts;

    function addVote(string memory _name, string memory _voterID, string memory _partyName) public {
        require(!exists(_voterID), "Voter ID already exists.");
        voters[_voterID] = Voter(_name, _voterID, _partyName);
        voteCounts[_partyName]++;
        totalVotes = totalVotes + 1;
        if (!containsPartyName(partyNames, _partyName)) { // Check if party name is not already in the array
            partyNames.push(_partyName); // Add party name to the array
        }
    }

    function checkId(string memory _voterID) public view returns (bool) {
        return exists(_voterID);
    }

    function voterInfo(string memory _voterID) public view returns (string memory, string memory, string memory) {
        require(exists(_voterID), "Voter ID does not exist.");
        Voter memory voter = voters[_voterID];
        return (voter.name, voter.voterID, voter.partyName);
    }

    function exists(string memory _voterID) private view returns (bool) {
    Voter memory defaultVoter = Voter("", "", "");
    Voter memory voter = voters[_voterID];

    if (keccak256(abi.encodePacked(voter.name)) == keccak256(abi.encodePacked(defaultVoter.name))) {
        return false;
      } else {
        return true;
      }
    }

    function containsPartyName(string[] memory _array, string memory _partyName) private pure returns (bool) {
        for (uint i = 0; i < _array.length; i++) {
            if (keccak256(abi.encodePacked(_array[i])) == keccak256(abi.encodePacked(_partyName))) {
                return true;
            }
        }
        return false;
    }

    struct VoteResult {
        string partyName;
        uint voteCount;
    }

    function voteCount() public view returns (VoteResult[] memory) {
        VoteResult[] memory results = new VoteResult[](partyNames.length);

        for (uint i = 0; i < partyNames.length; i++) {
            results[i].partyName = partyNames[i];
            results[i].voteCount = voteCounts[partyNames[i]];
        }

        return results;
    }
}

