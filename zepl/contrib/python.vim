" Description:  Text formatter for Python code.
" File:         zepl/contrib/python.vim
" Help:         :help zepl-python
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#python#formatter(text, newline)
    " Add missing final newlines to each line.
    let text = map(a:text, {_, val -> val ==# '\n$' ? val : val . a:newline})
    " Remove empty lines.
    let text = split(join(text, ''), '\n\zs', 0)
    if !empty(text)
        " Use common indentation.
        let depth = len(matchstr(text[0], '\m\C^\s*'))
        let text = map(text, 'v:val[' . depth . ':]')
        " Add extra newline to end for multiline python code.
        if len(text) > 1
            let text = add(text, a:newline)
        endif
    endif
    return text
endfunction

" EXAMPLE: Configure zepl.vim to use the Python formatter in Python buffers.
" autocmd FileType python let b:repl_config = {
"             \   'cmd': 'python',
"             \   'formatter': function('zepl#contrib#python#formatter')
"             \ }
