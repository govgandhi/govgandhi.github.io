#!/bin/bash

# Publish to Blog Script
# Publishes a markdown file from Obsidian (or anywhere) to the blog
#
# Usage:
#   1. Double-click to browse your Obsidian vault
#   2. Drag a .md file onto this script
#   3. Run from terminal: ./Publish\ to\ Blog.command /path/to/post.md

cd "$(dirname "$0")"

BLOG_DIR="writing"
POSTS_DIR="$BLOG_DIR/posts"
POSTS_JSON="$BLOG_DIR/posts.json"
OBSIDIAN_VAULT="/Users/fjb5wj/Documents/Smaug's Lair"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================="
echo "       Blog Post Publisher"
echo "========================================="
echo ""

# Get the markdown file path
if [ -n "$1" ]; then
    MD_FILE="$1"
else
    # Check if Obsidian vault exists
    if [ -d "$OBSIDIAN_VAULT" ]; then
        echo -e "${BLUE}Obsidian Vault detected!${NC}"
        echo ""
        echo "Recent markdown files:"
        echo "----------------------------------------"

        # List markdown files sorted by modification time (newest first)
        # Store in array for selection
        i=1
        declare -a FILES
        while IFS= read -r file; do
            FILES[$i]="$file"
            # Get just the filename for display
            basename_file=$(basename "$file")
            # Get modification date
            mod_date=$(stat -f "%Sm" -t "%Y-%m-%d" "$file" 2>/dev/null || date -r "$file" +"%Y-%m-%d" 2>/dev/null)
            echo -e "  ${GREEN}[$i]${NC} $basename_file ${YELLOW}($mod_date)${NC}"
            ((i++))
            if [ $i -gt 10 ]; then
                break
            fi
        done < <(find "$OBSIDIAN_VAULT" -maxdepth 2 -name "*.md" -type f ! -path "*/.obsidian/*" -print0 | xargs -0 ls -t 2>/dev/null)

        echo "----------------------------------------"
        echo ""
        echo -e "Enter a number to select, or ${YELLOW}[p]${NC} for custom path:"
        read -r SELECTION

        if [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ -n "${FILES[$SELECTION]}" ]; then
            MD_FILE="${FILES[$SELECTION]}"
        elif [[ "$SELECTION" == "p" ]] || [[ "$SELECTION" == "P" ]]; then
            echo ""
            echo "Enter the path to your markdown file:"
            echo "(You can drag and drop the file here)"
            read -r MD_FILE
        else
            echo -e "${RED}Invalid selection${NC}"
            echo ""
            echo "Press any key to exit..."
            read -n 1
            exit 1
        fi
    else
        echo "Enter the path to your markdown file:"
        echo "(You can drag and drop the file here)"
        echo ""
        read -r MD_FILE
    fi
fi

# Remove quotes if present (from drag and drop)
MD_FILE=$(echo "$MD_FILE" | sed "s/^'//" | sed "s/'$//" | sed 's/^ *//' | sed 's/ *$//')

# Validate file exists
if [ ! -f "$MD_FILE" ]; then
    echo -e "${RED}Error: File not found: $MD_FILE${NC}"
    echo ""
    echo "Press any key to exit..."
    read -n 1
    exit 1
fi

# Validate it's a markdown file
if [[ ! "$MD_FILE" == *.md ]]; then
    echo -e "${RED}Error: File must be a markdown (.md) file${NC}"
    echo ""
    echo "Press any key to exit..."
    read -n 1
    exit 1
fi

# Get filename
FILENAME=$(basename "$MD_FILE")

