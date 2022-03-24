let s:cmd = "ag -o --noheading --nobreak"

let s:queries = [
	\	"--js --ts '^export ((function |class |const |default )*|{ *(\\w+, )*)\\K",
	\	"--php '(function |class )\\K",
	\ ]

function! AgTagFunc(pattern, flags, info)
	" AgTagFunc is meant to look up whole tags, such as when invoked via
	" CTRL-], :tag, :tselect, etc. It is not meant to autocomplete partial
	" tags.
	if (match(a:flags, "i") == -1)
		let cmd = get(g:, 'agtagfunc_cmd', s:cmd)
		let query = get(g:, 'agtagfunc_queries', s:queries)

		let tags = []
		for query in query
			let matches = split(system(cmd . " " . query . a:pattern . "\\b'"), "\n")
			for m in matches
				let [file, line, name] = split(m, ':')
				let tag = {
					\	'name': name,
					\	'filename': file,
					\	'cmd': line,
					\ }
				call insert(tags, tag)
			endfor
		endfor
		if ! empty(tags)
			return tags
		endif

	endif

	return taglist(a:pattern)
endfunction

set tagfunc=AgTagFunc
