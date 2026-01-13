# GitHub Copilot Instructions for appraisal2

This document contains important information for AI assistants working on this codebase.

## Tool Usage Preferences

### Prefer Internal Tools Over Terminal Commands

**IMPORTANT**: Copilot cannot see terminal output. Every terminal command requires the user to manually copy/paste the output back to the chat. This is slow and frustrating.

✅ **PREFERRED** - Use internal tools:
- `grep_search` instead of `grep` command
- `file_search` instead of `find` command
- `read_file` instead of `cat` command
- `list_dir` instead of `ls` command
- `replace_string_in_file` or `create_file` instead of `sed` / manual editing

❌ **AVOID** when possible:
- `run_in_terminal` for information gathering
- Running grep/find/cat in terminal

Only use terminal for:
- Running tests (`bundle exec rspec`)
- Installing dependencies (`bundle install`)
- Git operations that require interaction
- Commands that actually need to execute (not just gather info)

## Search Tool Limitations

### grep_search and Nested Git Projects

**CRITICAL**: The `vendor/*` directories in this workspace are **nested git projects** (they have their own `.git/` directory, separated from the parent by gitignore patterns). The `grep_search` tool **CANNOT search inside nested git projects** - it only searches the main workspace.

To search inside vendor gems:
1. Use `read_file` to read specific files directly (this always works)
2. Use `list_dir` to explore the directory structure
3. Do NOT rely on `grep_search` with `includePattern: "vendor/**"` - it will return no results

**Working approach for finding code in vendor gems:**
```
# Step 1: List the directory structure
list_dir("/home/pboling/src/appraisal-rb/appraisal2/vendor/markdown-merge/lib/markdown/merge")

# Step 2: Read specific files you need to search
read_file("/home/pboling/src/appraisal-rb/appraisal2/vendor/markdown-merge/lib/markdown/merge/file_analysis.rb", 0, 100)

# Step 3: If looking for a specific method, read more of the file or multiple files
```

### grep_search includePattern (for non-nested-git directories)

**IMPORTANT**: The `includePattern` parameter uses glob patterns relative to the workspace root.

✅ **WORKS** - Use these patterns:
```
# Search recursively within a directory (use ** for recursive)
includePattern: "vendor/**"           # All files under vendor/
includePattern: "vendor/ore-light/**" # All files under vendor/ore-light/

# Search a specific file
includePattern: "vendor/prism-merge/README.md"
includePattern: "lib/ast/merge/freezable.rb"

# Search files matching a pattern in a specific directory
includePattern: "spec/**"              # All spec files recursively
```

❌ **DOES NOT WORK** - Avoid these:
```
# The | character does NOT work for alternation in includePattern
includePattern: "vendor/prism-merge/**|vendor/ore-light/**"

# Cannot use ** in the middle of a path with file extension
includePattern: "vendor/**/spec/**/*.rb"  # Too complex, may fail
```

**Key insights:**
- `vendor/**` searches ALL files recursively under vendor/ (including subfolders)
- Without `includePattern`, `grep_search` searches the ENTIRE workspace (root project only, may miss vendor submodules)
- For vendor gems, always use `includePattern: "vendor/**"` or `includePattern: "vendor/gem-name/**"`
- To search multiple specific locations, make separate `grep_search` calls

### replace_string_in_file and Unicode Characters

**IMPORTANT**: The `replace_string_in_file` tool can fail silently when files contain special Unicode characters like:
- Curly apostrophes (`'` U+2019 instead of `'`)
- Em-dashes (`—` U+2014 instead of `-`)
- Emoji (🔧, 🎨, etc.)

When `replace_string_in_file` fails with "Could not find matching text":
1. The file likely contains Unicode characters that don't match what you're sending
2. Try using a smaller, more unique portion of the text
3. Avoid including lines with emojis or special punctuation in your oldString
4. Use `read_file` to see the exact content, but be aware the display may normalize characters

## Project Structure

- `lib/appraisal` - Base library classes (appraisal2 gem)
- `vendor/ore-light` - the ore-light library (A bundler replacement written in GoLang)
- `vendor/*/` - Other gems that we may want to have the source code to go diving in

