#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2020-08-22 09:32:49 +0100 (Sat, 22 Aug 2020)
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
Runs a Drone.io CI Runner in Docker
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

check_env_defined "DRONE_SERVER"
check_env_defined "DRONE_RPC_SECRET"

help_usage "$@"

docker run \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=https \
  -e DRONE_RPC_HOST="$DRONE_SERVER" \
  -e DRONE_RPC_SECRET="$DRONE_RPC_SECRET" \
  -e DRONE_RUNNER_CAPACITY=2 \
  -e DRONE_RUNNER_NAME="$HOSTNAME" \
  -p 3000:3000 \
  --restart always \
  --name drone-runner \
  drone/drone-runner-docker:1
