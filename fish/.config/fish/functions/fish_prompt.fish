# Prints out an arrow segment.
function _prompt_segment
  set_color $argv[1..-2]
  echo -n " "
  echo -n $argv[-1]
  echo -n " >"
end

# Calls git status in such a way that it is suitable
# for use in a script
function _git_set_status
  set -g _git_has_untracked_files ""
  set -g _git_has_staged_changes ""
  set -g _git_has_unstaged_changes ""
  set -g _git_branch_head ""
  set -g _git_branch_upstream ""
  set -g _git_branch_oid ""
  # Will only turn non-nil when an upstream is present
  set -g _git_branch_ahead 0
  set -g _git_branch_behind 0
  # Use --no-optional-locks to prevent this command from
  # writing the updated index, which is costly and
  # can cause conflicts. Let the users commands reign!
  set -g _git_status_value ""
  if set _git_status_value (command git --no-optional-locks status --porcelain=v2 -b 2> /dev/null)
    for rawline in $_git_status_value
      set -l line (string split ' ' $rawline)
      switch $line[1]
        case '#'
          switch $line[2]
            case 'branch.head'
              set _git_branch_head $line[3]
            case 'branch.upstream'
              set _git_branch_upstream $line[3]
            case 'branch.ab'
              set _git_branch_ahead (string sub -s 2 -- "$line[3]")
              set _git_branch_behind (string sub -s 2 -- "$line[4]")
            case 'branch.oid'
              set _git_branch_oid $line[3]
          end
        case '1' '2' 'u'
          set -l working_tree (string split '' $line[2])
          if test "$working_tree[1]" != "."
            set _git_has_staged_changes "true"
          end
          if test "$working_tree[2]" != "."
            set _git_has_unstaged_changes "true"
          end
        case '?'
          set _git_has_untracked_files "true"
      end
    end
  else
    return 1
  end
end

# Gets the currently checked out git branch
# name, if any.
function _git_head
  if test "$_git_branch_head" != "(detached)"
    echo "branch"
    echo $_git_branch_head
  else if set -l _git_tag_name (command git describe --tags --exact-match 2> /dev/null)
    echo "tag"
    echo $_git_tag_name
  else
    echo "detached"
    string sub -l 6 $_git_branch_oid
  end
end

function _git_remote_name
  echo (string split '/' $_git_branch_upstream)[1]
end

# Returns the current git remote status like (+4, -1)
# but only if the current branch is not synced
function _git_remote_status
  if test $_git_branch_ahead -gt 0 > /dev/null
    if test $_git_branch_behind -gt 0 > /dev/null
      set remote_status "±"
      use_simple_glyph
        and set remote_status "+-"
    else
      set remote_status "+"
    end
  else if test $_git_branch_behind -gt 0 > /dev/null
    set remote_status "-"
  end
  echo $remote_status
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
  _prompt_nix_segment $prompt_color
  _prompt_segment $prompt_color (prompt_pwd)
  _prompt_arrow $prompt_color
end

function _git_status_symbols
  set -l git_status_symbols (_git_remote_status)
  test "$_git_has_staged_changes"
    and set git_status_symbols "$git_status_symbols^"
  if test "$_git_has_unstaged_changes"
    set -l git_dirty_glyph "∗"
    use_simple_glyph
      and set git_dirty_glyph "*"
    set git_status_symbols "$git_status_symbols$git_dirty_glyph"
  end
  test "$_git_has_untracked_files"
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
  # Expose this for right prompt
  set -g _git_project_root $git_project_root
  set -l git_project_path (shorten_path $PWD)
  test (string sub -l (string length $git_project_root) $PWD) = $git_project_root
    and set git_project_path (shorten_path $PWD $git_project_root ":")
  set -l git_short_root (shorten_path $git_project_root)
  set -l git_head (_git_head)
  set -l git_branch $git_head[2]
  set -l git_branch_details ""
  set -l git_status_symbols (_git_status_symbols)
  set -g git_status_color $prompt_color
  set -l git_glyphs ""
  switch $git_head[1]
    case branch
      test $git_status_symbols
        and set git_status_color yellow
      set git_branch_details "local"
      set -l git_remote_name (string split '/' $_git_branch_upstream[1])[1]
      if test $git_remote_name
        set git_branch_details "$git_remote_name"
      end
    case tag
      set -l tag_glyph "⌂"
      use_simple_glyph
        and set tag_glyph 't'
      set git_glyphs "$tag_glyph"
      set git_status_color red
      set git_branch_details "tag"
    case detached
      set -l detached_glyph "➦"
      use_simple_glyph
        and set detached_glyph 'd'
      set git_glyphs "$detached_glyph"
      set git_status_color red
      set git_branch_details "detached"
  end
  set -l git_context_line (fold_string "$git_path_replace" (math $COLUMNS - 4) " $git_branch_glyph $git_short_root@$git_branch ($git_branch_details)")
  set_color $prompt_color
  set_color -r
  echo $git_context_line' '
  set_color normal
  set_color -o $git_status_color
  set -l final_segment $git_project_path
  test "$git_glyphs"
    and set -l final_segment "$git_glyphs $final_segment"
  test "$git_status_symbols"
    and set -l final_segment "$final_segment $git_status_symbols"
  _prompt_nix_segment $git_status_color
  _prompt_segment $final_segment
  _prompt_arrow $git_status_color
end

function _prompt_nix_segment
  test -n "$IN_NIX_SHELL"
    and _prompt_segment $argv[1..-1] "nix-shell"
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
  if git_exists; and _git_set_status
    set -g _prompt_git
    return 0
  else
    set -e _prompt_git
    return 1
  end
end

function fish_prompt
  set -g last_status $status
  set_color normal
  if is_user_root
    set -g prompt_color '-o' 'FF8000' 'yellow'
  else
    if test (tput colors) = "8"
      set -g prompt_color '-o' 'white'
    else
      set -g prompt_color '-o' 'brwhite'
    end
  end
  if _do_prompt_git
    _prompt_git
  else
    _prompt_dir
  end
  set_color normal
  echo -n " "
end
