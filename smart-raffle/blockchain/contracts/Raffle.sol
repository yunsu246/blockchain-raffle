pragma solidity ^0.4.24;


contract Raffle {
  struct Ticket {
    string fullname;
    string email;
  }

 // State
  address public owner;
  string public ownerName;

  Ticket[] public tickets;
  Ticket[] public drawnTickets;

  event TicketBought();
  event TicketDrawn();

  constructor(string _name) public {
    owner = msg.sender; //or specific owner account from metamask
    ownerName = _name;
  }

  // Sell a ticket. Validate that the email associated to the buyer doesn't have a ticket already
  function buyTicket(string fullname, string email) public {
    bool exists = false;
    for (uint i = 0; !exists && i < tickets.length; i++) {
      Ticket memory ticket = tickets[i];

      if (keccak256(abi.encodePacked(email)) == keccak256(abi.encodePacked(ticket.email))) {
        exists = true;
      }
    }

    if (!exists) {
      Ticket memory newTicket = Ticket(fullname, email);
      tickets.push(newTicket);
      emit TicketBought();
    }
  }

  function currentWinner() public constant returns (string fullname) {
    require(drawnTickets.length > 0);
    return drawnTickets[drawnTickets.length - 1].fullname;
  }

  function size() public constant returns (uint) {
    return tickets.length;
  }

  function drawnSize() public constant returns (uint) {
    return drawnTickets.length;
  }

  function drawTicket() public {
    require(msg.sender == owner);

    uint idx = randomTicketIndex();
    drawnTickets.push(tickets[idx]);
    removeTicket();

    emit TicketDrawn();
  }

  function removeTicket() public {
    for (uint i = 0; i < tickets.length; i++) {
        delete tickets[tickets.length - (i+1)];
    }
    tickets.length = 0;
  }

  function randomTicketIndex() constant public returns (uint) {
    uint idx = random() % tickets.length;
    return idx;
  }

  function random() constant public returns (uint) {
    uint seed = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, block.number)));
    return seed;
  }
}
