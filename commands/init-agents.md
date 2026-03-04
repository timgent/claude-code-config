Initialise an AGENTS.md file for the current repository, along with a CLAUDE.md that references it.

## Process

### 1. Check for existing files

Check if `AGENTS.md` or `CLAUDE.md` already exist in the current working directory.

- If `AGENTS.md` already exists, inform the user and stop.
- If `CLAUDE.md` already exists, do not overwrite it — instead append `@AGENTS.md` to the end of it (only if that line isn't already present).

### 2. Create AGENTS.md

Create an `AGENTS.md` file in the current working directory with the following structure, tailored to the project if you can infer its language/framework/tooling from existing files:

```markdown
# Agents Guide

This file provides guidance for AI agents (Claude, Codex, Gemini, etc.) working in this repository.

## Project Overview

[Brief description of the project — infer from README, package.json, mix.exs, Cargo.toml, etc. if available, otherwise leave a TODO placeholder]

## Repository Structure

[High-level description of key directories and their purpose — infer from the file tree if possible]

## Development Commands

[List common commands such as build, test, lint, format — infer from package.json scripts, Makefile, mix.exs, etc. if available]

## Code Style & Conventions

[Describe coding conventions, naming patterns, formatting rules — infer from config files like .eslintrc, .formatter.exs, rustfmt.toml, etc. if available]

## Testing

[Describe how to run tests and any testing conventions]

## Important Notes

[Any other important context for agents working in this repo]
```

Fill in as much detail as you can by inspecting the repository (README, config files, package manifests, directory structure). Replace sections you cannot infer with a `TODO:` placeholder comment.

### 3. Create or update CLAUDE.md

- If `CLAUDE.md` does not exist, create it with the following content:

```markdown
@AGENTS.md
```

- If `CLAUDE.md` already exists, append `@AGENTS.md` on a new line at the end (only if not already present).

### 4. Confirm to the user

Tell the user what files were created or modified, and suggest they fill in any `TODO:` sections in `AGENTS.md`.
