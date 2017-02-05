
function _use_simple_glyph -d '
A function used to determine if the unicode glyphs
should be used. This allows the prompt to still
look nice on terminals with a limited set of
glyphs
'
  test $TERM = "linux"
end

function _prompt_segment -d '
Prints out an arrow segment.
'
  set_color $argv[1]
  set -l arrow_head_glyph "❯"
  set -l arrow_shaft_glyph "—|"
  _use_simple_glyph
    and set -l arrow_head_glyph ">"
    and set -l arrow_shaft_glyph "-|"
  echo -n -s $arrow_shaft_glyph $argv[2..-1] $arrow_head_glyph
  set_color normal
end

function _git_is_git_repo -d '
A function to check if the current directory
is or is part of a git repo
'
  command git status ^/dev/null > /dev/null
end

function _git_branch_name -d '
Gets the currently checked out git branch
name, if any.
'
  command git status --porcelain -b | grep '##' | sed -e 's/\\.\\.\\..*//g' | sed -e 's/^## \\(.*\\)$/\\1/'
end

function _git_is_git_dirty -d '
Checks if the git repo is dirty.
'
  # Test will return true if the string is not empty
  # use head -n 1 to not give multiple lines to test
  test (command git status --porcelain --ignore-submodules=dirty | head -n 1)
end

function _git_remote_not_synced -d '
Checks if the git repo is not synced
with its remote. Always returns false
for branches with no remote
'
  command git status --porcelain -b | grep '##' | grep '\\[' > /dev/null
end

function _git_remote_status -d '
Outputs information about the current
sync status with the remote if
the remote is not synced
'
  if _git_remote_not_synced
    set -l synced (command git status -b --porcelain | grep '##' | sed -e 's/^.*\[\\(.*\\)\]$/\1/g' | sed -e 's/ahead /+/g' | sed -e 's/behind /-/g')
    if echo $synced | grep '+' > /dev/null
      _prompt_segment brgreen $synced
    else if echo $synced | grep '-' > /dev/null
      _prompt_segment brred $synced
    end
  end
end

function _is_user_root
  set -l uid (id -u $USER)
  test $uid -eq 0
end

function _prompt_root -d '
Outputs a segment if the currently
active user is root.
'
  set -l su_glyph "⚡"
  _use_simple_glyph
    and set -l su_glyph "#"
  _prompt_segment yellow $su_glyph
end

function _prompt_dir -d '
Outputs a segment with the
prompt_pwd output
'
  _prompt_segment cyan (prompt_pwd)
end


function _prompt_git -d '
Outputs one or more segments related
to git.

Requires the git command
'
  if _git_is_git_repo
    set -l git_branch (_git_branch_name)
  	set -l git_branch_glyph "⎇"
  	_use_simple_glyph
      and set -l git_branch_glyph "_/"
    _prompt_segment brmagenta "$git_branch_glyph $git_branch"

	  _git_remote_status
    if _git_is_git_dirty
      set -g git_dirty_glyph "±"
  	  _use_simple_glyph
  	    and set -g git_dirty_glyph "+-"
      _prompt_segment yellow $git_dirty_glyph
    end
  end
end

function _prompt_arrow -d '
Outputs the final arrow head
and the return status of the
last command if non zero
'
  if test $last_status = 0
    set_color green
  else
    set_color red
    echo -n "($last_status)-"
  end
  set -l prompt_glyph "—❯"
  _use_simple_glyph
    and set -l prompt_glyph "->"
  echo -n "$prompt_glyph "
end

function _prompt_fletching -d '
Outputs the fletching of the arrow
in the given color
'
  set -l arrow_fletching_glyph "≫"
  _use_simple_glyph
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
  type -q git; and _prompt_git
  _prompt_arrow

  set_color normal
end
