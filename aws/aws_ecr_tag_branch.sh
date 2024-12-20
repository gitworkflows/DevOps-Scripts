#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: haritest:1.0 stable
#
#  Author: KhulnaSoft Ltd
#  Date: 2021-12-10 11:53:32 +0000 (Fri, 10 Dec 2021)
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
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tags a given AWS ECR docker image:tag with the current branch name without pulling and pushing the docker image


$usage_aws_cli_required


Similar scripts:

    aws_ecr_*.sh - scripts for AWS Elastic Container Registry

    gcr_*.sh - scripts for Google Container Registry
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<image>:<tag> [<aws_cli_options>]"

help_usage "$@"

min_args 1 "$@"

image_tag="$1"
shift || :

if ! [[ "$image_tag" =~ : ]]; then
    image_tag+=":latest"
fi

docker_image="${image_tag%%:*}"
tag="${image_tag##*:}"

# Jenkins provides GIT_BRANCH, TeamCity doesn't so normalize and determine it if not automatically set
if [ -z "${BRANCH_NAME:-}" ]; then
    BRANCH_NAME="${GIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
fi
BRANCH_NAME="${BRANCH_NAME##*/}"

FORCE=1 "$srcdir/aws_ecr_tag_image.sh" "$docker_image:$tag" "$BRANCH_NAME" "$@"
