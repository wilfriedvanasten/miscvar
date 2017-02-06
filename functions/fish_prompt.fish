# Prints out an arrow segment.
function _prompt_segment
  set -l arrow_head_glyph "├"
  set -l arrow_shaft_glyph "─┤"
  use_simple_glyph
    and set arrow_head_glyph "|"
    and set arrow_shaft_glyph "-|"
  set_color $arrow_color
  echo -n -s $arrow_shaft_glyph
  set_color $argv[1]
  echo -n $argv[2..-1]
  set_color $arrow_color
  echo -n $arrow_head_glyph
  set_color normal
end

# Calls git status in such a way that it is suitable
# for use in a script
function _git_status
  command git status --porcelain $argv
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
      command git symbolic-ref --short HEAD
    case tag
      _git_tag
    case detached
      command git show-ref --head -s --abbrev | head -n1 ^/dev/null
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
  if git_is_git_repo
    set -l git_branch (_git_branch_name)
    set -l git_branch_glyph ""
    use_simple_glyph
      and set git_branch_glyph "_/"
    set -l git_dirty_glyph "∗"
    use_simple_glyph
      and set git_dirty_glyph "*"
    _git_is_git_dirty
      and set -l git_dirty $git_dirty_glyph
    set -l git_project_root (command git rev-parse --show-toplevel)
    set -l git_project_path (shorten_path $PWD $git_project_root (basename $git_project_root))
    switch (_git_checkout_type)
      case branch
        set -l remote_status (_git_remote_status)
        if test $remote_status
            or _git_is_git_dirty
          _prompt_segment yellow "$git_branch_glyph $git_project_path@$git_branch $remote_status$git_dirty"
        else
          _prompt_segment cyan "$git_branch_glyph $git_project_path@$git_branch"
        end
      case tag
        set -l tag_glyph "⌂"
        use_simple_glyph
          and set tag_glyph 't'
        _prompt_segment red "$git_branch_glyph $tag_glyph $git_project_path@$git_branch $git_dirty"
      case detached
        set -l detached_glyph "➦"
        use_simple_glyph
          and set detached_glyph 'd'
        _prompt_segment red "$git_branch_glyph $detached_glyph $git_project_path@$git_branch $git_dirty"
    end
  end
end

# Outputs the final arrow head
# and the return status of the
# last command if non zero
function _prompt_arrow
  set_color $arrow_color
  if test $last_status -ne 0
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

# Outputs the fletching of the arrow
# in the given color
function _prompt_fletching
  set_color $arrow_color
  set -l arrow_fletching_glyph "≫"
  use_simple_glyph
    and set -l arrow_fletching_glyph ">>"
  set_color $argv[1]
  echo -n $arrow_fletching_glyph
  set_color normal
end

function _do_prompt_git
  git_exists; and git_is_git_repo
end

function fish_prompt
  set -g last_status $status
  set -g arrow_color cyan
  if test $last_status -ne 0
    set arrow_color red
  else if _is_user_root
    set arrow_color yellow
  end
  if _is_user_root
    _prompt_fletching
    _prompt_root
  else
    _prompt_fletching
  end
  if _do_prompt_git
    _prompt_git
  else
    _prompt_dir
  end
  _prompt_arrow

  set_color normal
end
