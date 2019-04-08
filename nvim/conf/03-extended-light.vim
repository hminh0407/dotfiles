" Settings {
    " Appearance {
        " theme
        let g:airline_theme='base16'       " airline theme
        set background=dark
        let g:gruvbox_contrast_dark='hard' " colorscheme gruvbox
        silent! colorscheme gruvbox        " colorscheme gruvbox

        " set rnu                            " relative line number (impact performance)
        set nu                             " show current line number
        " set cursorline                     " highlight current line (impact performance)
        set splitbelow                     " split window below
        set splitright                     " split window to the right
    " }

    " Buffer {
        map <C-B><C-J> :bnext     <CR>
        map <C-B><C-K> :bprevious <CR>
        map <C-B><C-W> :bd        <CR>
        map <C-B><C-A> :bufdo bd  <CR>
        map <C-B><C-O> :only      <CR>

        set nowrap " do not wrap long line
        " Scroll 20 characters to the right
        nnoremap <C-L> 20zl
        " Scroll 20
        nnoremap <C-H> 20zh
        " Scroll down 5 characters
        nnoremap <C-J> 3<C-E>
        " Scroll up 5 characters
        nnoremap <C-K> 3<C-Y>
    " }

    " Folding {
        " map folding za to space
        nmap <space> za
        " Code folding options
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>

        set foldenable        " enable folding
        set foldlevelstart=2  " open most folds by default
        set foldnestmax=10    " 10 nested fold max
        " set foldmethod=indent " fold based on indent level
        set foldmethod=syntax " fold based on language specific syntax
        " enable syntax folding
        let sh_fold_enabled=1         " sh
        let vimsyn_folding='af'       " Vim script
        let xml_syntax_folding=1      " XML
    " }

    " Formatting {
        set colorcolumn=120
        " Tab & Indentation
        " Line
        set tw=120                " line break on 120 characters
        " Copy and paste
        set clipboard=unnamedplus " place yanked text to global clipboard
        " the set paste setting disable some features and can mess up key
        " mapping, should not use it
        " set paste                 " Paste from window or from Vim
    " }

    " Performance Tweak {
        " suggestion from https://stackoverflow.com/a/7187629
        set nocursorcolumn
        set nocursorline " seem to have a big impact on performance
        set norelativenumber
        set synmaxcol=200 " limit syntax highlight for long line
        syntax sync minlines=256
        " suggestion from https://superuser.com/a/302189
        set ttyfast " u got a fast terminal
        " set ttyscroll=5
    " }

" }


" Plugin Settings {

    " Calendar {
        let g:calendar_google_calendar = 1
        let g:calendar_google_task = 1
    " }

    " Fzf {
        " fuzzy search all files in root directory
        map <C-P>      :Files!<cr>
        " fuzzy search all history
        map <C-C>      :History!<cr>
        " fuzzy search line in current buffer
        map <C-F><C-B> :BLines<cr>
        " fuzzy search all commands
        map <C-F><C-C> :Command!<cr>
        " fuzzy search files in buffer
        map <C-F><C-E> :Buffers<cr>
        " fuzzy search lines in open buffer
        map <C-F><C-L> :Lines<cr>
        " fuzzy search tag in current file
        map <C-F><C-O> :BTags<cr>
        " fuzzy search files in parent directory of current file
        map <C-F><C-P> :FZFNeigh<cr>
        " fuzzy search most recently used files
        map <C-F><C-R> :FZFMru<cr>

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
          let command = 'ag -g "" -f ' . cwd . ' --depth 0'

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
        map <F1>   :NERDTreeFind<CR>
    " }

    " TrimWhitespace {
    fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfun
    " }

    " Wiki {
        " do not use vimwiki filetype for other files extensions (https://github.com/vimwiki/vimwiki/issues/95)
        let g:vimwiki_global_ext = 0
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
" }
