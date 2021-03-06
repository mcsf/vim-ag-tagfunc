let s:cmd = "ag -o --noheading --nobreak"

let s:queries = [
	\	"--js --ts '((^export (default )?((function |class |const )|{ *(\\w+, )*))|(@typedef {[^}(]+} ))",
	\	"--php '^\\s*(function |class )",
	\ ]

function! AgTagFunc(pattern, flags, info)
	" AgTagFunc is meant to look up whole tags, such as when invoked via
	" CTRL-], :tag, :tselect, etc. It is not meant to autocomplete partial
	" tags.
	if (match(a:flags, "i") == -1)
		let cmd = get(g:, 'agtagfunc_cmd', s:cmd)
		let query = get(g:, 'agtagfunc_queries', s:queries)
		let path = join(get(g:, 'agtagfunc_path', ['.']))

		let tags = []
		for query in query
			let matches = split(system(cmd . " " . query . '\K' . a:pattern . "\\b' " . path), "\n")
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
			call sort(tags, {a, b -> len(a['filename']) - len(b['filename'])})
			return tags
		endif

	endif

	return taglist(a:pattern)
endfunction

set tagfunc=AgTagFunc
