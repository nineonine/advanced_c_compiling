# Compiler and flags
CC := clang
CFLAGS := -Wall -std=c99

# Directories
BUILD := build

# Build targets
.PHONY: all clean Chapter2 Chapter3

all: Chapter2

Chapter2:
	@chmod +x $@/run.sh
	@$@/run.sh

Chapter3:
	@chmod +x $@/run.sh
	@$@/run.sh

# Clean target
clean:
	@echo "Cleaning build artifacts..."
	@find . \( -name "*.o" -o -name "*.s" -o -name "demoApp" -o -name "regularBuild" \) -exec rm -f {} +
	@rm -rf build
