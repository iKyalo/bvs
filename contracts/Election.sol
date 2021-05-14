pragma solidity >=0.4.22 < 0.8.0;

contract Election {

    event CandidateAdded(string message, bytes32 name);
    // voted event
    event votedEvent (string message, uint _candidateId);

    bytes32[] names;
    uint[] voteCount;

    // Store accounts that have voted
    mapping(address => bool) public voters;

    constructor () public {
            addName("Mark Kyalo,C,me.jpg");
            addName("Sally Kui,C,lady.jpg");
            addName("Barry Obama,C,obama.webp");
            addName("Peter Griffin,C,fat.jpg");
            addName("NO VOTE,C,novote.jpg");
    }
  
    function addName(string name) public {
        
        names.push(stringToBytes32(name));

        voteCount.push(0);

        emit CandidateAdded("New candidate added!", stringToBytes32(name));
    }

  
    function getNames() public view returns (bytes32[] memory) {
        return names;
    }

    function getResults() public view returns (uint[] memory) {
        return voteCount;
    }

    function findUserVote() public view returns (bool) {
        return voters[msg.sender];
    }

    function vote (uint _candidateId) public {
        // require that the voter hasn't voted yet
        require(!voters[msg.sender]);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate's vote Count
        voteCount[_candidateId] ++;

        // trigger voted event
        emit votedEvent("Vote Placed!", _candidateId);
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

}