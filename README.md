# Zepl.vim

*Simple and minimal REPL integration plugin for Vim and Neovim.*

Zepl is a lightweight, simple and easy to use REPL integration package for Vim
8.1+ and Neovim.  It provides a small set of key bindings and commands to start
and interact with a running REPL.

(This Git repository is mirrored to
[Codeberg](https://codeberg.org/axvr/zepl.vim),
[SourceHut](https://git.sr.ht/~axvr/zepl.vim) and
[GitHub](https://github.com/axvr/zepl.vim).)


## Why use Zepl?

Simplicity is at the core of Zepl.  It is carefully designed around the
following goals:

1. Integrate with and feel like a part of Vim.
2. Be highly extensible and customisable.
3. Do only what is required.

While it certainly is not perfect, I believe Zepl achieves these goals.

- Zepl is one of the smallest, simplest and most stable REPL plugins available.
- Its [`gz` operator](#sending-text-to-the-repl) and commands behave like
  built-in ones.
- It is very configurable and extensible and works with any REPL.
- In-depth documentation covers everything you ever need to know.
- Features that don't align with the goals are included as
  [optional extensions](#additional-functionality).

Zepl has had quite a few glowing reviews, but my favourite is
[this one](https://www.reddit.com/r/vim/comments/o4mss8/how_to_run_julia_repl_in_neovim/h2q1nlp/):

> I have just tried your plugin and I just can't stop appreciating it! [It's]
> just the [perfect] solution to my problem.
>
> It is brilliant, intuitive and is very natural to vim. I am amazed at this
> beautiful tool.


## Installation

Installation of Zepl can be performed by using your preferred plugin/package
management solution.  If you don't have a Vim package manager I recommend using
[Vim 8 packages](https://vimhelp.org/repeat.txt.html#packages) by running the
following 2 commands in your shell.

```sh
git clone https://codeberg.org/axvr/zepl.vim ~/.vim/pack/plugins/start/zepl
vim +'helptags ~/.vim/pack/plugins/start/zepl/doc/' +q
```


### Limitations

Before installing Zepl, you should be aware of the known limitations.

- Only 1 REPL can be open at a time (per Vim instance).
- Neovim's terminal may not behave as you expect it to and therefore might
  lessen the experience with Zepl.


## Quick start

The following is a short quick start guide, after installation it is
recommended to read the full manual — accessed by running `:help zepl.txt` in
Vim.


### Start a REPL

Start a REPL by running the `:Repl` command followed by the command to start
the REPL.  E.g.

```vim
:Repl clj         " Start Clojure REPL
:Repl julia       " Start Julia REPL
:Repl rlwrap csi  " Start CHICKEN Scheme REPL with rlwrap
```

You can prepend [modifiers](https://vimhelp.org/map.txt.html#%3Cmods%3E) to the
command such as `:vertical` (`:vert` for short) to start the REPL in a vertical
split.  E.g.

```vim
:vertical Repl clj              " Start Clojure REPL in a vertical split
:hide Repl julia                " Start Julia REPL in background
:vert botright Repl rlwrap csi  " Start CHICKEN Scheme REPL with rlwrap in a right vertical split
```

See how to set default REPL commands in the "[Set default REPLs](#set-default-repls)"
section.

To learn more about what the `:Repl` command can do, read the full manual
(`:help zepl.txt`).


### Jump to a running REPL

If you have already started a REPL you can jump to the buffer containing it by
running `:Repl` with no arguments.  This is useful if you opened the REPL in
a background buffer with `:hide Repl clj`.


### Sending text to the REPL

The `gz` operator makes it possible to send text from any buffer to the REPL
the same way you would with the built-in
[operators](https://vimhelp.org/motion.txt.html#operator) (such as `d`, `y` and
`gq`) by specifying a [motion](https://vimhelp.org/motion.txt.html#motion.txt)
(e.g. `ip`, `a)`, `j`, `i}`, `_`).

Examples include:

```vim
gzip  " Send current paragraph
gzj   " Send current line and line below
gz2k  " Send current line and the 2 above it
gza)  " Send current s-expression
```

The `gz` operator is also available from visual and visual-line modes so you
can visually select the text you want to send before sending it.
E.g. `vababgz` will start visual selection, select the current s-expression,
expand to the outer s-expression and then send all of that to the REPL.

Zepl provides a couple of short hand key bindings for the `gz` operator, these
are, 1. `gzz` rather than `gz_`; send the current line, 2. `gzZ` rather than
`gz$`; send from the cursor position to the end of the line.

To change the default key bindings and to learn more ways to send text to the
REPL, refer to the full manual.


### Set default REPLs

Zepl uses the `g:repl_config` dictionary for configuration.  The keys are
[filetypes](https://vimhelp.org/filetype.txt.html#filetypes) and the values are
dictionaries of configuration options for that filetype.

The main configuration option is the `cmd` key which sets a default REPL command
for buffers of that filetype.

```vim
let g:repl_config = {
            \   'javascript': { 'cmd': 'node' },
            \   'clojure': { 'cmd': 'clj' },
            \   'scheme': { 'cmd': 'rlwrap csi' },
            \   'julia':  { 'cmd': 'julia' }
            \ }
```

(When a default REPL has been specified, you only need to run `:Repl` to start
it.  The default can be overridden by using `:Repl <command>` as mentioned in
the "[Start a REPL](#start-a-repl)" section above.)

Full details on configuring Zepl can be found in the manual at
`:help zepl-configuration`.


#### Python

Some languages have unusual syntax rules such as the white space sensitivity in
Python.  This makes REPL usage much more difficult.  To alleviate most
problems, Zepl offers the ability to create "custom formatters" which sanitise
the text before sending it to the REPL.  A Python custom formatter is shipped
with Zepl and can be used like so.

```vim
runtime zepl/contrib/python.vim  " Enable the Python contrib module.

let g:repl_config = {
            \   'python': {
            \     'cmd': 'python',
            \     'formatter': function('zepl#contrib#python#formatter')
            \   }
            \ }
```

For information on writing custom formatters, refer to the manual (`:help
zepl-formatter`).


## Additional functionality

Zepl is designed to enable users to add extra features on top of what is
provided out of the box.  Some useful extra features are actually shipped with
Zepl in the contrib area, but disabled by default.

To view these extra features and how to use/enable them, be sure to check out
`:help zepl-contrib.txt`.

If you create an extra feature which you think others might find useful, open
a pull request to get it added to the contrib area!


## Legal

*No Rights Reserved.*

All source code, documentation and associated files packaged with zepl.vim are
dedicated to the public domain.  A full copy of the CC0 (Creative Commons Zero
1.0 Universal) public domain dedication should have been provided with this
extension in the `COPYING` file.

The author is not aware of any patent claims which may affect the use,
modification or distribution of this software.
