#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

filename="file"

echo -e "${YELLOW}[!]Search executable${NC}"

sudo find . -type f -executable -print

echo -e "${GREEN}[+]Search done${NC}"

echo -e "${YELLOW}[!]For run use:${NC}"
echo export AFL_PATH=~/diplom/AFLplusplus-master/
echo "sudo \$AFL_PATH/afl-fuzz -i input  -o output -- ./executable_file"
echo 'lcov -t "executable_file" -o executable_file.info -c -d .  '
echo "genhtml -o report executable_file.info"

lcov -t "file" -o file.info -c -d . 
genhtml -o report file.info
sudo ./4_translate.py