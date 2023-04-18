#!/bin/bash

# Set the compiler to the value of the CC environment variable or use clang as the default
CC=${CC:-clang}

# Change to the script's directory
cd "$(dirname "$0")" || exit

# Source the color definitions
# shellcheck source=/dev/null
source ../colors.sh

EXE_NAME=regularBuild

echo -e "${CYAN}Building main.cpp${RESET}"
$CC main.cpp -o $EXE_NAME

# Disassemble the executable
echo -e "${CYAN}Disassembling executable:${RESET}"
objdump -D $EXE_NAME \
    | grep --color=always -A 1 "0x100003000 <_main+0x20>\|^"
