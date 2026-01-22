Raise a PR by:

1. Understand the substance of the change by:
  1. Looking at the commits in the current branch compared to main/master branch
  2. Looking at the diff between the current branch and main/master
2. Checking at .github/pull_request_template.md if there is a template to follow and if so following that template when raising the PR
  1. NOTE: If there is no template then just include a "What this PR does" heading and a "Manual testing steps" heading
3. Composing a PR message that follows the template and succinctly explains the changes being made. It is critical to keep the message
as succinct as possible!
  1. NOTE: When completing any "How to test", "Testing", or similar sections, ONLY include manual testing steps. Do NOT mention running unit tests as these are always covered by CI pipelines
4. Uses the gh CLI to raise the PR
5. Returns the link to the PR to the user
