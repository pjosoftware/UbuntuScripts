#!/bin/bash

printf "\033[?1049h"
clear
tput civis

scripts=()
for script in *.sh; do
  [[ "$script" != "0000_RunAll.sh" ]] && scripts+=("$script")
done

total=${#scripts[@]}
count=0
bar_width=40

printf "\033[1;1H\033[0;36mProgress: [%-${bar_width}s]   0%%\033[0m\n" "$(printf -- '-%.0s' $(seq 1 $bar_width))"

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))
  filled=$((percent * bar_width / 100))
  empty=$((bar_width - filled))
  bar=$(printf "%0.s#" $(seq 1 $filled))
  bar+=$(printf "%0.s-" $(seq 1 $empty))

  printf "\033[1;1H\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %-40s\033[0m\n" "$bar" "$percent" "$script"

  # if grep -q "read " "$script"; then
  #   tput cnorm
  # fi

  bash "$script"
  # tput civis
done

tput cnorm
printf "\033[?1049l"
echo -e "\033[0;32mAll scripts executed!\033[0m"