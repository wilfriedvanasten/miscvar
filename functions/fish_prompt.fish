# Prints out an arrow segment.
function _prompt_segment
  set_color $argv[1]
  echo -n " "
  echo -n $argv[2..-1]
  echo -n " >"
end

# Calls git status in such a way that it is suitable
# for use in a script
function _git_status
  if not set -q _git_status_value
    set -g _git_status_value (command git status --porcelain=v2 -b)
  end
  string join \n $_git_status_value
end

function _git_is_head_symbolic_ref
  not string match -r '^# branch.head \(detached\)' (_git_status) > /dev/null
end

function _git_tag
  command git describe --tags --exact-match 2> /dev/null
end

# Gets the currently checked out git branch
# name, if any.
function _git_head
  if not set -q _git_checkout_type_value
    if _git_is_head_symbolic_ref
      echo "branch"
      echo (string match -r '^# branch.head (.*)' (_git_status))[2]
    else if set -l _git_tag_name (_git_tag)
      echo "tag"
      echo $_git_tag_name
    else
      echo "detached"
      echo (string match -r '^# branch.oid (......).*' (_git_status))[2]
    end
  end
end

# Checks if the git repo is dirty.
function _git_is_git_dirty
  # If the repo is dirty git status returns more than one line
  test (count (_git_status)) -gt 1
end

# Checks if the git repo is not synced
# with its remote. Always returns false
# for branches with no remote
function _git_remote_not_synced
  string match -r '^# branch.ab.*[1-9].*' (_git_status) > /dev/null
end

function _git_remote_name
  set -l match (string match -r '^# branch.upstream ([^/]*)/[^/]*' (_git_status))
  if test "$match"
    echo $match[2]
  else
    return 1
  end
end

# Returns the current git remote status like (+4, -1)
# but only if the current branch is not synced
function _git_remote_status
  if _git_remote_not_synced
    set -l remote_status (string match -r '^# branch.ab \\+([0-9]+) -([0-9]+)' (_git_status))
    if test $remote_status[2] -gt 0 > /dev/null
      if test $remote_status[3] -gt 0 > /dev/null
        set remote_status "±"
        use_simple_glyph
          set remote_status "+-"
      else
        set remote_status "+"
      end
    else if test $remote_status[3] -gt 0 > /dev/null
      set remote_status "-"
    end
    echo $remote_status
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
  set -l su_glyph "#"
  use_simple_glyph
    and set -l su_glyph "#"
  _prompt_segment yellow $su_glyph
end

# Outputs a segment with the
# prompt_pwd output
function _prompt_dir
  _prompt_segment $prompt_color (prompt_pwd)
  _prompt_arrow $prompt_color
end

function _git_unstaged_changes
  string match -r "^[12u] [.AMDRC][AMDRC]" (_git_status) > /dev/null
end

function _git_staged_changes
  string match -r "^[12u] [MADRC]" (_git_status) > /dev/null
end

function _git_untracked_files
  string match -r "^\?" (_git_status) > /dev/null
end

function _git_status_symbols
  set -l git_status_symbols (_git_remote_status)
  _git_staged_changes
    and set git_status_symbols "$git_status_symbols^"
  if _git_unstaged_changes
    set -l git_dirty_glyph "∗"
    use_simple_glyph
      and set git_dirty_glyph "*"
    set git_status_symbols "$git_status_symbols$git_dirty_glyph"
  end
  _git_untracked_files
    and set git_status_symbols "$git_status_symbols"_
  echo $git_status_symbols
end

# Outputs one or more segments related
# to git.
#
# Requires the git command and only
# works in a git repository
function _prompt_git
  set -l git_path_replace "…"
  use_simple_glyph
    and set git_path_replace "..."
  set -l git_branch_glyph ""
  use_simple_glyph
    and set git_branch_glyph "Y"
  set -l git_project_root (command git rev-parse --show-toplevel)
  set -l git_project_path (shorten_path $PWD $git_project_root "")
  not test "$git_project_path"
    and set git_project_path "/"
  set -l git_short_root (shorten_path $git_project_root)
  set -l git_head (_git_head)
  set -l git_branch $git_head[2]
  set -l git_branch_details ""
  set -l git_status_symbols (_git_status_symbols)
  set -g git_status_color $prompt_color
  set -l git_glyphs "$git_branch_glyph"
  switch $git_head[1]
    case branch
      test $git_status_symbols
        and set git_status_color yellow
      set git_branch_details "local"
      set -l git_remote_name (_git_remote_name)
      if test $git_remote_name
        set git_branch_details "$git_remote_name"
      end
    case tag
      set -l tag_glyph "⌂"
      use_simple_glyph
        and set tag_glyph 't'
      set git_glyphs "$git_glyphs $tag_glyph"
      set git_status_color red
      set git_branch_details "tag"
    case detached
      set -l detached_glyph "➦"
      use_simple_glyph
        and set detached_glyph 'd'
      set git_glyphs "$git_glyphs $detached_glyph"
      set git_status_color red
      set git_branch_details "detached"
  end
  set -l git_context_line (fold_string $git_path_replace (math $COLUMNS - 4) " $git_short_root@$git_branch ($git_branch_details)")
  set -l git_upper_padding (math (expr length + $git_glyphs) + 1)
  set_color -r $prompt_color
  echo -n (repeatc $git_upper_padding " ")
  echo -n $git_context_line
  echo (repeatc (math $COLUMNS - (expr length + $git_context_line) - $git_upper_padding) " ")
  set_color normal
  set_color $git_status_color
  if test $git_status_symbols
    _prompt_segment $git_status_color "$git_glyphs $git_project_path $git_status_symbols"
  else
    _prompt_segment $git_status_color "$git_glyphs $git_project_path"
  end
  _prompt_arrow $git_status_color
  set -e -g _git_status_value
  set -e -g _git_checkout_type_value
  set -e -g _git_tag_name
end

# Outputs the final arrow head
# and the return status of the
# last command if non zero
function _prompt_arrow
  set_color normal
  set_color $argv[1]
  if test $last_status -ne 0
    if use_simple_glyph
      _prompt_segment red "($last_status)"
    else
      _prompt_segment red "($last_status✘)"
    end
  end
end

function _do_prompt_git
  git_exists; and git_is_git_repo
end

function fish_prompt
  set -g last_status $status
  set_color 007FFF 2> /dev/null
    and set -g prompt_color 007FFF
    or set -g prompt_color cyan
  if _is_user_root
    set_color FF8000 2> /dev/null
      and set prompt_color FF8000
      or set prompt_color yellow
  end
  if _do_prompt_git
    _prompt_git
  else
    _prompt_dir
  end

  set_color normal
  echo -n " "
end
