" Settings {
  let g:BASH_Ctrl_j = 'off'
" }

" Plugin Settings {
  " Asyncomplete {
    " buffer complete
    silent! call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'whitelist': ['*'],
      \ 'blacklist': ['go'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ }))
    " file name complete
    silent! call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        \ 'name': 'file',
        \ 'whitelist': ['*'],
        \ 'priority': 10,
        \ 'completor': function('asyncomplete#sources#file#completor')
        \ }))
    " neosnippet complete
    silent! call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
    \ 'name': 'neosnippet',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
    \ }))
    " tag complete
    silent! call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
      \ 'name': 'tags',
      \ 'whitelist': ['c'],
      \ 'completor': function('asyncomplete#sources#tags#completor'),
      \ 'config': {
      \    'max_file_size': 50000000,
      \  },
      \ }))
    " force refresh completion, note that vim does not support <c-space>
    imap <C-B> <Plug>(asyncomplete_force_refresh)
    " remove duplicate
    let g:asyncomplete_remove_duplicates = 1
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
    " nmap <expr> <C-Q> db#op_exec()
    " xmap <expr> <C-Q> db#op_exec()
  " }

  " Gutentags {
    let g:gutentags_file_list_command = 'ag -l'
  " }

  " Lightline {
      " configure lightline work with ALE
      " \ 'colorscheme': 'wombat',
      let g:lightline = {
      \ 'colorscheme': 'gruvbox',
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

  " Neosnippet {
    imap <C-K> <Plug>(neosnippet_expand_or_jump)
    smap <C-K> <Plug>(neosnippet_expand_or_jump)
    xmap <C-K> <Plug>(neosnippet_expand_target)

    " Disable snipMate compatibility feature.
    let g:neosnippet#disable_runtime_snippets = {
    \   '_' : 1,
    \ }

    " Use custom snippets
    let g:neosnippet#snippets_directory='~/.config/nvim/snippets'
  " }

  " Tagbar {
      nmap <F7> :TagbarToggle<CR>
  " }

  " Test {
      " let test#strategy = "dispatch" " use quickfix window, not as good as vtr (async)
      " let test#strategy = "neoterm" " easily crash on Unbuntu (sync)
      " let test#strategy = "vimterminal" " use quickfix window, not like it (sync)
      " let test#strategy = "vimux" " could be the best but heavier than vtr (async)
      let test#strategy = "vtr" " seem to be the best solution (async)
  " }
" }
