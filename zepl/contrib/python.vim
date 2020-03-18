" Description:  Text formatter for Python code.
" File:         zepl/contrib/python.vim
" Help:         :help zepl-python
" Legal:        No rights reserved.  Public domain.

function! zepl#contrib#python#formatter(text)
    " Remove empty lines.
    let text = filter(a:text, {_, val -> val !~# '\m\C^[ \t\n\r\e\b]*$'})

    if !empty(text)
        " Use common indentation.
        let depth = len(matchstr(text[0], '\m\C^\s*'))
        let text = map(text, 'v:val[' . depth . ':]')

        " Add empty line to end of multiline code (replaced by <CR> later on).
        if len(text) > 1
            let text = add(text, '')
        endif
    endif

    return join(text, "\<CR>") . "\<CR>"
endfunction

" EXAMPLE: Configure zepl.vim to use the Python formatter in Python buffers.
"
"     runtime zepl/contrib/python.vim
"     autocmd! FileType python let b:repl_config = {
"                 \   'cmd': 'python',
"                 \   'formatter': function('zepl#contrib#python#formatter')
"                 \ }
