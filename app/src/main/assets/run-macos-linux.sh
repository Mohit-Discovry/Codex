#!/usr/bin/env bash
# ==============================================================================
# AetherStudio Elite - macOS & Linux Standalone Launcher
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_FILE="$DIR/index.html"

echo "🎨 Launching AetherStudio Elite (Cyberpunk Drawing Studio)..."

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS: Try Google Chrome or Brave or Edge app mode, else open in default browser
  if [ -d "/Applications/Google Chrome.app" ]; then
    open -na "Google Chrome" --args --app="file://$HTML_FILE"
  elif [ -d "/Applications/Microsoft Edge.app" ]; then
    open -na "Microsoft Edge" --args --app="file://$HTML_FILE"
  else
    open "$HTML_FILE"
  fi
else
  # Linux: Try google-chrome or chromium app mode, else xdg-open
  if command -v google-chrome &> /dev/null; then
    google-chrome --app="file://$HTML_FILE" &
  elif command -v chromium &> /dev/null; then
    chromium --app="file://$HTML_FILE" &
  elif command -v xdg-open &> /dev/null; then
    xdg-open "$HTML_FILE" &
  else
    echo "Please open $HTML_FILE in your web browser."
  fi
fi
