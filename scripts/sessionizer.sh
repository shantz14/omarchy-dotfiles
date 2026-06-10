#!/usr/bin/bash

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find ~/Dev ~/ ~/.config ~/Dev/os -mindepth 1 -maxdepth 1 -type d | \
        sed "s|^$HOME/||" | \
        sort -u | \
        fzf
    )
    [[ -n $selected ]] && selected="$HOME/$selected"
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr '. ' '__')

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
