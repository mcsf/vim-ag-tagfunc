**This tool crawls the entire project every time a tag is looked up. `ag` is remarkably performant, but there are better ways. Consider not using a custom `tagfunc` and instead properly generating `tags` files with [mcsf/agtag](https://github.com/mcsf/agtag) and [on-the-fly regeneration of tags](https://github.com/mcsf/vim-gutenberg/blob/5bf2c0968f1e7f648932afbef6218112f782153a/plugin/gutenberg.vim#L18-L26).**

<hr>


# AgTagFunc

Jump to definitions of public functions, classes, etc. in any project by letting Vim look up _tags_ dynamically using `ag` or any equivalently fast _grepping_ tool.

## Why?

Modern LSP-based "jump to definition", as seen in VSCode and in Vim's CoC plugin, really fall short in large projects such as [Gutenberg](https://github.com/WordPress/gutenberg), as they have their own limited understanding of what constitutes a tag. For instance, in Gutenberg, these tools:

- can't jump to a selector or action in WordPress's data stores;
- erroneously jump to a TypeScript interface rather than the implementation;
- don't usefully fall back to text-based or other lookup methods, which also means that they:
- can't look up PHP identifiers, nor work in any other languages;

These tools tend to work in their own bubble with ad-hoc commands ("jump to definition", "jump to references", etc.) and thus don't play well with the rest of the editor. In contrast, Vim's tags support is native, extensible, and much more ergonomic. Tags use a navigation stack (`:tags`) separate from the regular jump stack (`:jumps`), meaning that:

- users can comfortably return to their previous context with `CTRL-T` rather than have to drill back by repeatedly pressing `CTRL-O`;
- tags can be looked up immediately (`:tag`) or picked from a list of candidates (`:tselect`);
- `:tnext` lets the user find the right definition in case Vim landed on the wrong occurrence.

## Usage

Once you have installed this repo as a Vim plugin using your method of choice, you can use basic Vim tags functionality:

- Use `CTRL-]` on the keyword under the cursor to jump to its JS/TS/PHP defintion.
- Use `:tag some_keyword` and `:tselect some_keyword` to look up anything by name.
- Use `:tnext` and friends to jump to the next matching tag.
- Use `CTRL-T` to jump out of the definitions (`CTRL-O` notwithstanding).

## Configuration

- `g:agtagfunc_cmd` (string): override `ag` invocation (default: `'ag -o --noheading --nobreak'`)
- `g:agtagfunc_queries` (string): override supported code queries (default: JavaScript, TypeScript, PHP)
- `g:agtagfunc_path` (list): override search path(s) (default: ['.'])
