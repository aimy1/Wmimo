#!/usr/bin/env bash
set -u

echo "Patching Apple (macOS & iOS) dependencies for Xcode 16 / Swift 6 compatibility..."

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
      python3 -c "
import sys
p = '$f'
try:
    with open(p, 'r', encoding='utf-8') as fp:
        c = fp.read()
    orig = c
    # Fix 1: Ensure presentationAnchor satisfies @objc protocol requirement
    if 'func presentationAnchor(for session: ASWebAuthenticationSession)' in c and '@objc public func presentationAnchor' not in c:
        c = c.replace('public func presentationAnchor(for session: ASWebAuthenticationSession)', '@objc public func presentationAnchor(for session: ASWebAuthenticationSession)')
    
    # Fix 2: macOS class conformance separation if present in pub cache
    if 'class WebAuthenticationSession: NSObject, ASWebAuthenticationPresentationContextProviding' in c:
        c = c.replace('class WebAuthenticationSession: NSObject, ASWebAuthenticationPresentationContextProviding', 'class WebAuthenticationSession: NSObject')

    if c != orig:
        with open(p, 'w', encoding='utf-8') as fp:
            fp.write(c)
        print('  -> Successfully patched: ' + p)
except Exception as e:
    print('  -> Patch exception: ' + str(e))
" || true
    fi
  done < <(find "${SEARCH_DIRS[@]}" -name "WebAuthenticationSession.swift" 2>/dev/null || true)
fi

echo "Dependency patching completed successfully."
exit 0
