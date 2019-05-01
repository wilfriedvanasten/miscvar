set tabstop=4
set shiftwidth=4
set relativenumber
set number
set autoindent

if $TERM =~ '\v.*-256color' && exists('+termguicolors')
  let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
syntax on
colorscheme Shift

" When developing in haskell or amanda
" we want expanded short tabs
autocmd FileType haskell
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal expandtab |
  \ vmap <buffer> <silent> gg :s/^/--/<CR> |
  \ vmap <buffer> <silent> gq :s/^--\(.*\)/\1/<CR>

autocmd FileType lhaskell
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal expandtab |
  \ vmap <buffer> <silent> gg :s/^/--/<CR> |
  \ vmap <buffer> <silent> gq :s/^--\(.*\)/\1/<CR>

autocmd FileType python
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal expandtab |
  \ vmap <buffer> <silent> gg :s/^/#/<CR> |
  \ vmap <buffer> <silent> gq :s/^#\(.*\)/\1/<CR>

autocmd FileType amanda
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal expandtab

autocmd FileType java
  \ vmap <buffer> <silent> gg :s#^#//#<CR> |
  \ vmap <buffer> <silent> gq :s#^//\(.*\)#\1#<CR>

autocmd FileType c
  \ setlocal expandtab

autocmd FileType tex
  \ setlocal spell

autocmd FileType cabal
  \ setlocal shiftwidth=4 |
  \ setlocal tabstop=4 |
  \ setlocal expandtab

autocmd FileType xml
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

autocmd BufRead,BufNewFile ~/.stumpwmrc
  \ setlocal syntax=lisp

autocmd FileType fish
  \ setlocal shiftwidth=2 |
  \ setlocal tabstop=2 |
  \ setlocal expandtab

highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

" use ghc functionality for haskell files
"autocmd Bufenter *.hs compiler ghc

autocmd BufRead,BufNewFile *.hsc set filetype=haskell

filetype plugin on

" configure browser for haskell_doc.vim
let g:haddock_browser = "/home/wilfried/screenlinks"

autocmd User plugin-skeleton-detect
  \ if expand('%:t') ==# 'pom.xml'
  \ |   SkeletonLoad xml-pom
  \ | endif

autocmd User plugin-skeleton-detect
  \ if expand('%:t') =~ '\.tex$'
  \ |   setlocal syntax=tex
  \ |   SkeletonLoad tex
  \ | endif

command -nargs=0 UHLC echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

map <F10> :UHLC<CR>
