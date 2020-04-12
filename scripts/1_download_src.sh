#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

filename="evince"

echo -e "${YELLOW}[!]Start download${NC}"
apt-get build-dep $filename
apt source $filename
rm *.tar.*
rm *.dsc
echo -e "${GREEN}[+]Download complete${NC}"
cd ${filename}*
./configure

sudo ../2_edit_Make.py
make
../3_build_and_find_x.sh