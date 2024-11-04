#!/bin/bash
# Use this script to update the project, then push it to the git repo
# Run this script from the root of the project
echo "Updating OSRS item database..."

# Run the download script
script/download-items.sh

# Check if itemid.go has changed
git diff --quiet lib/data/itemid.go
changes=$?  # Store the exit status

if [ $changes -eq 0 ]; then
    echo "No changes detected in item database. Exiting..."
    exit 0
fi

echo "Changes detected in item database:"
git diff --stat lib/data/itemid.go
echo -e "\n"

# If we got here, there are changes, so commit them
git add lib/data/itemid.go
git commit -m "Update item database, version $(cat VERSION)"

# Build package
makepkg -si