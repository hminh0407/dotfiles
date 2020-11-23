" Asterisk {{{
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
" }}}

autocmd FileType plantuml nnoremap <buffer> <leader>b :!plantuml -o %:p:h %<cr>

" COC {{
if executable('node') && executable('npm') " use coc if possible
    let g:coc_global_extensions = [
                \  'coc-snippets',
                \  'coc-sh',
                \  'coc-eslint', 'coc-prettier', 'coc-tsserver',
                \  'coc-sql',
                \  'coc-yaml',
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

    nmap <leader>cf  <Plug>(coc-fix-current)
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

    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

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



    if (index(['vim','help'], &filetype) >= 0)
        " make popup window scrollable (vim only)
        " check for enhancement in https://github.com/neoclide/coc.nvim/issues/1160
        " for now, this is the workaround from https://github.com/neoclide/coc.nvim/issues/1405
        function FindCursorPopUp()
            let radius = get(a:000, 0, 2)
            let srow = screenrow()
            let scol = screencol()
            " it's necessary to test entire rect, as some popup might be quite small
            for r in range(srow - radius, srow + radius)
                for c in range(scol - radius, scol + radius)
                    let winid = popup_locate(r, c)
                    if winid != 0
                        return winid
                    endif
                endfor
            endfor

           return 0
        endfunction

        function ScrollPopUp(down)
            let winid = FindCursorPopUp()
            if winid == 0
                return 0
            endif

            let pp = popup_getpos(winid)
            call popup_setoptions( winid,
                \ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )

            return 1
        endfunction

        nnoremap <expr> <c-d> ScrollPopUp(1) ? '<esc>' : '<c-d>'
        nnoremap <expr> <c-u> ScrollPopUp(0) ? '<esc>' : '<c-u>'
    else
        " nvim only
        "coc#util#float_scroll({forward})
        "Return expr for scrolling a floating window forward or backward. ex: >

        nnoremap <expr><C-d> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-d>"
        nnoremap <expr><C-u> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-u>"
    endif
endif
" }}

" Cutclass & Yoink {{
" change default behavior of paste to not yank the deleted content
vnoremap p "_dP
" Integrate with cutlass. Otherwise the 'cut' operator that will not be added to the yank history
let g:yoinkIncludeDeleteOperations=1
" }}

" Fzf {{
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
" fuzzy search tags
map <C-F><C-T> :Tags<cr>
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
" }}

" Easy Align {{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}

" EditorConfig {{
" make sure that it works well with vim fugitive and avoid loading EditorConfig
" for any remote files over ssh
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
" }}

" CtrlSF {{
" let g:ctrlsf_search_mode = 'async'
" disable builtin ctrl-f key from vim to avoid conflict
" map <C-F> <Nop>

" Input :CtrlSF in command line
nmap     <C-F><C-F> <Plug>CtrlSFPrompt
" Input :CtrlSF foo in command line where foo is the current visual selected word
vmap     <C-F><C-F> <Plug>CtrlSFVwordPath
" Toggle search result
nnoremap <C-F><C-G> :CtrlSFToggle<CR>
inoremap <C-F><C-G> <Esc>:CtrlSFToggle<CR>
" }}

" Gutentags {{
"
" Specifies command(s) to use to list files for which tags should be generated,
" instead of recursively examining all files within the project root
" let g:gutentags_file_list_command = 'ag -l' " ag ignore files in .gitignore and .ignore
let g:gutentags_file_list_command = 'rg --files' " rg ignore files in .gitignore and .ignore
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*", "*.csv"]
let g:gutentags_add_default_project_roots = 0
    " by default gutentags will automatically seek for project root folder which contain `root markers`` like `.git` `.hg`
    " setting this option to prevent that behavior
" let g:gutentags_trace = 1
" }}

" HowMuch {{
" sum values of a column and display result in an addional row
vmap <leader><leader>cs <Plug>AutoCalcReplaceWithSum
" calculate math formular and append result after '='
vmap <leader>ce <Plug>AutoCalcAppendWithEq
" }}

" Maximize {{
let g:maximizer_set_default_mapping = 2
let g:maximizer_set_mapping_with_bang = 1
" }}

" Nerdtree {{
let NERDTreeMinimalUI = 1       " disable `Press ? for help`
let NERDTreeDirArrows = 1       " disable `Press ? for help`
map <F1> :NERDTreeFind<CR>
" close all other buffers. equipvalence to ':NERDTreeClose | w | %bd | e# | bd#'
map <silent> <C-B><C-O> :NERDTreeClose <bar> w <bar> %bd <bar> e# <bar> bd#<CR>
" }}

" Sneak {{
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map s <Plug>Sneak_s
map S <Plug>Sneak_S
let g:sneak#s_next = 1
" }}

"  Startify {{
let g:startify_skiplist = [ 'people' ]
"  }}

" Tagbar {{
nmap <F7> :TagbarToggle<CR>
let g:tagbar_autoclose=1 " Only open Tagbar when you want to jump to a specific tag and have it close automatically once you have selected one
" }}

" Vim Wiki {{
let g:vimwiki_folding='expr'
let g:vimwiki_list = [{'path': '~/wiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" }}
