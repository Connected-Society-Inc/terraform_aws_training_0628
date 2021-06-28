#!/bin/bash
# Needed: graphviz
# on WSL: sudo apt-get install graphviz
terraform graph | dot -Tsvg > graph.svg
