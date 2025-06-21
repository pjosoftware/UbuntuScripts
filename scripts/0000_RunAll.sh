#!/bin/bash
sudo apt install tmux
SESSION=script_runner
BAR_HEIGHT=3
bar_width=40

# Exit cleanly on Ctrl+C
trap 'tput cnorm; tmux kill-session -t "$SESSION" 2>/dev/null; echo -e "\n\033[0;31mInterrupted.\033[0m"; exit 130' SIGINT

scripts=()
for f in *.sh; do
  [[ "$f" != "0000_RunAll.sh" ]] && scripts+=("$f")
done
total=${#scripts[@]}
count=0

tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"

tmux split-window -v -t "$SESSION" -p $((100 - BAR_HEIGHT))   # bottom: logs
BAR_PANE=0
LOG_PANE=1

cols=$(tput cols)
tmux send-keys -t "$SESSION:$BAR_PANE" "clear; tput civis; printf '\033[2;1H\033[0;36m%s\033[0m' \"$(printf '─%.0s' $(seq 1 "$cols"))\"" Enter

for script in "${scripts[@]}"; do
  ((count++))
  percent=$((count * 100 / total))
  filled=$((percent * bar_width / 100))
  empty=$((bar_width - filled))
  bar="$(printf '#%.0s' $(seq 1 $filled))$(printf '-%.0s' $(seq 1 $empty))"

  tmux send-keys -t "$SESSION:$BAR_PANE" \
    "tput cup 0 0; printf '\033[0;36mProgress: [%-${bar_width}s] %3d%% - Running: %s\033[0m'" \
    "$bar" "$percent" "$script" Enter

  if grep -q "read " "$script"; then
    tmux send-keys -t "$SESSION:$BAR_PANE" "tput cnorm" Enter
  fi

  tmux send-keys -t "$SESSION:$LOG_PANE" "clear; echo '\$ bash $script'; bash '$script'; echo -e '\n✔ Done: $script'; read -p ''" Enter
  tmux wait-for "step-$count" 2>/dev/null  # Optional if you want to sync

done

tmux send-keys -t "$SESSION:$BAR_PANE" "tput cup 0 0; echo -e '\033[0;32mAll scripts executed!\033[0m'; tput cnorm" Enter
tmux attach-session -t "$SESSION"