# Convert filename to URL-safe version (lowercase, replace spaces with hyphens)
SAFE_FILENAME=$(echo "$FILENAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

echo -e "File: ${GREEN}$FILENAME${NC}"
echo ""

# Extract title from first # heading in the file
TITLE=$(grep -m 1 "^# " "$MD_FILE" | sed 's/^# //')
if [ -z "$TITLE" ]; then
    # Use filename without extension as fallback
    TITLE=$(basename "$FILENAME" .md)
fi

echo "Detected title: $TITLE"
echo ""
echo "Enter a new title (or press Enter to keep):"
read -r NEW_TITLE
if [ -n "$NEW_TITLE" ]; then
    TITLE="$NEW_TITLE"
fi

# Get excerpt
echo ""
echo "Enter a short excerpt/description (optional, press Enter to skip):"
read -r EXCERPT

# Get date (default to today)
TODAY=$(date +%Y-%m-%d)
echo ""
echo "Enter date (YYYY-MM-DD) or press Enter for today ($TODAY):"
read -r POST_DATE
if [ -z "$POST_DATE" ]; then
    POST_DATE="$TODAY"
fi

# Copy file to posts directory
echo ""
echo -e "${YELLOW}Copying file to $POSTS_DIR/$SAFE_FILENAME...${NC}"
cp "$MD_FILE" "$POSTS_DIR/$SAFE_FILENAME"

# Update posts.json
echo -e "${YELLOW}Updating posts.json...${NC}"

# Create the JSON entry
if [ -n "$EXCERPT" ]; then
    NEW_ENTRY=$(cat <<EOF
{
    "title": "$TITLE",
    "date": "$POST_DATE",
    "file": "$SAFE_FILENAME",
    "excerpt": "$EXCERPT"
  }
EOF
)
else
    NEW_ENTRY=$(cat <<EOF
{
    "title": "$TITLE",
    "date": "$POST_DATE",
    "file": "$SAFE_FILENAME"
  }
EOF
)
fi

# Check if posts.json exists and has content
if [ -f "$POSTS_JSON" ] && [ -s "$POSTS_JSON" ]; then
    # Check if this file already exists in posts.json
    if grep -q "\"file\": \"$SAFE_FILENAME\"" "$POSTS_JSON"; then
        echo -e "${YELLOW}Post already exists, updating...${NC}"
        # Remove the old entry and add the new one
        # This is a simple approach - for complex cases, use jq
        python3 -c "
import json
with open('$POSTS_JSON', 'r') as f:
    posts = json.load(f)
posts = [p for p in posts if p.get('file') != '$SAFE_FILENAME']
new_post = {'title': '''$TITLE''', 'date': '$POST_DATE', 'file': '$SAFE_FILENAME'}
if '''$EXCERPT''':
    new_post['excerpt'] = '''$EXCERPT'''
posts.append(new_post)
posts.sort(key=lambda x: x['date'], reverse=True)
with open('$POSTS_JSON', 'w') as f:
    json.dump(posts, f, indent=2)
"
    else
        # Add new entry
        python3 -c "
import json
with open('$POSTS_JSON', 'r') as f:
    posts = json.load(f)
new_post = {'title': '''$TITLE''', 'date': '$POST_DATE', 'file': '$SAFE_FILENAME'}
if '''$EXCERPT''':
    new_post['excerpt'] = '''$EXCERPT'''
posts.append(new_post)
posts.sort(key=lambda x: x['date'], reverse=True)
with open('$POSTS_JSON', 'w') as f:
    json.dump(posts, f, indent=2)
"
    fi
else
    # Create new posts.json
    python3 -c "
import json
new_post = {'title': '''$TITLE''', 'date': '$POST_DATE', 'file': '$SAFE_FILENAME'}
if '''$EXCERPT''':
    new_post['excerpt'] = '''$EXCERPT'''
with open('$POSTS_JSON', 'w') as f:
    json.dump([new_post], f, indent=2)
"
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Post published successfully!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Title: $TITLE"
echo "Date: $POST_DATE"
echo "File: $SAFE_FILENAME"
echo ""
echo "Your post will be visible at:"
echo "  blog/post.html?p=$SAFE_FILENAME"
echo ""
echo "Don't forget to commit and push your changes!"
echo ""
echo "Press any key to exit..."
read -n 1
