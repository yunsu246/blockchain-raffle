# 'smart-raffle' 구현하기
Truffle과 Kaleido(RPC)를 이용하여 손쉽게 Smart Contract 구현 및 배포하고 간단한 Dapp 애플리케이션을 구동시켜보는 실습입니다.

&nbsp;
## Part 1: 개발 환경 설정
### 1.1. Install the prerequisites

- NPM : https://nodejs.org
- Truffle : https://github.com/trufflesuite/truffle 
  (※ npm install -g truffle로 설치하세요.)
  
- IDE: (eg. Intelij, Eclipse, WinStorm, Visual Studio etc.)
- (Optional) IDE에 맞는 Solidity 플러그인 추가 
- Metamask : https://metamask.io/


### 1.2. smart-raffle 로컬PC로 받아오기
smart-raffle git 주소: https://github.com/Altoros/smart-raffle.git
```
$ git clone https://github.com/Altoros/smart-raffle.git
$ cd smart-raffle
```

## Part 2: Smart Contract 생성 / 컴파일 및 배포 / 테스트
### 2.1. Smart Contract 작성하기

Migrations.sol 코드를 아래와 같이 수정하세요.
```
$ cd blockchain
$ vi contracts/Migrations.sol
```
```solidity
pragma solidity ^0.4.24;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
```

Raffle.sol 코드를 아래와 같이 수정하세요.
```
$ vi contracts/Raffle.sol
```
```solidity
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
```

### 2.2. Smart Contract 컴파일
```
$ truffle compile
```

✔︎ 다음과 같은 결과가 출력됩니다.
```
Compiling ./contracts/Raffle.sol...
Compiling ./contracts/Migrations.sol...
Writing artifacts to ./build/contracts
```

### 2.3. Kaleido 연결하기 (개발환경)
Smart Contract를 블록체인에 마이그레이션(배포)하기 전에 먼저 truffle.js, package.json을 수정하여 Kaleido와 연결()합니다

truffle.js 코드를 아래와 같이 수정하세요.
```
$ cd ..
$ vi truffle.js
```
```solidity
var Web3 = require('web3');

module.exports = {
networks: {
    node_1: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[NODE_1-RPC-URL]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "*", // Match any network id
      gasPrice: 0,
      gas: 4500000
    },
    node_2: {
      provider: () =>
        return new Web3.providers.HttpProvider('https://[NODE_2-RPC-URL]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "*", // Match any network id
      gasPrice: 0,
      gas: 4500000
    },
    node_3: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[NODE_3-RPC-URL]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "*", // Match any network id
      gasPrice: 0,
      gas: 4500000
    },
    node_4: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[NODE_4-RPC-URL]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "*", // Match any network id
      gasPrice: 0,
      gas: 4500000
    }
  }
};
```

package.json의 dependencies를 아래와 같이 수정하세요.
```
$ vi package.json
```
```solidity
  "dependencies": {
    "dotenv": "^4.0.0",
    "lite-server": "^2.3.0",
    "bignumber.js": "git+https://github.com/frozeman/bignumber.js-nolookahead.git#57692b3ecfc98bbdd6b3a516cb2353652ea49934",
    "crypto-js": "^3.1.8",
    "utf8": "^2.1.2",
    "web3": "^0.20.4",
    "xhr2": "^0.1.4",
    "xmlhttprequest": "^1.8.0"
  }
```

수정된 dependencies를 반영하여 package를 설치해주세요.
```
$ npm install
```

truffle_migrate.sh 코드를 아래와 같이 수정하세요.
```
$ vi truffle_migrate.sh
```
```solidity
#!/bin/bash
truffle migrate --network raffle --reset > /dev/null &
sleep 1
set -x
truffle migrate --network raffle --reset
```

truffle_migrate.sh를 실행합니다.
```
$ ./truffle_migrate.sh
```

✔︎ 다음과 같은 결과가 출력됩니다.
```
+ truffle migrate --network raffle --reset
Compiling ./contracts/Raffle.sol...
Writing artifacts to ./build/contracts

Using network 'raffle'.

Running migration: 1_initial_migration.js
  Replacing Migrations...
  ... 0x14f257a78b1fea0bab56d3d66679ec1d78d1b9971c89c735e4f6776abd9e9cac
  Migrations: 0xfa41a4a9be503d290092021abc11a0b4108d1532
Saving successful migration to network...
  ... 0xcc9990a3ce35844d43470d05623ca228c666500622113aceee47c2338fa5b9f4
Saving artifacts...
Running migration: 1506615515_raffle.js
  Replacing Raffle...
  ... 0x3b0b099b02bfe8156c688ff8af6b04e1ec841984d5186d85df220fe4172b07b0
  Raffle: 0xafd6467fdd7e4cc8ff84bc6ee13800bfcd0105a1
Saving successful migration to network...
  ... 0x497a4365b9983c3d3b20abaa285027769d82ab59689394ead0fffb2a396370e8
Saving artifacts...
```

## Part 3: vue.js를 사용해 FRONT-END 설치/배포
```
cd ../web
```
```
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report
```
