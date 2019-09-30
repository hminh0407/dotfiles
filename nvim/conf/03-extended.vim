" Settings {
" Appearance {
if exists('+termguicolors') " enable true color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" theme
set background=dark
" set background=light
" let g:gruvbox_contrast_dark='soft' " colorscheme gruvbox
" let g:gruvbox_contrast_light='soft' " colorscheme gruvbox
silent! colorscheme gruvbox        " colorscheme gruvbox

" set rnu                            " relative line number (impact performance)
set nu                             " show line number
" set cursorline                     " highlight current line (impact performance)
set splitbelow                     " split window below
set splitright                     " split window to the right
" }

" Buffer {
map <C-B><C-J> :bnext     <CR>
map <C-B><C-K> :bprevious <CR>
map <C-B><C-W> :bd        <CR>
" map <C-B><C-A> :bufdo bd  <CR>

set nowrap " do not wrap long line
" Scroll 20 characters to the right
" nnoremap <C-L> 20zl
nnoremap <C-M> 20zl
" Scroll 20
" nnoremap <C-H> 20zh
nnoremap <C-Q> 20zh
" Scroll down 5 characters
" nnoremap <C-J> 3<C-E>
nnoremap <C-e> 3<C-e>
" Scroll up 5 characters
" nnoremap <C-K> 3<C-Y>
nnoremap <C-y> 3<C-Y>

" auto remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
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

" Mapping {
" increase number
map <A-a> <C-a>
" decrease number
map <A-x> <C-x>
" join 2 lines without moving cursor
:nnoremap <silent> J :let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>
let g:BASH_Ctrl_j = 'off'
" windo diff toggle
nmap <silent> <F8> :call ToggleDiff()<CR>
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

" UtilFunctions {

" ToggleDiff {
fun! ToggleDiff ()
    if (&diff)
        :windo diffof
    else
        :windo diffthis
    endif
endfunction
" }

" TrimEmptyLine {
fun! TrimEmptyLine()
    let _s=@/
    let l = line(".")
    let c = col(".")
    :g/^\n\{1,}/d
    let @/=_s
    call cursor(l, c)
endfun
" }

" TrimWhitespace {
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" }

" TrimToOnceSpace {
" If there more than one space trim it to one space
fun! TrimToOneSpace()
    %s/ \{2,}/ /g
endfun
" }
" }
