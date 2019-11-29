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

echo
echo "Testing scripts with shellcheck"
echo

for shellcheck_test_file in tpcp tpcp-completion.bash libs/*; do
    shellcheck -x -s bash "${shellcheck_test_file}" \
        && echo "  |  ok  | no errors detected in ${shellcheck_test_file}" \
        || echo "  | fail | errors detected in ${shellcheck_test_file}"
done
