var Web3 = require('web3');

module.exports = {
  networks: {
    node_1: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[KALEIDO_RPC_ENDPOINT]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "",
      gasPrice: 0,
      gas: 4500000
    },
    node_2: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[KALEIDO_RPC_ENDPOINT]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "",
      gasPrice: 0,
      gas: 4500000
    },
    node_3: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[KALEIDO_RPC_ENDPOINT]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "",
      gasPrice: 0,
      gas: 4500000
    },
    node_4: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://[KALEIDO_RPC_ENDPOINT]', 0, '[USERNAME]', '[PASSWORD]');
      },
      network_id: "",
      gasPrice: 0,
      gas: 4500000
    }
  }
};
