#!/bin/bash

# Change to the script's directory
cd "$(dirname "$0")"

# Source the color definitions
source ../colors.sh

# Preprocess all source files and dump output to stdout
for file in $(find . -type f -name "*.c"); do
  echo -e "${CYAN}Preprocessing $file:${RESET}"
  output=$(clang -E -P "$file")
  echo "$output"
  echo ""

  # Check if the MULTIPLIER macro was expanded correctly, but only for function.c
  if [ "$file" == "./function.c" ]; then
    if ! echo "$output" | grep -q "z \*= (3.0);"; then
      echo -e "${RED}Error: MULTIPLIER macro was not expanded correctly in $file${RESET}"
      exit 1
    fi
    echo -e "${GREEN}MULTIPLIER macro was expanded correctly\n"
  fi

  # Generate assembly output in AT&T format
  echo -e "${CYAN}Generating assembly for $file:${RESET}"
  asm_output_file="${file%.c}.s"
  clang -S -mllvm --x86-asm-syntax=att -o "$asm_output_file" "$file"
  cat "$asm_output_file"
  echo ""
done
