#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2020-09-09 11:37:14 +0100 (Wed, 09 Sep 2020)
#
#  https://github.com/BuildScale/DevOps-Scripts
#
#  License: see accompanying KhulnaSoft Ltd LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/company/khulnasoft
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Kubernetes container images running counts sorted descending across all namespaces

Requires kubectl to be in \$PATH and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

kubectl get pods --all-namespaces --field-selector status.phase=Running -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}' |
sort |
uniq -c |
sort -k1nr
