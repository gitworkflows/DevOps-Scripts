#!/usr/bin/env osascript
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2022-02-28 13:05:26 +0000 (Mon, 28 Feb 2022)
#
#  https://github.com/BuildScale/DevOps-Scripts
#
#  License: see accompanying KhulnaSoft Ltd LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/company/khulnasoft
#

tell application "System Events"
    set frontmostProcess to first process where it is frontmost
    name of frontmostProcess
end tell
