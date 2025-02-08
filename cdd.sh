#!/bin/bash

# Installation: Write this to a file. In your .bash_profile,
# `source path/to/file'. `cd' can run in a subshell, but it won't affect the
# parent shell. Source `cdd' as a function that the parent shell runs directly.

# Usage: `cdd foo bar baz' will change the shell's current directory to the
# first directory matching regex `(.*/)*/foo/(.*/)*/bar/(.*/)*/baz'
# or first directory matching glob `**/foo/**/bar/**/baz' where `**' can be
# empty. First directory is whatever `find' finds that does not contain
# anything hidden.
#
# E.g.
# $ cdd cglib
# Changing to directory: `./Documents/c/cglib'
# $ cd ~
# $ cdd Documents templates
# > Changing to directory: `./Documents/c/cglib/templates'

cdd () {
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

    found_path=$(find -mindepth 1 -name '.*' -prune -o -type d -iregex "$path_regex" -print -quit)

    if [[ -z "$found_path" ]]; then
        echo "Could not find a path matching \`$path_regex'."
    else
        echo "Changing to directory: \`$found_path'"
        cd "$found_path"
    fi
}
