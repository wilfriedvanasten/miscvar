# FIXME: This doesn't play nice with tmux/screen
# I looked into it, but no solution seems readily
# available. Going into a vt is a rare occurence
# and I do not need tmux there, but it would be
# nice to have.
function use_simple_glyph --description 'Checks if simple glyphs should be used'
	test $TERM = "linux"
end
