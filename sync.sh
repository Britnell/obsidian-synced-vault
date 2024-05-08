#!/bin/bash

log_file="sync.log"
counter_file=".counter"

# args

if [ "$#" -lt 2 ]; then
    echo "Usage: sync.sh <branch_name> <modulo_push_every_x_commits> <optional_'log'_flag> "
    exit 1
fi

script_dir=$(dirname "$0")
branch_name="$1"
modulo="$2"
log_flag="$3"

# functions

setup(){
    cd "$script_dir"
    current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
    git_commit_msg="obsidian cron sync - $current_datetime"

    if [[ "$log_flag" == "log"  ]];then 
        exec >> ./$log_file 2>&1
    fi
    echo -e "\n [$current_datetime] - running $branch_name $modulo $log_flag "
    
    if ! [[ "$modulo" -gt 0 ]]; then
        echo " modulo must be positive int "
        exit 1
    fi
}


func_counter(){
    if [ -f "$counter_file" ]; then
        RUN_COUNT=$(cat "$counter_file")
    else
        RUN_COUNT=0
    fi
    RUN_COUNT=$((RUN_COUNT + 1))
    echo "$RUN_COUNT" > "$counter_file"
    echo "$RUN_COUNT"
}

check_git(){
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Current directory is not a Git repository."
        exit 0
    fi
    git checkout "$branch_name" --quiet
}

commit_changes(){
    if ! [ -z "$(git status --porcelain)" ]; then
        echo "commit changes"
        git add .
        git commit -m "$git_commit_msg" --quiet
    fi
}

push_on_modulo(){
    count=$(func_counter)
    if [ $((count % modulo)) -eq 0 ]; then
        if [ $( git log --oneline @{u}..@  | wc -l ) -gt 0 ]; then 
            echo "push to origin"
            git push origin "$branch_name" --quiet
        fi
    fi
}

# main

setup

check_git

commit_changes

push_on_modulo
