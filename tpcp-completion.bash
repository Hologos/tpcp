#! /usr/bin/env bash

function _tpcp_completions() {
    local actions=( "CPY" "ADD" "IMP" "DEL" )

    local word action_index

    for word in "${COMP_WORDS[@]}"; do
        for action_index in "${!actions[@]}"; do
            if [[ "${actions[${action_index}]}" == "${word^^}" ]]; then
                unset 'actions[action_index]'
            fi
        done
    done

    if [[ ${#actions[@]} -eq 0 ]]; then
        return
    fi

    mapfile -t COMPREPLY < <(compgen -W "${actions[*]}" -- "${COMP_WORDS[-1]^^}")
}

complete -F _tpcp_completions tpcp
