#!/usr/bin/env bash
# https://raw.githubusercontent.com/andrewsardone/dotfiles/master/bin/auto-git-repo-sync
# Usage: ./auto-git-repo-sync /path/to/git/repo/to/sync
#
# Liberally commit a git repository and push it to a remote repo in a
# rebase’ing fashion. This is useful for synchronizing a git repo via a cron
# job.
#
# Example `crontab -e` entry:
# */5 * * * * ~/bin/auto-git-repo-sync /Volumes/Notes >/dev/null 2>&1

if [ "$#" -ne 1 ]; then
    SCRIPT_NAME=$(basename "$0")
    echo "Usage: $SCRIPT_NAME /path/to/git/repo/to/sync"
    echo "Example: $SCRIPT_NAME /home/notes-repo"
    exit 1
fi

NOTES_PATH="$1"
cd "$NOTES_PATH"

CHANGES_EXIST="$(git status --porcelain | wc -l)"
if [ "$CHANGES_EXIST" -eq 0 ]; then
  exit 0
fi

git add .
git commit -q \
  --author "Automatic Sync <automatic-sync@example.com>" \
  -m "Automatic Sync $(date +"%Y-%m-%d %H:%M:%S")" \
  -m "$(git status --porcelain)"
