#!/bin/bash
scripts=()
for script in *.sh; do
  [[ "$script" != "0000_RunAll.sh" ]] && scripts+=("$script")
done

total=${#scripts[@]}
count=0
bar_width=40
interrupted=false

trap 'interrupted=true; tput cnorm; echo -e "\n\n\033[0;31mInterrupted by user. Halting...\033[0m"; exit 130' SIGINT

print_bar() {
  local percent=$1
  local script_name=$2
  local filled=$((percent * bar_width / 100))
  local empty=$((bar_width - filled))
  local bar=$(printf "%0.s#" $(seq 1 $filled))
  bar+=$(printf "%0.s-" $(seq 1 $empty))
  printf "\r\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %s\033[0m" "$bar" "$percent" "$script_name"
}

clear
tput civis

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))

  print_bar "$percent" "$script"
  echo -e "\n\033[0;36m───────────────────────────────────────────────────────────\033[0m"

  if grep -q "read " "$script"; then
    tput cnorm
  fi

  bash "$script"
  status=$?

  tput civis

  if $interrupted; then break; fi

  if [[ $status -ne 0 ]]; then
    echo -e "\033[0;31m$script exited with code $status\033[0m"
  else
    echo -e "\033[0;32m✔ Finished $script\033[0m"
  fi

  echo ""
done

tput cnorm
echo -e "\n\033[0;32mAll scripts completed or halted.\033[0m"