#!/bin/bash
scripts=()
for script in *.sh; do
  [[ "$script" != "0000_RunAll.sh" ]] && scripts+=("$script")
done

total=${#scripts[@]}
count=0
bar_width=40

trap 'tput cnorm; echo -e "\n\n\033[0;31mInterrupted by user.\033[0m"; exit 130' SIGINT

clear
tput civis
tput cup 0 0
echo -ne "\033[0;36mProgress: [$(printf -- '-%.0s' $(seq 1 $bar_width))]   0%\033[0m"

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))
  filled=$((percent * bar_width / 100))
  empty=$((bar_width - filled))
  bar="$(printf '#%.0s' $(seq 1 $filled))$(printf -- '-%.0s' $(seq 1 $empty))"

  tput cup 0 0
  printf "\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %-40s\033[0m" "$bar" "$percent" "$script"

  if grep -q "read " "$script"; then
    tput cnorm
  fi

  tput cup 2 0
  bash "$script"
  tput civis

  echo ""
done

tput cnorm
echo -e "\n\033[0;32mAll scripts executed!\033[0m"