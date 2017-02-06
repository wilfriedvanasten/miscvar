# Prints out an arrow segment.
function _prompt_segment
  set_color $argv[1]
  set -l arrow_head_glyph "├"
  set -l arrow_shaft_glyph "─┤"
  use_simple_glyph
    and set arrow_head_glyph "|"
    and set arrow_shaft_glyph "-|"
  echo -n -s $arrow_shaft_glyph $argv[2..-1] $arrow_head_glyph
  set_color normal
end

# Calls git status in such a way that it is suitable
# for use in a script
function _git_status
  command git status --porcelain $argv
end

# A function to check if the current directory
# is or is part of a git repo
function _git_is_git_repo
  _git_status ^/dev/null > /dev/null
end

function _git_is_head_symbolic_ref
  command git symbolic-ref -q HEAD > /dev/null
end

function _git_tag
  command git describe --tags --exact-match ^/dev/null
end

function _git_checkout_type
  if _git_is_head_symbolic_ref
    echo "branch"
  else if _git_tag > /dev/null
    echo "tag"
  else
    echo "detached"
  end
end

# Gets the currently checked out git branch
# name, if any.
function _git_branch_name
  switch (_git_checkout_type)
    case branch
      _git_status -b | grep '##' | sed -e 's/\\.\\.\\..*//g' | sed -e 's/^## \\(.*\\)$/\\1/'
    case tag
      set -l tag _git_tag
      set -l tag_glyph \u2302
      use_simple_glyph
        and set tag_glyph 't'
      echo "$tag_glyph $tag"
    case detached
      set -l detached_glyph \u27A6
      use_simple_glyph
        and set detached_glyph 'd'
      set -l commit (command git show-ref --head -s --abbrev | head -n1 ^/dev/null)
      echo "$detached_glyph $commit"
  end
end

# Checks if the git repo is dirty.
function _git_is_git_dirty
  # Test will return true if the string is not empty
  # use head -n 1 to not give multiple lines to test
  test (_git_status --ignore-submodules=dirty | head -n 1)
end

# Checks if the git repo is not synced
# with its remote. Always returns false
# for branches with no remote
function _git_remote_not_synced
  _git_status -b | grep '##' | grep '\\[' > /dev/null
end

# Returns the current git remote status like (+4, -1)
# but only if the current branch is not synced
function _git_remote_status
  if _git_remote_not_synced
    echo -n -s "(" (_git_status -b | grep '##' | sed -e 's/^.*\[\\(.*\\)\]$/\1/g' | sed -e 's/ahead /+/g' | sed -e 's/behind /-/g') ")"
  end
end

# Checks if the user is root
function _is_user_root
  set -l uid (id -u $USER)
  test $uid -eq 0
end

# Outputs a segment if the currently
# active user is root.
function _prompt_root
  set -l su_glyph "⚡"
  use_simple_glyph
    and set -l su_glyph "#"
  _prompt_segment yellow $su_glyph
end

# Outputs a segment with the
# prompt_pwd output
function _prompt_dir
  _prompt_segment cyan (prompt_pwd)
end


# Outputs one or more segments related
# to git.
#
# Requires the git command
function _prompt_git
  if _git_is_git_repo
    set -l git_branch (_git_branch_name)
    set -l git_branch_glyph \uE0A0
    use_simple_glyph
      and set git_branch_glyph "_/"
    set -l git_dirty_glyph "∗"
    use_simple_glyph
      and set git_dirty_glyph "*"
    _git_is_git_dirty
      and set -l git_dirty $git_dirty_glyph
    switch (_git_checkout_type)
      case branch
        set -l remote_status (_git_remote_status)
        if test $remote_status
            or _git_is_git_dirty
          _prompt_segment yellow "$git_branch_glyph $git_branch $remote_status$git_dirty"
        else
          _prompt_segment magenta "$git_branch_glyph $git_branch"
        end
      case tag detached
        _prompt_segment red "$git_branch_glyph $git_branch $git_dirty"
    end
  end
end

# Outputs the final arrow head
# and the return status of the
# last command if non zero
function _prompt_arrow
  if test $last_status = 0
    set_color green
  else
    set_color red
    if use_simple_glyph
      echo -n "($last_status)"
    else
      echo -n "($last_status✘)"
    end
  end
  set -l prompt_glyph "─▶"
  use_simple_glyph
    and set -l prompt_glyph "->"
  echo -n "$prompt_glyph "
end

# Checks if git is present
function _git_exists
  type git ^/dev/null >/dev/null
end

# Outputs the fletching of the arrow
# in the given color
function _prompt_fletching
  set -l arrow_fletching_glyph "≫"
  use_simple_glyph
    and set -l arrow_fletching_glyph ">>"
  set_color $argv[1]
  echo -n $arrow_fletching_glyph
  set_color normal
end

function fish_prompt
  set -g last_status $status
  set -l fletching_color cyan
  if _is_user_root
    _prompt_fletching yellow
    _prompt_root
  else
    _prompt_fletching cyan
  end
  _prompt_dir
  _git_exists; and _prompt_git
  _prompt_arrow

  set_color normal
end
