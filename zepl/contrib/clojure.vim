" Description:  Text formatter for Clojure code.
" File:         zepl/contrib/clojure.vim
" Author:       Paul Fernandez <paul4nandez@gmail.com>
" Help:         :help zepl-clojure
" Legal:        No rights reserved.  Public domain.

function s:getClojureNS()
  let l:syms = split(trim(join(getline(1, 10))))
  if l:syms[0] == '(ns'
    return  l:syms[1]
  else
    return ''
  endif
endfunction

" Requires, then switches to, the namespace of the current buffer, allowing use
" of its contents and dependencies.
function! LoadClojureNS()
  let l:ns = s:getClojureNS()
  if strlen(l:ns)
    let l:cmd = "(do (require '" . l:ns . ")\n      (in-ns '" . l:ns . "))"
    execute 'ReplSend' . l:cmd
  endif
endfunction

" Requires and refers the namespace of the current buffer, allowing use of its
" defs. To reload changes, pass in an argument of ':reload' or ':reload-all'.
function! UseClojureNS(...)
  let l:ns = s:getClojureNS()
  if strlen(l:ns)
    let l:flags = a:0 ? ' ' . a:1 : ''
    if bufname('zepl: ') =~# g:repl_config[&ft].cmd
      let l:cmd = "(use '" . l:ns . l:flags . ')'
      execute 'ReplSend' . l:cmd
    endif
  endif
endfunction

function s:stripLeadingEmptyLines(lines) abort
   while !empty(a:lines)
      if a:lines[0] =~# '\m^\s*$'
         call remove(a:lines, 0)
      else
         break
      endif
   endwhile
   return a:lines
endfunction

function s:stripTrailingEmptyLines(lines) abort
   let idx = len(a:lines) - 1
   while idx >= 0
      if a:lines[idx] =~# '\m^\s*$'
         call remove(a:lines, idx)
         let idx -= 1
      else
         break
      endif
   endwhile
   return a:lines
endfunction

function s:processLine(...) abort
   " Remove trailing newlines.
   let line = trim(a:2, "\r\n", 2)

   " Remove two leading spaces added by the Clojure repl.
   return substitute(line, '\m^\s\s', '', '')
endfunction

function zepl#contrib#clojure#formatter(lines)
   let lines = s:stripLeadingEmptyLines(a:lines)
   let lines = s:stripTrailingEmptyLines(lines)
   let lines = map(lines, function("s:processLine"))
   return join(lines, "\n") . "\n"
endfunction

" EXAMPLE: Configure zepl.vim to use the Clojure formatter in Clojure buffers.
" (Replace 'plugins/' with your plugin directory path.)
"
"   runtime plugins/zepl.vim/zepl/contrib/clojure.vim
"   let g:repl_config = {
"   \   'clojure': {
"   \     'cmd': filereadable('deps.edn') ? 'clj' : 'lein repl',
"   \     'formatter': function('zepl#contrib#clojure#formatter')
"   \   }
"   \ }
