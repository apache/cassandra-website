#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
GO_VERSION="1.23.1"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
PARSER_DIR="/home/build/cassandra-website/cqlprotodoc"
WEBSITE_DIR="/home/build/cassandra-website"

# Step 0: Download and install Go
echo "Downloading Go $GO_VERSION..."
wget https://golang.org/dl/$GO_TAR

echo "Installing Go..."
tar -C /usr/local -xzf $GO_TAR

# Set Go environment variables
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

# Step 1: Building the parser
echo "Building the cqlprotodoc..."
cd "$PARSER_DIR"
go build -o cqlprotodoc

# Step 2: Process the spec files using the parser
echo "Processing the .spec files..."
"$PARSER_DIR"/cqlprotodoc "$WEBSITE_DIR/site-content/source/modules/ROOT/examples/TEXT" "$WEBSITE_DIR/site-content/build/html/_"

# Step 3: Cleanup - Remove the Cassandra and parser directories
echo "Cleaning up..."
rm -rf "$PARSER_DIR/cqlprotodoc" /usr/local/go $GO_TAR

echo "Script completed successfully."
