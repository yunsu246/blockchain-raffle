var Web3 = require('web3');

module.exports = {
networks: {
    raffle: {
      provider: () => {
        return new Web3.providers.HttpProvider('https://k0fw2h1vn1-k0nopjik6e-rpc.ap-northeast-2.kaleido.io', 0, 'k0za9ikbqb', 'Bb8ZvVDqBMBvYqXQE2MRXcV3pRvLEuEpzLprOf_sgtc');
      },
      network_id: "*",
      gasPrice: 0,
      gas: 4500000
    }
  }
};
