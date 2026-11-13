#!/bin/sh
# 	Run from anywhere in the repo:
#   tools/modularize.sh --tag YOUR_TAG
here="$(dirname "$0")"
for py in python3 python; do
	if "$py" -c 'import sys; sys.exit(sys.version_info < (3, 8))' >/dev/null 2>&1; then
		exec "$py" "$here/modular_check/modular_check.py" fix --ask "$@"
	fi
done
exec "$here/bootstrap/python" "$here/modular_check/modular_check.py" fix --ask "$@"
