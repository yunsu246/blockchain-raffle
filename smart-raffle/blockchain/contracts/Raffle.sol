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
    owner = msg.sender;
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
    removeTicket(idx);

    emit TicketDrawn();
  }

  function removeTicket(uint idx) public {
    for (uint i = idx; i + 1 < tickets.length; i++) {
      tickets[i] = tickets[i+1];
    }

    delete tickets[tickets.length - 1];
    tickets.length--;
  }

  function randomTicketIndex() public constant returns (uint) {
    uint idx = random() % tickets.length;
    return idx;
  }

  // Generate a random number using the Linear Congruential Generator algorithm,
  // using the block number as the seed of randomness.
  // The magic numbers `a`, `c` and `m` where taken from the Wikipedia article.
  function random() public constant returns (uint) {
    uint seed = block.number;

    uint a = 1103515245;
    uint c = 12345;
    uint m = 2 ** 32;

    return (a * seed + c) % m;
  }
}
