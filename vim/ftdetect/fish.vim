autocmd BufRead,BufNewFile *.fish setfiletype fish

autocmd BufRead *
    \ if getline(1) =~# '\v^#!%(\f*/|/usr/bin/env\s*<)fish>' |
    \     setlocal filetype=fish |
    \ endif

