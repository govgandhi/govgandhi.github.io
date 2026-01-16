#!/bin/bash
cd "$(dirname "$0")"

# Kill any existing process on port 8000
lsof -ti:8000 | xargs kill -9 2>/dev/null

echo "Starting live-reload server..."
echo ""
echo "Open in browser: http://localhost:8000"
echo ""
echo "Press Ctrl+C to stop the server when done."
echo ""

# Open browser after a short delay, then start server
(sleep 1 && open "http://localhost:8000") &
livereload -p 8000 .
