let s:queries = [
	\	"ag --js --ts -o --noheading --nobreak '^export (?:function |class |const |default )*\\K",
	\	"ag --php -o --noheading --nobreak '(?:function |class )\\K",
	\ ]

function! AgTagFunc(pattern, flags, info)
	for query in s:queries
		let tags = []
		let matches = split(system(query . a:pattern . "\\W'"), "\n")
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
	return taglist(a:pattern)
endfunction

set tagfunc=AgTagFunc
