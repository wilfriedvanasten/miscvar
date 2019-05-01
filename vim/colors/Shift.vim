if &t_Co >= 256
  set background=dark
  highlight clear
  if exists("syntax_on")
    syntax reset
  endif
  highlight Normal cterm=NONE ctermfg=250 ctermbg=234 gui=NONE guifg=#d5d5d5 guibg=#1c1c1c

  " Don't use the color column, nor cursor column
  highlight ColorColumn cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight CursorColumn cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg

  highlight Conceal cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight Cursor cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight CursorIM cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight CursorLine cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=#3f3f3f
  highlight Directory cterm=NONE ctermfg=White ctermbg=bg gui=NONE guifg=#ffffff guibg=bg
  highlight DiffAdd cterm=NONE ctermfg=Green ctermbg=bg gui=NONE guifg=#00bf00 guibg=bg
  highlight DiffChange cterm=NONE ctermfg=Yellow ctermbg=bg gui=NONE guifg=#bfbf00 guibg=bg
  highlight DiffDelete cterm=NONE ctermfg=Red ctermbg=bg gui=NONE guifg=#bf0000 guibg=bg
  highlight DiffText cterm=NONE ctermfg=bg ctermbg=Yellow gui=NONE guifg=bg guibg=#bfbf00
  highlight ErrorMsg cterm=NONE ctermfg=fg ctermbg=Red gui=nocombine,underline guifg=#bf0000 guibg=bg
  highlight VertSplit cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight Folded cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight FoldColumn cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight SignColumn cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight IncSearch cterm=NONE ctermfg=Black ctermbg=White gui=NONE guifg=Black guibg=White
  highlight LineNr cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight CursorLineNr cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight MatchParen cterm=reverse gui=reverse
  highlight ModeMsg cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight MoreMsg cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight NonText cterm=NONE ctermfg=DarkBlue ctermbg=bg gui=NONE guifg=#000080 guibg=bg
  highlight Pmenu cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight PmenuSel cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight PmenuSbar cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight PmenuThumb cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight Question cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight QuickFixLine cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight Search cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight SpecialKey cterm=NONE ctermfg=DarkGreen ctermbg=bg gui=NONE guifg=#005f00 guibg=bg
  highlight SpellBad ctermbg=Red gui=underline guifg=#bf0000
  highlight SpellCap ctermbg=Yellow gui=underline guifg=#bfbf00
  highlight SpellLocal ctermbg=Yellow gui=underline guifg=#bfbf00
  highlight SpellRare ctermbg=Yellow gui=underline guifg=#bfbf00
  highlight StatusLine cterm=nocombine,bold ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight StatusLineNC cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight StatusLineTerm cterm=nocombine,bold ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight StatusLineTermNC cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight TabLine cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight TabLineFill cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight TabLineSel cterm=nocombine,bold ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight Terminal cterm=nocombine,bold ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg
  highlight Title cterm=bold ctermfg=White ctermbg=bg gui=bold guifg=White guibg=bg
  highlight Visual cterm=reverse gui=reverse
  highlight VisualNOS cterm=reverse gui=reverse
  highlight WarningMsg cterm=NONE ctermfg=fg ctermbg=Yellow gui=underline guifg=#bfbf00 guibg=bg
  highlight WildMenu cterm=NONE ctermfg=bg ctermbg=fg gui=NONE guifg=bg guibg=fg

  highlight Comment cterm=italic ctermfg=Grey ctermbg=bg gui=italic guifg=#7f7f7f guibg=bg
  highlight Constant cterm=bold ctermfg=White ctermbg=bg gui=bold guifg=#ffffff guibg=bg
  highlight Identifier cterm=NONE ctermfg=154 ctermbg=bg gui=NONE guifg=#bfff00 guibg=bg
  highlight Function cterm=NONE ctermfg=118 ctermbg=bg gui=NONE guifg=#7fff00 guibg=bg
  highlight Statement cterm=NONE ctermfg=220 ctermbg=bg gui=NONE guifg=#ffbf00 guibg=bg
  highlight Conditional cterm=bold ctermfg=208 ctermbg=bg gui=bold guifg=#ff7f00 guibg=bg
  highlight Repeat cterm=bold ctermfg=208 ctermbg=bg gui=bold guifg=#ff7f00 guibg=bg
  highlight Keyword cterm=bold ctermfg=208 ctermbg=bg gui=bold guifg=#ff7f00 guibg=bg
  highlight Exception cterm=bold ctermfg=208 ctermbg=bg gui=bold guifg=#ff7f00 guibg=bg
  highlight Operator cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight PreProc cterm=NONE ctermfg=208 ctermbg=bg gui=NONE guifg=#ff7f00 guibg=bg
  highlight Type cterm=NONE ctermfg=220 ctermbg=bg gui=NONE guifg=#ffbf00 guibg=bg
  highlight Special cterm=NONE ctermfg=34 ctermbg=bg gui=NONE guifg=#00bf00 guibg=bg
  highlight Underlined cterm=NONE ctermfg=34 ctermbg=bg gui=NONE guifg=#00bf00 guibg=bg
  highlight Ignore cterm=NONE ctermfg=fg ctermbg=bg gui=NONE guifg=fg guibg=bg
  highlight Todo cterm=NONE ctermfg=Black ctermbg=White gui=NONE guifg=Black guibg=White


  let g:colors_name = "Shift"
endif
