" Calendar {
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
" }

" Cutclass & Yoink {
" keep the x key as default (move)
" nnoremap x d
" xnoremap x d
" nnoremap xx dd
" nnoremap X D

" Integrate with cutlass. Otherwise the 'cut' operator that will not be added to the yank history
let g:yoinkIncludeDeleteOperations=1
" }

if executable('node') && executable('npm') " use coc if possible
    " Coc {
    let g:coc_global_extensions = [
                \  'coc-tabnine',
                \  'coc-eslint', 'coc-tsserver',
                \  'coc-yaml',
                \  'coc-json'
                \]
    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')
    nmap <leader>af :Format<CR>
    " Remap for format selected region
    xmap <leader>af  <Plug>(coc-format-selected)
    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}" }
    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " integrate with lightline
    function! CocCurrentFunction()
        return get(b:, 'coc_current_function', '')
    endfunction

    let g:lightline = {
                \ 'colorscheme': 'gruvbox',
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ],
                \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
                \ },
                \ 'component_function': {
                \   'cocstatus': 'coc#status',
                \   'currentfunction': 'CocCurrentFunction'
                \ },
                \ }
    " }
else
    " Ale
    " Fix file with prettier then eslint
    let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
    " }

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
endif

" Fzf {
" fuzzy search all files in root directory
map <C-P>      :Files!<cr>
" fuzzy search all history
map <C-C>      :History:<cr>
" fuzzy search line in current buffer
map <C-F><C-B> :BLines<cr>
" fuzzy search all commands
map <C-F><C-C> :Command!<cr>
" fuzzy search files in buffer
map <C-F><C-E> :Buffers<cr>
" fuzzy search lines in buffer
map <C-F><C-L> :Lines<cr>
" fuzzy search tag in current file
map <C-F><C-O> :BTags<cr>
" fuzzy search files in parent directory of current file
map <C-F><C-P> :FZFNeigh<cr>
" fuzzy search most recently used files
map <C-F><C-R> :FZFMru<cr>
" fuzzy search vim help document
map <C-F><C-H> :Helptags!<cr>
" fuzzy search mapping key
map <C-F><C-M> :Maps<cr>
" fuzzy search filetype syntax and hit ENTER on result to set that syntax to current file
map <C-F><C-S> :Filetypes<cr>

" hide status line when fzf open
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Customize fzf colors to match current color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Custom commands & functions

" NOTE: preview mode seem to have problem with latest linux kernel https://github.com/junegunn/fzf/issues/1486.
" Until it is fixed use normal mode instead
"
" Files command with preview window
" command! -bang -nargs=? -complete=dir Files
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%'), <bang>0)

function! s:fzf_neighbouring_files()
    let current_file =expand("%")
    let cwd = fnamemodify(current_file, ':p:h')
    " let command = 'ag -g "" -f ' . cwd . ' --depth 0'
    let command = 'rg -g "" -f ' . cwd . ' --max-depth 0'

    call fzf#run({
                \ 'source': command,
                \ 'sink':   'e',
                \ 'options': '-m -x +s',
                \ 'window':  'enew' })
endfunction

command! FZFNeigh call s:fzf_neighbouring_files()

command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '41%'})
" }

" Easy Align {
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }

" EditorConfig {
" make sure that it works well with vim fugitive and avoid loading EditorConfig
" for any remote files over ssh
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
" }

" CtrlSF {
" let g:ctrlsf_search_mode = 'async'
" disable builtin ctrl-f key from vim to avoid conflict
" map <C-F> <Nop>

" Input :CtrlSF in command line
nmap     <C-F><C-F> <Plug>CtrlSFPrompt
" Input :CtrlSF foo in command line where foo is the current visual selected word
vmap     <C-F><C-F> <Plug>CtrlSFVwordPath
" Toggle search result
nnoremap <C-F><C-T> :CtrlSFToggle<CR>
inoremap <C-F><C-T> <Esc>:CtrlSFToggle<CR>
" }

" Gutentags {
"
" Specifies command(s) to use to list files for which tags should be generated,
" instead of recursively examining all files within the project root
" let g:gutentags_file_list_command = 'ag -l' " ag ignore files in .gitignore and .ignore
let g:gutentags_file_list_command = 'rg -l' " rg ignore files in .gitignore and .ignore
" }

" HowMuch {
" sum values of a column and display result in an addional row
vmap <leader><leader>cs <Plug>AutoCalcReplaceWithSum
" calculate math formular and append result after '='
vmap <leader>ce <Plug>AutoCalcAppendWithEq
" }

" Maximize {
let g:maximizer_set_default_mapping = 2
let g:maximizer_set_mapping_with_bang = 1
" }

" Nerdtree {
let NERDTreeMinimalUI = 1       " disable `Press ? for help`
let NERDTreeDirArrows = 1       " disable `Press ? for help`
map <F1> :NERDTreeFind<CR>
" close all other buffers. equipvalence to ':NERDTreeClose | w | %bd | e# | bd#'
map <silent> <C-B><C-O> :NERDTreeClose <bar> w <bar> %bd <bar> e# <bar> bd#<CR>
" }

" Sneak {
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map s <Plug>Sneak_s
map S <Plug>Sneak_S
let g:sneak#s_next = 1
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

" Wiki {
" do not use vimwiki filetype for other files extensions (https://github.com/vimwiki/vimwiki/issues/95)
" let g:vimwiki_global_ext = 0
let g:vimwiki_list_margin = 0
let g:vimwiki_auto_tags = 1
let g:vimwiki_syntax = 'markdown'
let g:vimwiki_ext = '.md'
let g:vimwiki_folding = 'expr'

nmap <leader>wn <Plug>VimwikiNextLink
nmap <leader>wp <Plug>VimwikiPrevLink

function! VimwikiLinkHandler(link)
    " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
    "   1) [[vfile:~/Code/PythonProject/abc123.py]]
    "   2) [[vfile:./|Wiki Home]]
    let link = a:link
    if link =~# '^vfile:'
        let link = link[1:]
    else
        return 0
    endif
    let link_infos = vimwiki#base#resolve_link(link)
    if link_infos.filename == ''
        echomsg 'Vimwiki Error: Unable to resolve link!'
        return 0
    else
        exe 'vsplit ' . fnameescape(link_infos.filename)
        return 1
    endif
endfunction
" }
