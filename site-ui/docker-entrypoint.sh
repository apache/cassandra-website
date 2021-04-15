#!/bin/bash

# Abort script if a command fails
set -e

GREEN='\033[1;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

if [ ! -d "node_modules" ]
then
  echo
  echo -e "${YELLOW}The node_modules directory is missing and we need it to render the UI.${NC}"
  echo -e "${YELLOW}I'll run a once off install of the required modules. This will take a few minutes to complete.${NC}"
  echo

  # Install node modules
  npm install

  echo -e -n "${GREEN}Install complete!${NC}"
fi

exec gulp "$@"