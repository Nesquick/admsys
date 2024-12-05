#!/bin/bash

TARGET_DIR="/etc"

file_count=0

for item in "$TARGET_DIR"/*; do
  if [ -f "$item" ]; then
    file_count=$((file_count + 1))
  fi
done

echo "The number of regular files in $TARGET_DIR is: $file_count"

