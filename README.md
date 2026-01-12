# Claude Bash Utilities

Git worktree management utilities for efficient multi-branch workflows.

## Setup

Add this line to your `~/.zshrc` or `~/.bashrc`:

```bash
source /Users/timgent/.claude/claude-bash-utils.sh
```

Then restart your shell or run:

```bash
source ~/.zshrc  # or source ~/.bashrc
```

## Functions

### `wt <branch-name>`

Creates a new git worktree in a sibling `trees/<repo-name>/<branch-name>` directory.

**Behavior:**
- If the branch exists: checks it out in the new worktree
- If the branch doesn't exist: creates a new branch and worktree
- Copies files/directories listed in `.worktreeinclude` (if present)
- Automatically changes into the new worktree directory

**Example:**

```bash
$ wt feature-auth
Creating worktree for branch: feature-auth
Main directory: /Users/you/code/project
Worktree directory: /Users/you/code/trees/project/feature-auth
...
# You're now in the worktree directory
```

### `wtd [branch-name]`

Deletes a worktree, its associated branch, and directory.

**Modes:**

1. **With branch name:** Deletes the specified worktree
2. **Without arguments (inside worktree):** Deletes the current worktree and returns you to main directory
3. **Without arguments (outside worktree):** Shows usage instructions

**Important:** Force deletes the branch (`-D`) and removes the worktree regardless of uncommitted changes.

**Examples:**

```bash
# Delete a specific worktree by branch name
$ wtd feature-auth
Deleting worktree for branch: feature-auth
...
Worktree deleted successfully!

# Delete current worktree (when inside a worktree)
$ cd trees/feature-auth
$ wtd
Deleting current worktree
Branch: feature-auth
...
Worktree deleted successfully!
Returned to main directory: /Users/you/project
```

## Optional: .worktreeinclude File

Create a `.worktreeinclude` file in your repository root to automatically copy files/directories into new worktrees. This is useful for:

- `node_modules` (avoid reinstalling dependencies)
- `.env` files (share local configuration)
- Build artifacts or caches

**Example `.worktreeinclude`:**

```
node_modules
.env
.env.local
dist
.cache
```

When you run `wt new-branch`, these files/directories will be copied from the main worktree to the new worktree.

## Workflow Example

```bash
# In your main repository
$ git status
On branch main

# Create a worktree for a new feature
$ wt feature-login
# Now in ../trees/project/feature-login with feature-login branch

# Do your work
$ git add .
$ git commit -m "Add login feature"

# Go back to main directory to create another worktree
$ cd /path/to/project  # or use: cd ../../project
$ wt bugfix-header

# Work on the bugfix
$ git add .
$ git commit -m "Fix header bug"

# Delete the feature worktree when done
$ wtd feature-login
# Or navigate into it and run: wtd

# Clean up the bugfix worktree
$ cd ../trees/project/bugfix-header
$ wtd
# Returns you to main directory
```

## Why Use Worktrees?

Git worktrees allow you to have multiple branches checked out simultaneously in different directories, enabling:

- **Quick context switching** without stashing or committing incomplete work
- **Parallel development** on multiple features/bugs
- **Easy testing** by running different branches side-by-side
- **Clean separation** of different workstreams

Instead of:
```bash
git stash
git checkout other-branch
# do work
git checkout original-branch
git stash pop
```

You can simply:
```bash
wt other-branch
# do work
wtd
```
