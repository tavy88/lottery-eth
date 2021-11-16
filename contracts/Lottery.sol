pragma solidity ^0.4.25;

contract Lottery {
    address public manager;
    address payable[] public players;
    
    constructor() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether );
        
        players.push(payable(msg.sender));
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function returnWinner() private view returns(address) {
        uint index = random() % players.length;
        
        return players[index];
    }
    
    function pickWinner() public payable restricted {
        uint index = random() % players.length;
        
        players[index].transfer(address(this).balance);
        
        players = new address payable[](0);
    }
    
    function allPlayers() public view returns(address payable[] memory) {
        return players;
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
 }