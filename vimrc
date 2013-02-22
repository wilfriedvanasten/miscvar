autocmd! BufNewFile * silent! 0r ~/.vim/skel/tmpl.%:e

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

autocmd FileType python
  \ setlocal shiftwidth=4 |
  \ setlocal tabstop=4 |
  \ setlocal expandtab
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

autocmd BufRead,BufNewFile ~/.stumpwmrc
  \ setlocal syntax=lisp

highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

au BufRead,BufNewFile *.hsc set filetype=haskell

filetype plugin on

" configure browser for haskell_doc.vim
let g:haddock_browser = "/home/wilfried/screenlinks"

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
autocmd WinEnter * :set relativenumber
autocmd WinLeave * :set number
autocmd FocusGained * :set relativenumber
autocmd FocusLost * :set number

