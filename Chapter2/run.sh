#!/bin/bash

# Set the compiler to the value of the CC environment variable or use clang as the default
CC=${CC:-clang}

# Change to the script's directory
cd "$(dirname "$0")" || exit

# Source the color definitions
# shellcheck source=/dev/null
source ../colors.sh

# Initialize an empty array to store object file paths
object_files=()

# Preprocess all source files and dump output to stdout
while IFS= read -r -d '' file; do
  echo -e "${CYAN}Preprocessing $file:${RESET}"
  output=$($CC -E -P "$file")

  # Highlight the line containing "z *= (3.0);"
  echo "$output" | GREP_COLORS="ms=${BRIGHT_WHITE}" grep --color=always -A 1 "z \*= (3.0);\|^"
  echo ""

  # Check if the MULTIPLIER macro was expanded correctly, but only for function.c
  if [ "$file" == "./function.c" ]; then
    if ! echo "$output" | grep -q "z \*= (3.0);"; then
      echo -e "${RED}Error: MULTIPLIER macro was not expanded correctly in $file${RESET}"
      exit 1
    fi
    echo -e "${GREEN}MULTIPLIER macro was expanded correctly\n"
  fi

  # Generate assembly output
  echo -e "${CYAN}Generating assembly for $file:${RESET}"
  asm_output_file="${file%.c}.s"
  $CC -S -arch arm64 -o "$asm_output_file" "$file"
  cat "$asm_output_file"
  echo ""

  # Compile object files
  echo -e "${CYAN}Compiling object file for $file:${RESET}"
  obj_output_file="${file%.c}.o"
  $CC -c -o "$obj_output_file" "$file"

  # Disassemble object files
  echo -e "${CYAN}Disassembling object file for $file:${RESET}"
  objdump -D -r "$obj_output_file" | grep --color=always -A 1 "ARM64_RELOC\|^"
  echo ""

  # Add the object file path to the array
  object_files+=("$obj_output_file")
done < <(find . -type f -name "*.c" -print0)

# Link the object files into an executable called demoApp
echo -e "${CYAN}Linking object files into demoApp:${RESET}"
clang -o demoApp "${object_files[@]}"

# Disassemble the demoApp executable
echo -e "${CYAN}Disassembling demoApp:${RESET}"
objdump -D --section-headers demoApp \
    | grep --color=always -A 1 "0000000100003f04 <_add_and_multiply>:\|^" \
    | grep --color=always -A 1 "0x100003f04 <_add_and_multiply>\|^" \
    | grep --color=always -A 1 "x9, 0x100004000 <_main+0x48>\|^"
objdump --syms demoApp \
    | grep --color=always -A 1 "0000000100004000 g     O __DATA,__common _nCompletionStatus\|^"
echo ""
