#!/usr/bin/env bash

set -e
#!/bin/bash

# Get the full path of the script directory
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

# Print the script directory
echo "Script directory: $SCRIPT_DIR"

version=$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].version')
project_name=$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')
wasm_target="wasm32-wasip1"

echo "project_name: $project_name"
echo "version: $version"

echo "building wasm file..."
cargo build --release --target "$wasm_target"

wasmtime_version="v20.0.1"

wasmtime_targets=(
#  "aarch64-linux"
  "aarch64-macos"
#  "riscv64gc-linux"
#  "s390x-linux"
#  "x86_64-linux"
#  "x86_64-macos"
)

base_url="https://github.com/bytecodealliance/wasmtime/releases/download/$wasmtime_version"
packages_dir="target/packages"
output_dir="$packages_dir/temp"
mkdir -p "$output_dir"

for target in "${wasmtime_targets[@]}"; do
  echo "building wasmtime for $target..."

  filename="wasmtime-$wasmtime_version-$target.tar.xz"
  unpacked_dir="$output_dir/wasmtime-$wasmtime_version-$target"
  url="$base_url/$filename"

  echo "downloading $url"
  curl -L "$base_url/$filename" -o "$output_dir/$filename"

  echo "Decompressing $filename"
  tar xvf "$output_dir/$filename" -C "$output_dir"

  echo "Copying wasm file to $unpacked_dir"
  cp "target/$wasm_target/release/$project_name.wasm" "$unpacked_dir"

  echo "Copy helmster.sh to $unpacked_dir"
  cp "$SCRIPT_DIR/helmster.sh" "$unpacked_dir/helmster"

  echo "Crating tarball for $unpacked_dir"
  tar cvfz "$packages_dir/helmster-$version-$target.tar.gz" -C "$unpacked_dir" helmster helmster.wasm wasmtime

done



#wasmtime-v20.0.1-aarch64-linux.tar.xz
#wasmtime-v20.0.1-aarch64-macos.tar.xz
#wasmtime-v20.0.1-riscv64gc-linux.tar.xz
#wasmtime-v20.0.1-s390x-linux.tar.xz
#wasmtime-v20.0.1-x86_64-linux.tar.xz
#wasmtime-v20.0.1-x86_64-macos.tar.xz
#wasmtime-v20.0.1-x86_64-mingw.zip
#wasmtime-v20.0.1-x86_64-windows.zip
