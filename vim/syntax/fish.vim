if exists('b:current_syntax')
    finish
endif

"let s:endcommand = '\v;|$'

syntax case match

" syntax keyword fishKeyword function begin end
" syntax keyword fishConditional if else switch
syntax keyword fishRepeat in
" syntax keyword fishLabel case
syntax match fishComment "\v#.*$"
syntax match fishExpand contained "\$"
syntax match fishIdentifier contained "\v\h\w*"
syntax match fishExpansion contained "\v\$\h\w*" contains=fishExpand,fishIdentifier
syntax region fishString contained extend start="'" skip="\v[^\\]\\'" end="'"
syntax match fishNumber contained "\v<\x+>"
syntax match fishEscape contained "\\\\"
syntax region fishString contained extend start="\"" skip="\v[^\\]\\\"" end="\"" contains=fishExpansion,fishEscape
syntax match fishCharacter contained /\v\\[abefnrtv *?~%#(){}\[\]<>&;"']|\\[xX][0-9a-f]{1,2}|\\o[0-7]{1,2}|\\u[0-9a-f]{1,4}|\\U[0-9a-f]{1,8}|\\c[a-z]/
syntax match fishOption contained "\v\s\zs-\k+>"
syntax match fishGNULongOption contained "\v\s\zs--\a[-[:alnum:]]*>"
syntax match fishRedirect contained "\v(\<\<?|\>\>?|\^\^?)\&?"
syntax match fishCommand contained /\v\s*\zs\k+>/
syntax region fishStatement matchgroup=fishCommand start='\v\zs\k+>' skip='\\$' end='\v\||;|$'
          \ contains=fishCommandSub,fishOption,fishGNULongOption,fishKeyword,fishConditional,
          \ fishRepeat,fishLabel,fishRedirect,fishNumber,fishString,fishCharacter,fishExpansion,
          \ fishComment
syntax region fishStatement matchgroup=fishCommand start="if" end="\vend|\zeelse"
          \ keepend extend contains=fishStatement
syntax region fishStatement matchgroup=fishCommand start="else" end="end"
          \ keepend extend contains=fishStatement
syntax region fishFunctionHead matchgroup=fishCommand start="function" skip='\\$' end="\v\||;|$"
          \ contains=fishIdentifier,fishOption,fishGNULongOption
syntax region fishStatement matchgroup=fishCommand start="and" skip='\\$' end="\v\||;|$"
          \ contains=fishStatement
syntax region fishStatement matchgroup=fishCommand start="or" skip='\\$' end="\v\||;|$"
          \ contains=fishStatement
syntax region fishStatement matchgroup=fishCommand start="command" skip='\\$' end="\v\||;|$"
          \ contains=fishStatement
syntax region fishStatement matchgroup=fishCommand start="while" keepend extend end="end"
          \ contains=fishStatement
syntax region fishStatement matchgroup=fishCommand start="\[" keepend extend end="\]"
          \ contains=fishCommandSub,fishExpansion,fishString,fishOption,fishGNULongOption,fishNumber,fishCharacter
" This will prevent the else group from extending past an if
syntax match fishElseIfMatch "\velse\ze\s+if"
syntax region fishCommandSub start="(" end=")" keepend extend contains=fishStatement

highlight default link fishKeyword Keyword
highlight default link fishConditional Conditional
highlight default link fishRepeat Repeat
highlight default link fishLabel Label
highlight default link fishIdentifier Identifier
highlight default link fishString String
highlight default link fishNumber Number
highlight default link fishComment Comment
highlight default link fishExpand Special
highlight default link fishEscape Special
highlight default link fishOption Special
highlight default link fishGNULongOption Special
highlight default link fishCommand Statement
highlight default link fishElseIfMatch Statement
highlight default link fishRedirect Operator

let b:current_syntax = 'fish'
