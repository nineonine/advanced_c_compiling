#!/bin/bash

# Set the compiler to the value of the CC environment variable or use clang as the default
CC=${CC:-clang}

# Change to the script's directory
cd "$(dirname "$0")" || exit

# Source the color definitions
# shellcheck source=/dev/null
source ../colors.sh

DEFAULT_LIB=defaultvisibility
CONTROLLED_LIB=controlledvisibility

echo -e "${CYAN}Building libdefaultvisibility.dylib${RESET}"
$CC -dynamiclib -fPIC -o lib$DEFAULT_LIB.dylib $DEFAULT_LIB.c

echo -e "${CYAN}libdefaultvisibility.dylib symbols${RESET}"
nm -gU lib$DEFAULT_LIB.dylib | tee /dev/tty | wc -l

echo -e "${CYAN}Building libcontrolledvisibility.dylib${RESET}"
$CC -dynamiclib -fPIC -fvisibility=hidden -fvisibility-inlines-hidden -o lib$CONTROLLED_LIB.dylib $CONTROLLED_LIB.c

echo -e "${CYAN}libcontrolledvisibility.dylib symbols${RESET}"
nm -gU lib$CONTROLLED_LIB.dylib | tee /dev/tty | wc -l
