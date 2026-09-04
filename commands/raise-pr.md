Raise a PR by:

1. Understand the substance of the change by:
  1. Looking at the commits in the current branch compared to main/master branch
  2. Looking at the diff between the current branch and main/master
2. Checking at .github/pull_request_template.md if there is a template to follow and if so following that template when raising the PR
  1. NOTE: If there is no template then just include a "What this PR does" heading and a "Manual testing steps" heading
3. Composing a PR message that follows the template and succinctly explains the changes being made. It is critical to keep the message
as succinct as possible!
  1. NOTE: When completing any "How to test", "Testing", or similar sections, ONLY include manual testing steps. Do NOT mention running unit tests as these are always covered by CI pipelines
  2. When the change has a shape worth seeing (control or data flow, file layout, component tree, call tree, state transitions), use the `show-me` skill to add **one** visual to the "What this PR does" section, next to the sentence it supports
    1. Only the markdown-renderable forms apply: a ```mermaid``` fence, a `diff`-shaped sketch, a call tree, or a file tree. A PR body cannot open an HTML artifact, so skip that part of the skill
    2. The visual replaces prose rather than adding to it. Leave it out when a sentence already makes the change clear
4. Referencing the linked Linear ticket, if there is one (look at the branch name, the commit messages, or ask the user):
  1. If the PR completes the whole ticket, use a closing magic word (e.g. `Fixes ENG-123`) in the PR description
  2. If the PR is only part of the ticket, use a **non-closing** magic word (e.g. `Part of ENG-123` or `Ref ENG-123`) so merging does not move the ticket to its done status. Ask the user if it is unclear whether the ticket is fully covered
  3. A non-closing magic word is still needed when the branch name contains the ticket ID, otherwise merging applies the "On PR or commit merge" status
  4. See https://linear.app/docs/github#magic-words
5. Uses the gh CLI to raise the PR
  1. Write the body to a file and pass `--body-file`, so backticks and fenced blocks survive the shell
6. Returns the link to the PR to the user
