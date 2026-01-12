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

  local REPO_NAME=$(basename "$MAIN_DIR")
  local PARENT_DIR=$(dirname "$MAIN_DIR")
  local WORKTREE_DIR="$PARENT_DIR/trees/$REPO_NAME/$BRANCH"
  local WORKTREE_INCLUDE_FILE="$MAIN_DIR/.worktreeinclude"

  echo "Creating worktree for branch: $BRANCH"
  echo "Main directory: $MAIN_DIR"
  echo "Worktree directory: $WORKTREE_DIR"

  # Create trees directory if it doesn't exist (sibling to repo)
  mkdir -p "$PARENT_DIR/trees/$REPO_NAME"

  # Check if branch exists locally or remotely
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "Local branch $BRANCH exists, checking it out..."
    git worktree add "$WORKTREE_DIR" "$BRANCH"
  elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
    echo "Remote branch origin/$BRANCH exists, creating local tracking branch..."
    git worktree add --track -b "$BRANCH" "$WORKTREE_DIR" "origin/$BRANCH"
  else
    echo "Branch $BRANCH doesn't exist locally or remotely, creating it..."
    git worktree add -b "$BRANCH" "$WORKTREE_DIR"
  fi

  # Read .worktreeinclude and copy directories/files
  if [ -f "$WORKTREE_INCLUDE_FILE" ]; then
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
  else
    echo "Warning: .worktreeinclude file not found"
  fi

  # Always copy Claude permissions file if it exists
  local CLAUDE_SETTINGS="$MAIN_DIR/.claude/settings.local.json"
  if [ -f "$CLAUDE_SETTINGS" ]; then
    echo "  Copying .claude/settings.local.json..."
    mkdir -p "$WORKTREE_DIR/.claude"
    cp "$CLAUDE_SETTINGS" "$WORKTREE_DIR/.claude/settings.local.json"
  fi

  echo ""
  echo "Worktree created successfully!"

  cd "$WORKTREE_DIR"
}

# Worktree deletion function
# Deletes a git worktree, its branch, and directory
wtd() {
  local MAIN_DIR=$(git rev-parse --show-toplevel 2>/dev/null)

  if [ -z "$MAIN_DIR" ]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
  local CURRENT_DIR=$(pwd)

  # Determine if we have a branch argument or need to detect current worktree
  if [ -n "$1" ]; then
    # Mode 1: Branch name provided as argument
    local BRANCH=$1
    local WORKTREE_PATH=""
    local FOUND=false

    # Parse git worktree list to find the worktree for this branch
    while IFS= read -r line; do
      if [[ "$line" == worktree* ]]; then
        WORKTREE_PATH="${line#worktree }"
      elif [[ "$line" == "branch refs/heads/$BRANCH" ]]; then
        FOUND=true
        break
      fi
    done < <(git worktree list --porcelain)

    if [ "$FOUND" = false ]; then
      echo "Error: No worktree found for branch '$BRANCH'"
      return 1
    fi

    echo "Deleting worktree for branch: $BRANCH"
    echo "Worktree path: $WORKTREE_PATH"

    # If we're currently in the worktree being deleted, cd to main directory first
    if [[ "$CURRENT_DIR" == "$WORKTREE_PATH"* ]]; then
      echo "Currently in worktree, moving to main directory..."
      cd "$MAIN_DIR"
    fi

    # Remove the worktree
    git worktree remove --force "$WORKTREE_PATH" 2>/dev/null

    # Delete the branch
    if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
      git branch -D "$BRANCH"
      echo "Branch '$BRANCH' deleted"
    else
      echo "Warning: Branch '$BRANCH' not found, skipping branch deletion"
    fi

    # Clean up directory if it still exists
    if [ -d "$WORKTREE_PATH" ]; then
      echo "Removing directory: $WORKTREE_PATH"
      rm -rf "$WORKTREE_PATH"
    fi

    echo "Worktree deleted successfully!"

  else
    # Mode 2: No argument - check if current directory is a worktree

    # Check if we're in a linked worktree (git-dir contains /worktrees/)
    if [[ "$GIT_DIR" != *"/worktrees/"* ]]; then
      echo "Usage: wtd <branch-name>"
      echo ""
      echo "Deletes a worktree, its branch, and directory."
      echo ""
      echo "Options:"
      echo "  wtd <branch-name>  - Delete the worktree for the specified branch"
      echo "  wtd                - Delete the current worktree (must be run from within a worktree)"
      return 1
    fi

    # We're in a worktree, find its information and the main worktree
    local WORKTREE_PATH=""
    local BRANCH=""
    local CURRENT_WORKTREE_FOUND=false
    local ACTUAL_MAIN_DIR=""
    local IS_FIRST=true

    while IFS= read -r line; do
      if [[ "$line" == worktree* ]]; then
        WORKTREE_PATH="${line#worktree }"
        # First worktree in the list is always the main worktree
        if [ "$IS_FIRST" = true ]; then
          ACTUAL_MAIN_DIR="$WORKTREE_PATH"
          IS_FIRST=false
        fi
      elif [[ "$line" == "branch refs/heads/"* ]]; then
        BRANCH="${line#branch refs/heads/}"
        # Check if this is the current worktree
        if [ "$WORKTREE_PATH" = "$CURRENT_DIR" ]; then
          CURRENT_WORKTREE_FOUND=true
          # Store the current worktree path before continuing to find main
          local CURRENT_WORKTREE_PATH="$WORKTREE_PATH"
        fi
      fi
    done < <(git worktree list --porcelain)

    if [ "$CURRENT_WORKTREE_FOUND" = false ]; then
      echo "Error: Could not determine current worktree information"
      return 1
    fi

    # Update WORKTREE_PATH to the stored current worktree path
    WORKTREE_PATH="$CURRENT_WORKTREE_PATH"

    echo "Deleting current worktree"
    echo "Branch: $BRANCH"
    echo "Path: $WORKTREE_PATH"

    # Change to main directory before removing
    cd "$ACTUAL_MAIN_DIR"

    # Remove the worktree
    git worktree remove --force "$WORKTREE_PATH" 2>/dev/null

    # Delete the branch
    if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
      git branch -D "$BRANCH"
      echo "Branch '$BRANCH' deleted"
    else
      echo "Warning: Branch '$BRANCH' not found, skipping branch deletion"
    fi

    # Clean up directory if it still exists
    if [ -d "$WORKTREE_PATH" ]; then
      echo "Removing directory: $WORKTREE_PATH"
      rm -rf "$WORKTREE_PATH"
    fi

    echo ""
    echo "Worktree deleted successfully!"
    echo "Returned to main directory: $ACTUAL_MAIN_DIR"
  fi
}
