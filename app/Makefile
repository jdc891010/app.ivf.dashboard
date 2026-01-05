# Makefile for IVF Dashboard Flutter App

# Variables
FLUTTER_CMD=flutter
TEST_DIR=test
INTEGRATION_TEST_DIR=integration_test

.PHONY: all test unit widget integration clean coverage help

# Default target
all: test

# Run all tests (Unit + Widget)
test: unit widget

# Run unit tests
unit:
	@echo "Running unit tests..."
	$(FLUTTER_CMD) test $(TEST_DIR)/unit

# Run widget tests
widget:
	@echo "Running widget tests..."
	$(FLUTTER_CMD) test $(TEST_DIR)/widget

# Run integration tests
integration:
	@echo "Running integration tests..."
	$(FLUTTER_CMD) test -d windows $(INTEGRATION_TEST_DIR)

# Run test coverage
coverage:
	@echo "Generating coverage report..."
	$(FLUTTER_CMD) test --coverage
	@echo "Coverage report generated in coverage/lcov.info"

# Clean build artifacts
clean:
	@echo "Cleaning project..."
	$(FLUTTER_CMD) clean
	$(FLUTTER_CMD) pub get

# Help
help:
	@echo "Available commands:"
	@echo "  make test        - Run unit and widget tests"
	@echo "  make unit        - Run unit tests only"
	@echo "  make widget      - Run widget tests only"
	@echo "  make integration - Run integration tests"
	@echo "  make coverage    - Run tests with coverage"
	@echo "  make clean       - Clean project and get dependencies"
