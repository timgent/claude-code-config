Address PR comments by analyzing feedback and making atomic commits for each comment.

The PR number or URL is specified as: $ARGUMENTS

If no PR number or URL is provided, STOP and ask the user to provide one.

## Process

1. **Extract PR Information**
   1. If $ARGUMENTS contains a GitHub URL, extract the PR number from it
   2. Otherwise, treat $ARGUMENTS as the PR number directly
   3. Use `gh pr view <PR_NUMBER> --json number,title,url` to verify the PR exists and get its details

2. **Fetch PR Comments**
   1. Use `gh api repos/:owner/:repo/pulls/<PR_NUMBER>/comments` to get review comments on specific code lines
   2. Use `gh api repos/:owner/:repo/issues/<PR_NUMBER>/comments` to get general PR comments
   3. Parse the JSON responses to extract:
      - Comment author
      - Comment body
      - File path and line number (for review comments)
      - Comment ID for reference

3. **Analyze Each Comment**
   For each comment, wrap your analysis in `<analysis>` tags to determine:
   1. What change is being requested
   2. Whether the comment is straightforward to address autonomously
   3. If straightforward, proceed with implementation
   4. If unclear or involves architectural decisions, prepare options for the user

   A comment is **straightforward** if:
   - It's a clear bug fix with obvious solution
   - It's a simple style/formatting change
   - It's adding missing error handling in an obvious way
   - It's fixing a typo or obvious logical error
   - It's removing unused code
   - The implementation approach is unambiguous

   A comment **needs clarification** if:
   - Multiple valid approaches exist
   - It involves architectural or design decisions
   - The requested change conflicts with other requirements
   - The scope or implementation details are unclear
   - It may have significant side effects

4. **Address Straightforward Comments**
   For each straightforward comment:
   1. Make the necessary code changes
   2. Create a commit with a descriptive message that references the comment:
      ```
      Address PR comment: [brief description]

      [More detailed explanation if needed]

      Addresses feedback from [author] on [file:line if applicable]

      Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
      ```
   3. Use git commit (not git commit --amend) to create a new atomic commit

5. **Handle Complex Comments**
   For each comment that needs clarification:
   1. Present the comment and its context
   2. Use AskUserQuestion to propose 2-4 options with:
      - Clear description of each approach
      - Pros and cons for each option
      - Your recommendation marked as "(Recommended)"
      - Why you recommend that approach
   3. After user selection, implement the chosen approach
   4. Create an atomic commit as described in step 4

6. **Summary**
   After processing all comments:
   1. Show a summary of what was addressed:
      - Number of comments addressed autonomously
      - Number of comments that required user input
      - List of commits created
   2. Remind the user to push the commits if they're satisfied
   3. Suggest running tests if applicable

## Important Notes

- NEVER amend commits - always create new commits for each comment addressed
- Keep commits atomic - one commit per comment or closely related group of comments
- If a comment has already been addressed in existing commits, note this and skip it
- If you're unsure whether a comment is straightforward, err on the side of asking the user
- Read files before editing them
- Run tests after making changes if a test suite is available
- Do not push commits automatically - let the user review and push manually
