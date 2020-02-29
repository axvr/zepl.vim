# Zepl.vim

*Lightweight REPL integration for Vim.*

Zepl.vim is a lightweight REPL integration package for Vim 8.1+ and Neovim.  It
provides commands to start and jump to a running REPL, as well as commands and
key bindings to send text to the REPL.

Zepl.vim follows several design philosophies:

1. Should be easy to use and configure: not much to learn and very few
   configuration options.
2. Feel like a part of Vim.  Key bindings and commands should work just like
   the built-in ones.
3. Tiny implementation. (Must not exceed 200 LOC; currently under 160.)

<!-- TODO: GIF -->

Zepl.vim has a couple of known limitations:

* Only 1 REPL can be open at a time (per Vim instance).
- [`set hidden`](https://vimhelp.org/options.txt.html#%27hidden%27) is required
  for Neovim and will be automatically set.


## Installation

Installation of zepl.vim can be performed by using your preferred
plugin/package management tool(s).  If you don't have a Vim package manager
I recommend using Vim 8 packages.

Just run these 2 commands from your shell.

```sh
git clone https://github.com/axvr/zepl.vim ~/.vim/pack/plugins/start/zepl
vim +'helptags ~/.vim/pack/plugins/start/zepl/doc/' +q
```

## Quick start

The following is a short quick start guide.  For more detailed documentation,
install zepl.vim and read the manual (`:help zepl.txt`).

### Start the REPL

Start a REPL using the `:Repl` command.  This command is in the format:

    :[mods] [size] Repl [command]

Where `[mods]` is any of [`:help <mods>`](https://vimhelp.org/map.txt.html#%3Cmods%3E)
(e.g. `vertical` to open REPL in a vertical split, or `hide` to start the REPL
in the background).

`[size]` is the height of the REPL window.  If `[mods]` contained `vertical`
this will set the width of the REPL window.

`[command]` is the interpreter to use.  If omitted and a REPL is already
running, zepl.vim will open/jump to that REPL, otherwise it'll use the command
specified in the [`b:repl_config`][config] variable.

**Examples:**

```vim
" Start a new REPL using command from `b:repl_config` or jump to already
" running REPL.
:Repl

" Start REPL with command `clj` with height of 16 characters.
:16 Repl clj

" Start REPL in vertical split with command from `b:repl_config` or jump to
" running REPL (open in vertical split if not already visible).
:vert Repl

" Start REPL (command from `b:repl_config`) in background.
:hide Repl

" Open vertical REPL 60 columns wide on right of the screen connected to
" a running Clojure socket REPL through netcat.
:botright vertical 60 Repl rlwrap nc localhost 5555

" Start REPL in new tab or open running REPL in new tab (if not open).
:tab Repl
```

### Send text to REPL

Zepl.vim provides both a key binding and a command to send text from any
buffer into a running REPL to be evaluated.

#### Key bindings

The default key binding for zepl.vim is `gz`.  To change this, please refer to
the full manual.

The `gz` key can accept any [motion](https://vimhelp.org/motion.txt.html#motion.txt)
you would do with another key such as `d`, `y`, `c`, `gq`, `=`, etc.  To send
the current paragraph to the REPL use `gzip`.  To send the current s-expression
to the REPL use `gza)`, or to send the current line use.

`gz` will also work in visual mode, so you can also do `vipgz` to send the
current paragraph.  `Vi3jgz` to send the next 4 lines to the REPL.  Even
something complex like `vabababgz` will work (this selects the current
s-expression, expand 2 levels out and sends the entire thing to the REPL).

A couple of short hand key combinations are provided: `gzz` rather than `gz_`
to send the current line, and `gzZ` rather than `gz$` to send from the cursor
position to the end of the line.

#### Command

The `:ReplSend` command is somewhat similar to the key binding but has
different usage, it also only works line-wise.  The command follows this
format:

    :[range] ReplSend [text]

You can either provide `[range]` or `[text]` to be sent to the REPL.  If you
give both, only `[text]` will be sent.

`[range]` is an Ex command-line range (see [`:help [range]`](https://vimhelp.org/cmdline.txt.html#%5Brange%5D)).
**Note**: like all standard Ex commands, `:ReplSend` will only operate on whole
lines.

`[text]` is any arbitrary text you want to send to the REPL.  This is useful
for scripting.

**Examples:**

```vim
" Send current line to REPL.
:ReplSend

" Send line 3 to the REPL.
:3ReplSend

" Send lines 3–9 to the REPL.
:3,9 ReplSend

" Send visual line selection to REPL.
'<,'>:ReplSend

" Send `print("Hello, world!")` to the REPL.
:ReplSend print("Hello, world!")
```

### Configuration

[config]: #configuration

If you've read the above sections, you will have heard the `b:repl_config`
variable mentioned a few times.  This variable lets you configure default REPL
settings.

`b:repl_config` is a buffer local dictionary.  At the moment only the `cmd` key
is used, which is the default interpreter for that buffer.  Additional keys may
be added in the future, and/or other plugins and scripts can add their own
keys.

**Example:**

The following example configures default REPLs per filetype for the `:Repl`
command.

```vim
augroup zepl
    autocmd!
    autocmd FileType python     let b:repl_config = { 'cmd': 'python3' }
    autocmd FileType javascript let b:repl_config = { 'cmd': 'node' }
    autocmd FileType clojure    let b:repl_config = { 'cmd': 'clj' }
    autocmd FileType scheme     let b:repl_config = { 'cmd': 'rlwrap csi' }
    autocmd FileType lisp       let b:repl_config = { 'cmd': 'sbcl' }
    autocmd FileType julia      let b:repl_config = { 'cmd': 'julia' }
augroup END
```

## Additional functionality

*Coming soon...*


## Legal

*No Rights Reserved.*

All source code, documentation and associated files packaged with zepl.vim are
dedicated to the public domain.  A full copy of the CC0 (Creative Commons Zero
1.0) public domain dedication should have been provided with this extension in
the `COPYING` file.
