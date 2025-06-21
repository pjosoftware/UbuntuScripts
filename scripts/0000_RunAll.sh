#!/bin/bash
scripts=()
for script in *.sh; do
  [[ "$script" != "0000_RunAll.sh" ]] && scripts+=("$script")
done

total=${#scripts[@]}
count=0
bar_width=40

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))
  filled=$((percent * bar_width / 100))
  empty=$((bar_width - filled))
  bar=$(printf "%0.s#" $(seq 1 $filled))
  bar+=$(printf "%0.s-" $(seq 1 $empty))

  printf "\r\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %s\033[0m" "$bar" "$percent" "$script"

  bash "$script"
done

echo -e "\n\033[0;32mAll scripts executed!\033[0m"