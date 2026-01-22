#!/bin/bash

rm -rf db

edge-mini run --spec ./server.yaml --test --check ./tests
