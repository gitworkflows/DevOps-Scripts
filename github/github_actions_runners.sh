#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2020-02-12 16:21:52 +0000 (Wed, 12 Feb 2020)
#
#  https://github.com/BuildScale/DevOps-Scripts
#
#  License: see accompanying KhulnaSoft Ltd LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/company/khulnasoft
#

# https://docs.github.com/en/rest/reference/actions#create-a-registration-token-for-an-organization
#
# https://docs.github.com/en/rest/reference/actions#create-a-registration-token-for-a-repository

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GitHub Actions self-hosted runners for the given Repo or Organization via the GitHub API

Output Format:

<id>    <online/offline>    <busy_boolean>    <os>    <name>    <label1,label2...>

See Also:

    github_actions_runner.sh - generates a token and launches a runner for a GitHub Organization or Repo

    https://github.com/BuildScale/Kubernetes-configs - for running GitHub Actions Runners in Kubernetes
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo_or_organization>"

help_usage "$@"

min_args 1 "$@"

repo_or_org="$1"
shift

if [[ "$repo_or_org" =~ / ]]; then
    prefix="repos"
else # it's an org
    prefix="orgs"
fi
"$srcdir/github_api.sh" "/$prefix/$repo_or_org/actions/runners" |
jq -r '.runners[] | [.id, .status, .busy, .os, .name, ([.labels[].name]|join(",")) ] | @tsv' |
sort -n |
column -t
