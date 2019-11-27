#! /usr/bin/env bash

while [[ ${#} -ne 0 ]] && [[ "${1}" != "" ]]; do
    param="${1}"

    case "${param}" in
        "--install-deps" )
            scversion="stable"

            wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
            cp "shellcheck-${scversion}/shellcheck" /usr/bin/

            shellcheck --version
        ;;

        * )
            >&2 echo
            >&2 echo "Unknown param '${param}'."

            exit 1
    esac

    shift
done

shellcheck -x -s bash libs/* tpcp
