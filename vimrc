syntax on

set background=dark
set tabstop=4
set shiftwidth=4
set relativenumber
set autoindent

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

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
autocmd WinEnter * :set relativenumber
autocmd WinLeave * :set number
autocmd FocusGained * :set relativenumber
autocmd FocusLost * :set number

autocmd User plugin-skeleton-detect
  \ if expand('%:t') ==# 'pom.xml'
  \ |   SkeletonLoad xml-pom
  \ | endif

autocmd User plugin-skeleton-detect
  \ if expand('%:t') =~ '\.tex$'
  \ |   setlocal syntax=tex
  \ |   SkeletonLoad tex
  \ | endif

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

