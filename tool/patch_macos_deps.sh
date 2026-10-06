#!/usr/bin/env bash
set -u

echo "Patching macOS dependencies for Xcode 16 / Swift 6 compatibility..."

SEARCH_DIRS=()
if [ -d "$HOME/.pub-cache" ]; then
  SEARCH_DIRS+=("$HOME/.pub-cache")
fi
if [ -d "third_party" ]; then
  SEARCH_DIRS+=("third_party")
fi

if [ ${#SEARCH_DIRS[@]} -gt 0 ]; then
  while IFS= read -r f; do
    if [ -f "$f" ]; then
      echo "Checking $f..."
      if grep -q "class WebAuthenticationSession: NSObject, ASWebAuthenticationPresentationContextProviding" "$f" 2>/dev/null; then
        echo "Patching $f..."
        sed -i '' 's/class WebAuthenticationSession: NSObject, ASWebAuthenticationPresentationContextProviding/class WebAuthenticationSession: NSObject/' "$f" || true
      fi
    fi
  done < <(find "${SEARCH_DIRS[@]}" -name "WebAuthenticationSession.swift" 2>/dev/null || true)
fi

echo "Dependency patching completed successfully."
exit 0
