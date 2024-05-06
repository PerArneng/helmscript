#!/bin/sh


# Get the absolute directory containing the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# execute wasmtime with the helmster.wasm file and all parameters
"$SCRIPT_DIR/wasmtime" run --dir=. "$SCRIPT_DIR/helmster.wasm" "$@"
