function shift_scheme
  set fish_color_autosuggestion 7f7f7f brblack
  set fish_color_cancel -r
  set fish_color_command ffbf00
  set fish_color_comment 7f7f7f
  # These colors are not used in the prompt
  set fish_color_cwd normal
  set fish_color_cwd_root normal
  set fish_color_end --bold ff7f00
  set fish_color_error ff0000
  set fish_color_escape 00bf00
  set fish_color_history_current --reverse
  # This color is not used
  set fish_color_host normal
  # TODO: Setting this didn't seem to have any effect?
  set fish_color_match  --reverse
  set fish_color_normal normal
  set fish_color_operator d5d500
  set fish_color_param bfff00
  set fish_color_quote --bold ffffff
  set fish_color_redirection d5d500
  # TODO: What does this do again
  set fish_color_search_match --background=3f3f3f
  set fish_color_selection c0c0c0
  set fish_color_status red
  set fish_color_user normal
  set fish_color_valid_path --underline
  # Pager
  set fish_pager_color_progress --reverse brwhite
  set fish_pager_color_prefix brwhite --underline
  set fish_pager_color_description brwhite
  set fish_pager_color_completion 7f7f7f brblack
  return 0
end
