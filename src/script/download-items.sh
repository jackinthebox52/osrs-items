#!/bin/bash
# github.com/jackinthebox52/osrs-items
# Downloads the ItemID.java file from the RuneLite repo and runs the process_item_data.py script


show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo "Downloads and processes RuneLite's ItemID.java into a Go map."
    echo ""
    echo "Options:"
    echo "  --force    Force rewrite of Go file even if no changes detected"
    echo "  --help     Display this help message"
    exit 0
}

# Increment minor version
increment_version() {
    if [ ! -f VERSION ]; then
        echo "1.0.0" > VERSION
        return
    fi
    version=$(cat VERSION)
    major=$(echo $version | cut -d. -f1)
    minor=$(echo $version | cut -d. -f2)
    patch=$(echo $version | cut -d. -f3)
    minor=$((minor + 1))
    echo "$major.$minor.$patch" > VERSION
    echo "Version incremented to $(cat VERSION)"
}

FORCE=false
for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            echo "Unknown argument: $arg"
            show_help
            ;;
    esac
done

# Setup cache directory
CACHE_DIR="${HOME}/.cache/osrs-items"
mkdir -p "$CACHE_DIR"
PREV_FILE="${CACHE_DIR}/previousItemIDs.java"
NEW_FILE="${CACHE_DIR}/newItemIDs.java"

echo "Downloading ItemID.java from RuneLite."


curl -s -o "$NEW_FILE" https://raw.githubusercontent.com/runelite/runelite/master/runelite-api/src/main/java/net/runelite/api/ItemID.java

# Check if previous file exists and compare, unless --force is used
if [ -f "$PREV_FILE" ] && [ "$FORCE" = false ]; then
    if diff -q "$PREV_FILE" "$NEW_FILE" >/dev/null; then
        echo "No changes detected in ItemID.java, exiting."
        rm "$NEW_FILE"
        exit 0
    fi     
    echo "Changes detected in ItemID.java, processing updates."
    increment_version
else
    echo "Disregarding cached ItemID.java, processing updates."
fi

mv "$NEW_FILE" "$PREV_FILE"


mkdir -p data
GO_FILE="data/itemid.go"

rm -f "$GO_FILE"

# Create new file with initial content
cat > "$GO_FILE" << EOL
package data

import "github.com/yourusername/osrs-items/internal/bimap"

// Items is the global bidirectional map of OSRS items
var Items = bimap.New()

func init() {
EOL

# Process the Java file and generate Go initialization code
# Process the Java file and generate Go initialization code
grep "public static final int" "$PREV_FILE" | while read -r line; do
    # Extract the name and ID using sed
    name=$(echo "$line" | sed -E 's/.*int ([A-Z0-9_]+) = ([0-9]+);.*/\1/')
    id=$(echo "$line" | sed -E 's/.*int ([A-Z0-9_]+) = ([0-9]+);.*/\2/')
    
    # Write the initialization with the raw name
    echo "    Items.Set($id, \"$name\")" >> "$GO_FILE"
done

# Close the init function with explicit newline
echo -e "}\n" >> "$GO_FILE"

echo "Data processing complete!"