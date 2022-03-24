let s:cmd = "ag -o --noheading --nobreak"

let s:queries = [
	\	"--js --ts '^export (?:function |class |const |default )*\\K",
	\	"--php '(?:function |class )\\K",
	\ ]

function! AgTagFunc(pattern, flags, info)
	" AgTagFunc is meant to look up whole tags, such as when invoked via
	" CTRL-], :tag, :tselect, etc. It is not meant to autocomplete partial
	" tags.
	if (match(a:flags, "i") == -1)
		let cmd = exists("g:agtagfunc_cmd") ? g:agtagfunc_cmd : s:cmd
		let query = exists("g:agtagfunc_queries") ? g:agtagfunc_queries : s:queries

		for query in query
			let tags = []
			let matches = split(system(cmd . " " . query . a:pattern . "\\W'"), "\n")
			for m in matches
				let [file, line, rest] = split(m, ':')
				let tag = {
					\	'name': a:pattern,
					\	'filename': file,
					\	'cmd': line,
					\ }
				call insert(tags, tag)
			endfor
			if ! empty(tags)
				return tags
			endif
		endfor

	endif

	return taglist(a:pattern)
endfunction

set tagfunc=AgTagFunc
