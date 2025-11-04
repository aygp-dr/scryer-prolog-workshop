# Makefile for Scryer Prolog Workshop
# Handles org-mode file tangling and project setup

.PHONY: all tangle setup clean help install-deps test-deps

# Default target
all: help

# Tangle all org-mode files
tangle:
	@echo "Tangling org-mode files..."
	@for file in *.org; do \
		if [ -f "$$file" ]; then \
			echo "Processing $$file..."; \
			emacs --batch \
				--eval "(require 'org)" \
				--eval "(setq org-confirm-babel-evaluate nil)" \
				--eval "(org-babel-tangle-file \"$$file\")"; \
		fi; \
	done
	@echo "Tangling complete!"

# Tangle a specific org file
tangle-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify FILE=filename.org"; \
		exit 1; \
	fi
	@echo "Tangling $(FILE)..."
	@emacs --batch \
		--eval "(require 'org)" \
		--eval "(setq org-confirm-babel-evaluate nil)" \
		--eval "(org-babel-tangle-file \"$(FILE)\")"

# Setup the Scryer Prolog environment
setup: test-deps tangle
	@echo "Setting up Scryer Prolog environment..."
	@if command -v cargo >/dev/null 2>&1; then \
		echo "Cargo found, checking for scryer-prolog..."; \
		if ! command -v scryer-prolog >/dev/null 2>&1; then \
			echo "Installing scryer-prolog via cargo..."; \
			cargo install --locked scryer-prolog; \
		else \
			echo "scryer-prolog already installed"; \
		fi; \
	else \
		echo "Warning: cargo not found. Please install Rust toolchain from https://rustup.rs"; \
	fi
	@echo "Setup complete!"

# Install dependencies (Emacs and Rust)
install-deps:
	@echo "Checking and installing dependencies..."
	@if command -v pkg >/dev/null 2>&1; then \
		echo "FreeBSD detected, using pkg..."; \
		if ! command -v emacs >/dev/null 2>&1; then \
			echo "Installing emacs..."; \
			sudo pkg install -y emacs; \
		fi; \
		if ! command -v cargo >/dev/null 2>&1; then \
			echo "Installing rust..."; \
			sudo pkg install -y rust; \
		fi; \
	else \
		echo "Please install emacs and rust manually."; \
		echo "Emacs: pkg install emacs (FreeBSD) or your package manager"; \
		echo "Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"; \
	fi

# Test for required dependencies
test-deps:
	@echo "Checking dependencies..."
	@if ! command -v emacs >/dev/null 2>&1; then \
		echo "Error: emacs not found. Install with 'make install-deps' or manually."; \
		exit 1; \
	fi
	@echo "✓ emacs found"
	@if ! command -v cargo >/dev/null 2>&1; then \
		echo "Warning: cargo not found. Rust toolchain needed for Scryer Prolog."; \
		echo "Install from https://rustup.rs or run 'make install-deps'"; \
	else \
		echo "✓ cargo found"; \
	fi

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@find . -name "*.pl" -type f -exec rm -f {} \;
	@find . -name "*~" -type f -exec rm -f {} \;
	@find . -name "*.elc" -type f -exec rm -f {} \;
	@echo "Clean complete!"

# Run Scryer Prolog
run:
	@if command -v scryer-prolog >/dev/null 2>&1; then \
		scryer-prolog; \
	else \
		echo "Error: scryer-prolog not installed. Run 'make setup' first."; \
		exit 1; \
	fi

# Run Scryer Prolog with a specific file
run-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify FILE=filename.pl"; \
		exit 1; \
	fi
	@if command -v scryer-prolog >/dev/null 2>&1; then \
		scryer-prolog $(FILE); \
	else \
		echo "Error: scryer-prolog not installed. Run 'make setup' first."; \
		exit 1; \
	fi

# Display help
help:
	@echo "Scryer Prolog Workshop - Makefile Commands"
	@echo "==========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make help           - Display this help message"
	@echo "  make test-deps      - Test for required dependencies"
	@echo "  make install-deps   - Install required dependencies (emacs, rust)"
	@echo "  make tangle         - Tangle all org-mode files in current directory"
	@echo "  make tangle-file FILE=<file.org> - Tangle a specific org file"
	@echo "  make setup          - Complete setup (tangle + install scryer-prolog)"
	@echo "  make run            - Run Scryer Prolog REPL"
	@echo "  make run-file FILE=<file.pl> - Run Scryer Prolog with a file"
	@echo "  make clean          - Remove generated files"
	@echo ""
	@echo "Example workflow:"
	@echo "  1. make test-deps       # Check what's installed"
	@echo "  2. make install-deps    # Install missing dependencies"
	@echo "  3. make setup          # Setup Scryer Prolog"
	@echo "  4. make tangle         # Tangle org files"
	@echo "  5. make run            # Start Scryer Prolog"
	@echo ""
	@echo "System info: $$(uname -s) $$(uname -r) $$(uname -m)"
