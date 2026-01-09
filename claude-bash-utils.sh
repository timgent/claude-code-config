#!/bin/bash

# Worktree utility function
# Creates a new git worktree with copied dependencies from .worktreeinclude
wt() {
  if [ -z "$1" ]; then
    echo "Usage: wt <branch-name>"
    return 1
  fi

  local BRANCH=$1
  local MAIN_DIR=$(git rev-parse --show-toplevel 2>/dev/null)

  if [ -z "$MAIN_DIR" ]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local WORKTREE_DIR="$MAIN_DIR/trees/$BRANCH"
  local WORKTREE_INCLUDE_FILE="$MAIN_DIR/.worktreeinclude"

  echo "Creating worktree for branch: $BRANCH"
  echo "Main directory: $MAIN_DIR"
  echo "Worktree directory: $WORKTREE_DIR"

  # Create trees directory if it doesn't exist
  mkdir -p "$MAIN_DIR/trees"

  # Check if branch exists
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "Branch $BRANCH exists, checking it out..."
    git worktree add "$WORKTREE_DIR" "$BRANCH"
  else
    echo "Branch $BRANCH doesn't exist, creating it..."
    git worktree add -b "$BRANCH" "$WORKTREE_DIR"
  fi

  # Check if .worktreeinclude exists
  if [ ! -f "$WORKTREE_INCLUDE_FILE" ]; then
    echo "Warning: .worktreeinclude file not found, no files copied"
    cd "$WORKTREE_DIR"
    return 0
  fi

  # Read .worktreeinclude and copy directories/files
  echo "Copying files from .worktreeinclude..."
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    if [ -z "$line" ]; then
      continue
    fi

    local SOURCE="$MAIN_DIR/$line"
    local TARGET="$WORKTREE_DIR/$line"

    if [ -e "$SOURCE" ]; then
      echo "  Copying $line..."
      cp -r "$SOURCE" "$TARGET"
    else
      echo "  Warning: $line does not exist in main directory, skipping"
    fi
  done <"$WORKTREE_INCLUDE_FILE"

  echo ""
  echo "Worktree created successfully!"

  cd "$WORKTREE_DIR"
}
