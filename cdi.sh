#!/bin/bash

cdi () {
    path_regex='\(.*/\)*'
    arg_idx=0

    for arg in "$@"; do
        arg_idx=$(( arg_idx + 1 ))

        if [[ "$arg" == "." ]]; then
            continue
        fi
        if (( arg_idx < $# )); then
            path_regex+="$arg/\(.*/\)*"
        else
            path_regex+="$arg"
        fi
    done

    found=false
    while read path; do
        echo -n "$path (y?): "
        read yn <&1

        if [[ 'y' == "$yn" ]]; then
            cd "$path"
            found=true
            break
        fi
    done < <(find -mindepth 1 -name '.*' -prune -o -type d -iregex "$path_regex" -print)

    if ! $found; then
        echo 'No further matches.'
    fi
}
