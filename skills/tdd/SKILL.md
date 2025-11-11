---
name: tdd
description: Use when implementing new features, adding functionality, writing business logic, adding validation, or creating user-facing changes. Follows strict Test-Driven Development (TDD) methodology with Red-Green-Refactor cycles. Use when the user wants comprehensive test coverage, systematic feature development, or when building critical functionality that needs validation.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, TodoWrite, Task
---

# Test-Driven Development (TDD) Workflow

You are implementing a feature using Test-Driven Development (TDD). Follow the Red-Green-Refactor cycle strictly.

## Phase 0: Analysis & Planning

Before writing any code, thoroughly understand the requirements and existing codebase:

1. **Clarify requirements** - If anything is ambiguous, use AskUserQuestion to clarify before proceeding
2. **Research the codebase** using Read and Grep tools:
   - Find existing test files related to the feature
   - Understand existing test patterns and conventions (describe blocks, test helpers, assertion styles)
   - **Examine test fixtures, builders, and setup blocks carefully**
   - **Check for any default states that might affect new tests** (e.g., default status values in builders)
   - Identify the modules/functions that will need to change
3. **Create a comprehensive todo list** using TodoWrite with specific tasks:
   - Enumerate all test cases to write (be explicit about each scenario)
   - List implementation steps
   - Include refactoring considerations

### Critical Checkpoint
Before moving to Phase 1, ensure you understand:
- What default test data looks like
- Whether your new tests will conflict with existing test setup
- How to create test fixtures for your specific scenarios

## Phase 1: RED - Write Failing Tests

Write tests FIRST, before any implementation code:

1. **Write comprehensive test cases** covering:
   - Happy path scenarios (expected successful behavior)
   - Edge cases (boundary conditions, unusual but valid inputs)
   - Error conditions (invalid inputs, constraint violations)
   - Different states/contexts if applicable
2. **Follow existing test patterns** in the codebase for consistency
3. **Be explicit about assertions** - test exactly what should happen
4. **Run the test suite** and verify tests fail for the RIGHT reasons:
   - Tests should fail because functionality doesn't exist yet
   - Tests should NOT fail due to syntax errors or missing test data
   - If tests fail unexpectedly, investigate before proceeding
5. **Update TodoWrite** to mark test writing tasks as completed

### Red Phase Checklist
- [ ] All test cases written
- [ ] Tests follow codebase conventions
- [ ] Ran test suite and verified failures
- [ ] Failure messages confirm tests are checking the right behavior
- [ ] No syntax errors or test setup issues

## Phase 2: GREEN - Make Tests Pass

Implement the MINIMAL code needed to make tests pass:

1. **Start with the simplest implementation** that makes tests pass
2. **Make changes incrementally**:
   - Implement one piece of functionality at a time
   - Run tests after each significant change
   - If a test fails unexpectedly, stop and investigate why
3. **Watch for side effects on existing tests**:
   - Run the FULL test suite periodically, not just new tests
   - If existing tests break, this is valuable feedback about your design
   - Consider whether you need to update test fixtures or implementation approach
4. **Don't over-engineer** - resist the urge to add features not required by tests
5. **Update TodoWrite** as you complete each implementation step

### Green Phase Checklist
- [ ] All new tests passing
- [ ] All existing tests still passing
- [ ] No skipped or pending tests
- [ ] Implementation is minimal and focused
- [ ] No "TODO" comments in production code

### If Tests Still Fail
Don't proceed to refactoring. Instead:
- Review test expectations vs actual behavior
- Check for typos in test assertions or implementation
- Verify test data setup is correct
- Consider if the test itself needs adjustment
- Ask the user if you're stuck

## Phase 3: REFACTOR - Improve Code Quality

Now that tests are green, improve the code WITHOUT changing behavior:

1. **Review code for improvements**:
   - **Eliminate duplication** (DRY principle)
   - Extract helper functions/methods for repeated logic
   - Improve naming for clarity
   - Simplify complex conditionals
   - Ensure proper separation of concerns
   - **Maintain consistency with codebase patterns**
2. **Refactor incrementally**:
   - Make ONE refactoring change at a time
   - Run tests after EACH change
   - If tests fail, immediately undo the refactoring
3. **Consider moving logic to appropriate layers**:
   - Business logic should be in service/domain layer, not controllers
   - Validation logic should be in models or validators
   - Presentation logic should be in views/templates
4. **Update TodoWrite** to mark refactoring tasks as completed

### Refactor Phase Checklist
- [ ] Code is DRY (no duplication)
- [ ] Names are clear and descriptive
- [ ] Functions/methods have single responsibilities
- [ ] Code follows project conventions
- [ ] All tests still pass after each refactoring
- [ ] No new functionality added during refactoring

## Final Verification

1. **Run the complete test suite one final time**
   - Verify ALL tests pass (both new and existing)
   - Check for any warnings or deprecations
2. **Review the changes**:
   - Scan through all modified files
   - Ensure nothing was left in an inconsistent state
   - Check for any debug code or comments to remove
3. **Provide a summary** to the user:
   - What was implemented
   - Test coverage added (number of tests, scenarios covered)
   - Any important design decisions made
   - File locations with line numbers for key changes
4. **Mark all TodoWrite items as completed**

## Important Principles

### Never Skip Steps
- ❌ Don't write implementation before tests (breaks RED phase)
- ❌ Don't refactor before tests pass (breaks GREEN phase)
- ❌ Don't skip refactoring because "it works" (technical debt accumulates)

### Always Run Tests
- After writing tests (RED phase verification)
- After each implementation change (GREEN phase verification)
- After each refactoring change (REFACTOR phase safety net)
- Before marking work complete (final verification)

### Use TodoWrite Throughout
- Provides visibility to the user
- Helps track progress through phases
- Ensures nothing is forgotten
- Documents the development process

### Respond to Test Feedback
- Existing tests breaking? Your design may need adjustment
- Tests are difficult to write? The code may be too coupled
- Tests are verbose? Consider helper functions or better abstractions
- Tests feel brittle? You may be testing implementation details instead of behavior

## When TDD Might Not Apply

Be pragmatic. TDD is ideal for:
- New features and functionality
- Business logic and validation
- APIs and interfaces
- Data transformations
- Complex algorithms

Consider alternatives for:
- Pure UI/styling changes (visual testing may be better)
- Simple CRUD with no business logic
- Experimental spikes (write tests after validating the approach)
- Performance optimizations (benchmark testing may be more appropriate)

If unsure whether TDD applies, ask the user before proceeding.

## Example TDD Session Structure

```
User: "Add validation to prevent API calls when user is inactive"