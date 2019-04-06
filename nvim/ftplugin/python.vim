" Plugin Settings {
    " Ale {
        nmap <silent> <leader>en :ALENextWrap<CR>
        nmap <silent> <leader>ep :ALEPreviousWrap<CR>
        let g:ale_python_options = 'pylint'      " use pylint linter
        let g:ale_lint_on_text_changed = 'never' " not run when text change
        let g:ale_lint_on_enter = 0              " not run on open file
        let g:ale_python_flake8_args = '-m flake8 --max-line-length=120'
        let g:ale_python_flake8_options = '-m flake8 --max-line-length=120'
    " }

    " Asynccomplete {
        " register language server
        if executable('pyls')
            " pip install python-language-server
            au User lsp_setup call lsp#register_server({
              \ 'name': 'pyls',
              \ 'cmd': {server_info->['pyls']},
              \ 'whitelist': ['python'],
              \ })
        endif
        " enabling pydocstyle
        if executable('pyls')
            au User lsp_setup call lsp#register_server({
              \ 'name': 'pyls',
              \ 'cmd': {server_info->['pyls']},
              \ 'whitelist': ['python'],
              \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
              \ })
        endif
    " }

    " Test {
        if $PYTHON_TEST_RUNNER == 'djangotest'
            let test#python#runner = 'djangotest'

            map <silent> <buffer> <leader>ut :TestNearest<CR>
            map <silent> <buffer> <leader>uT :TestFile<CR>
            map <silent> <buffer> <leader>ua :TestSuite<CR>
            map <silent> <buffer> <leader>ul :TestLast<CR>
            map <silent> <buffer> <leader>ug :TestVisit<CR>
        else
            let test#python#runner = 'nose'

            " run nose test with no output capture
            map <silent> <buffer> <leader>ut :TestNearest -s<CR>
            map <silent> <buffer> <leader>uT :TestFile -s<CR>
            map <silent> <buffer> <leader>ua :TestSuite -s<CR>
            map <silent> <buffer> <leader>ul :TestLast -s<CR>
            map <silent> <buffer> <leader>ug :TestVisit -s<CR>
        endif
    " }

" }
