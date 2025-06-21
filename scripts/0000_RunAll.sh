#!/bin/bash

for script in *.sh; do
  if [[ "$script" != "0000_RunAll.sh" ]]; then
    echo "Running $script..."
    bash "$script"
  fi
done

