#!/bin/sh
# Install Rust toolchain via rustup
if ! command -v cargo >/dev/null 2>&1; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
fi

# Install from crates.io
cargo install --locked scryer-prolog

# Or install from git (latest version)
# cargo install --locked --git https://github.com/mthom/scryer-prolog.git

# Check version
scryer-prolog --version

# Quick test
echo "?- write('Hello, Prolog!'), nl." | scryer-prolog
