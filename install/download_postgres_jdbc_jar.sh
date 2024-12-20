#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2020-11-27 14:21:49 +0000 (Fri, 27 Nov 2020)
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
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Quickly determines and downloads latest PostgreSQL JDBC jar or an explicitly given version

Useful to get the jar to upload to data integration 3rd party directories or Docker images or Kubernetes

Version defaults to 'latest' in which case it determines the latest version from GitHub releases
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

#version="${1:-42.2.18}"
version="${1:-latest}"

github_owner_repo="pgjdbc/pgjdbc"

"$srcdir/../github/github_download_release_jar.sh" "https://github.com/$github_owner_repo/releases/download/REL{version}/postgresql-{version}.jar" "$version"
