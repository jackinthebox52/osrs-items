#!/bin/bash
#Run this script from the root of the project
echo "Updating OSRS item database..."

script/download-items.sh    #TODO check if we need to exit after this call, if it fails

# Review changes
git diff --quiet data/itemid.go
echo "\n\n"

# If changes look good, commit them
git add data/itemid.go
git commit -m "Update item database, version $(cat VERSION)"

# Build package
makepkg -si

