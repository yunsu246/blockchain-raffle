#!/bin/bash
truffle migrate --network node_1 --reset > /dev/null &
sleep 1
set -x
truffle migrate --network node_1 --reset
