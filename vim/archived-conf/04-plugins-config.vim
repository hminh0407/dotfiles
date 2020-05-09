" Calendar {{
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
" }}

" Cutclass & Yoink {{
keep the x key as default (move)
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

" Integrate with cutlass. Otherwise the 'cut' operator that will not be added to the yank history
let g:yoinkIncludeDeleteOperations=1

" }}

" COC {{
" extensions in below list will be automatically installed
let g:coc_global_extensions = [
            \  'coc-snippet',
            \  'coc-tabnine',
            \  'coc-eslint', 'coc-prettier', 'coc-tsserver',
            \  'coc-yaml',
            \  'coc-json',
            \  'coc-emoji'
            \  'coc-python',
            \]

" }}

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

" Emoji {{
" use emoji as git gutter symbols
let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
let g:gitgutter_sign_modified_removed = emoji#for('collision')
" auto complete
set completefunc=emoji#complete
" }}

" Test {{
let test#strategy = "dispatch" " use quickfix window, not as good as vtr (async)
let test#strategy = "neoterm" " easily crash on Unbuntu (sync)
let test#strategy = "vimterminal" " use quickfix window, not like it (sync)
let test#strategy = "vimux" " could be the best but heavier than vtr (async)
let test#strategy = "vtr" " seem to be the best solution (async)
" }}
