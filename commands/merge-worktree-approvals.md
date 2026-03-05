Merge the Claude auto-approval permissions from a worktree into the main repo.

Worktrees live at `trees/<repo_name>/<worktree_name>` relative to a shared parent.
The main repo lives at `<repo_name>` relative to that same parent.

The argument `$ARGUMENTS` may be a worktree path. If not provided, use `$PWD`.

## Steps

### 1. Determine paths

From the worktree path, derive:
- `repo_name` = basename of the worktree's parent directory (i.e. `basename(dirname(worktree_path))`)
- `base_dir` = 3 levels up from the worktree (i.e. `dirname(dirname(dirname(worktree_path)))`)
- `main_repo` = `base_dir/repo_name`

Run this to confirm:
```bash
WORKTREE_PATH="${ARGUMENTS:-$PWD}"
REPO_NAME=$(basename "$(dirname "$WORKTREE_PATH")")
BASE_DIR=$(dirname "$(dirname "$(dirname "$WORKTREE_PATH")")")
MAIN_REPO="$BASE_DIR/$REPO_NAME"
echo "Worktree: $WORKTREE_PATH"
echo "Main repo: $MAIN_REPO"
```

### 2. Read both settings files

Read:
- `$WORKTREE_PATH/.claude/settings.local.json`
- `$MAIN_REPO/.claude/settings.local.json`

If either file does not exist, treat it as having an empty `allow` array: `{"permissions": {"allow": [], "deny": [], "ask": []}}`.

### 3. Merge allow entries

Add any entries from the worktree's `permissions.allow` array that are not already present in the main repo's `permissions.allow` array. Do not add duplicates. Do not remove any existing entries. Leave `deny` and `ask` unchanged.

### 4. Write the updated main repo settings

Write the merged JSON back to `$MAIN_REPO/.claude/settings.local.json`.

### 5. Report

Print the entries that were added (if any), or confirm that no new entries were found.
