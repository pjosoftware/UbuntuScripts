#!/bin/bash
bar_width=40
scripts=()
for script in *.sh; do
  [[ "$script" != "0000_RunAll.sh" ]] && scripts+=("$script")
done

total=${#scripts[@]}
count=0

printf "\033[?1049h"
clear
tput civis

print_bar() {
  local percent=$1
  local script_name=$2
  local filled=$((percent * bar_width / 100))
  local empty=$((bar_width - filled))
  local bar=$(printf "%0.s#" $(seq 1 $filled))
  bar+=$(printf "%0.s-" $(seq 1 $empty))
  printf "\033[1;1H\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %-40s\033[0m" "$bar" "$percent" "$script_name" >&2
  printf "\033[2;1H\033[0;36m%s\033[0m\n" "$(printf '─%.0s' $(seq 1 $(tput cols)))" >&2
}

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))
  print_bar "$percent" "$script"

  if grep -q "read " "$script"; then
    tput cnorm
  fi

  tput cup 3 0
  bash "$script"
  tput civis

  echo ""
done

tput cnorm
printf "\033[?1049l"
echo -e "\033[0;32mAll scripts executed!\033[0m"