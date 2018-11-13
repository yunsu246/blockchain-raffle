#!/bin/bash
truffle migrate --network raffle --reset > /dev/null &
sleep 1
set -x
truffle migrate --network raffle --reset