### Naming Conventions
- File paths must match class paths (Ruby convention)
- Example: `Ast::Merge::Comment::Line` → `lib/ast/merge/comment/line.rb`

## Testing

### kettle-test RSpec Helpers

**IMPORTANT**: All spec files load `require "kettle/test/rspec"` which provides extensive RSpec helpers and configuration from the kettle-test gem. DO NOT recreate these helpers - they already exist.

**Environment Variable Helpers** (from `rspec-stubbed_env` gem):
- `stub_env(hash)` - Temporarily set environment variables in a block
- `hide_env(*keys)` - Temporarily hide environment variables

**Example usage**:
They are not used with blocks, but can be used like this:
```ruby
before do
   stub_env("MY_ENV_VAR" => "Bla Blah Blu")
end
it "should see MY_ENV_VAR" do
   # code that reads ENV["MY_ENV_VAR"]
end

# hide_env("HOME", "USER")
# is used the same way, but hides the variable so it acts as it if isn't set at all.
```

**Other Helpers** (loaded by kettle-test):
- `block_is_expected` - Enhanced block expectations (from `rspec-block_is_expected`)
- `capture` - Capture output during tests (from `silent_stream`)
- Timecop integration for time manipulation

**Where these come from**:
- External gems loaded by `kettle/test/external.rb` in the kettle-test gem
- `rspec/stubbed_env` - Provides `stub_env` and `hide_env`
- `rspec/block_is_expected` - Enhanced block expectations
- `silent_stream` - Output suppression
- `timecop/rspec` - Time travel for tests

### Running Tests

Run tests from the appropriate directory:

```bash
# appraisal2 tests
cd /var/home/pboling/src/appraisal-rb/appraisal2
bundle exec rspec spec/
```

### Coverage Reports

To generate a coverage report for any vendor gem:

```bash
cd /var/home/pboling/src/appraisal-rb/appraisal2
bin/rake coverage && bin/kettle-soup-cover -d
```

This runs tests with coverage instrumentation and generates detailed coverage reports in the `coverage/` directory.

## Terminal Command Restrictions

### Terminal Session Management

**How `run_in_terminal` works**:
- The tool sends commands to a **single persistent Copilot terminal**
- Use `isBackground=false` for `run_in_terminal`. Sometimes it works, but if it fails/hangs, use the file redirection method, and then read back with `read_file` tool.
- Commands run in sequence in the same terminal session
- Environment variables and working directory persist between calls
- The first command in a session either does not run at all, or runs before the shell initialization (direnv, motd, etc.) so it should always be a noop, like `true`.

**When things go wrong**:
- If output shows only shell banner/motd without command results, the command most likely worked, but the tool has lost the ability to see terminal output. This happens FREQUENTLY.
- EVERY TIME you do not see output, STOP and confirm output status with the user, or switch immediately to file redirection, and read the file back with `read_file` tool.
- **ALWAYS use project's `tmp/` directory for temporary files** - NEVER use `/tmp` or other system directories
- Solution: Ask the user to share the output they see.

**Best practices**:
1. **Combine related commands** - Use `&&` to chain commands, but DO NOT chain `cd` to other commands, because `direnv` will not have initialized / setup the ENV variables, until after the command finishes, resulting in unexpected or undefined behavior.
2. **Use `get_terminal_output`** - Check output of background processes
3. **Prefer internal tools** - Use `grep_search`, `read_file`, `list_dir` instead of terminal for information gathering

### NEVER Pipe Test Commands Through head/tail

**CRITICAL**: NEVER use `head`, `tail`, or any output truncation with test commands (`rspec`, `rake`, `bundle exec rspec`, etc.).

❌ **ABSOLUTELY FORBIDDEN**:
```bash
bundle exec rspec 2>&1 | tail -50
bin/rake coverage 2>&1 | head -100
bin/rspec | tail -200
```

✅ **CORRECT** - Run commands without truncation:
```bash
bin/rspec
bin/rake coverage
```

**Why**:
- You cannot predict how much output a test run will produce
- Your predictions are OFTEN wrong
- You cannot see terminal output anyway - the user will copy relevant portions for you
- Truncating output often hides the actual errors or relevant information
- The user knows what's important and will share it with you
