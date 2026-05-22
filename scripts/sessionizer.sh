#!/usr/bin/bash

selected=$(find ~/Dev ~/ ~/.config ~/Dev/os -mindepth 1 -maxdepth 1 -type d | \
    sed "s|^$HOME/||" | \
    fzf
)

selected="$HOME/$selected"

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected 
    # select first window
    tmux select-window -t $selected_name:0
fi

tmux switch-client -t $selected_name
