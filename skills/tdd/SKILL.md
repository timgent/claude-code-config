---
name: tdd
description: Use when implementing features, fixing bugs, or planning implementation. Follows Test-Driven Development (TDD) with Red-Green-Refactor cycles.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, TodoWrite, Task
---

# TDD: Red-Green-Refactor

Always follow this cycle strictly:

## RED — Write a failing test first
- Write a test for the behaviour you want to add (feature or bug fix)
- Run tests and confirm the new test fails for the right reason
- Do not write any implementation code yet

## GREEN — Make it pass
- Write the minimal code needed to make the test pass
- Run tests and confirm all tests pass
- Do not over-engineer; resist adding untested functionality

## REFACTOR — Clean up
- Improve code quality (remove duplication, improve naming, simplify)
- Run tests after every change to ensure nothing breaks
- Do not add new functionality during this phase

Repeat the cycle for each behaviour to add.
