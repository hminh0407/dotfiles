" Ale {
    " configure lightline work with ALE
    let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [['mode', 'paste'], ['filename', 'modified']],
    \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
    \ },
    \ 'component_expand': {
    \   'linter_warnings' : 'LightlineLinterWarnings',
    \   'linter_errors'   : 'LightlineLinterErrors',
    \   'linter_ok'       : 'LightlineLinterOK'
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_warnings' : 'warning',
    \   'linter_errors'   : 'error'
    \ },
    \ }

    function! LightlineLinterWarnings() abort
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
    endfunction

    function! LightlineLinterErrors() abort
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
    endfunction

    function! LightlineLinterOK() abort
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:counts.total == 0 ? '✓ ' : ''
    endfunction

    autocmd User ALELint call lightline#update()
" }

" Autoformat {
    noremap <leader>af :Autoformat<CR>
    let g:autoformat_autoindent = 0
    let g:autoformat_retab = 0
    let g:autoformat_remove_trailing_spaces = 0
    autocmd FileType vim,tex let b:autoformat_autoindent=0
    let g:formatter_yapf_style = 'pep8'
" }

" Dadbod {
        " map C-Q to execute selection. In order for this to work $DATABASE_URL must be set
        " check fore more detail: https://github.com/tpope/vim-dadbod/issues/33
    nmap <expr> <C-Q> db#op_exec()
    xmap <expr> <C-Q> db#op_exec()
" }
