" Settings {{
" Appearance {{
if exists('+termguicolors') " enable true color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set showcmd

" theme
silent! colorscheme gruvbox        " colorscheme gruvbox
let g:gruvbox_contrast_dark='medium'
set background=dark
" let g:gruvbox_contrast_light='soft'
" set background=light

" set rnu                            " relative line number (impact performance)
set nu                             " show line number
" set cursorline                     " highlight current line (impact performance)
set splitbelow                     " split window below
set splitright                     " split window to the right
" }}

" Buffer {{
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

" auto remove trailing whitespace on buffer write
autocmd BufWritePre * %s/\s\+$//e

set mouse=a
" }}

" Folding {{
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
" }}

" Formatting {{
" set colorcolumn=120
" Tab & Indentation
" Line
set tw=120                " line break on 120 characters
" Copy and paste
set clipboard=unnamedplus " place yanked text to global clipboard
" the set paste setting disable some features and can mess up key
" mapping, should not use it
" set paste                 " Paste from window or from Vim
" }}

" Mapping {{
nnoremap Y y$
    " only yank to end of line not contain new line character

" delete without yanking
nnoremap d "_d
vnoremap d "_d

" replace currently selected text with default register without yanking it
vnoremap p "_dP

map <A-a> <C-a>
    " increase number

map <A-x> <C-x>
    " decrease number

nnoremap <leader>nh :noh<CR>

:nnoremap <silent> J :let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>
    " join 2 lines without moving cursor

let g:BASH_Ctrl_j = 'off'

nmap <silent> <F8> :call ToggleDiff()<CR>
    " windo diff toggle
" }}

" Netrw {{
let g:netrw_banner=0
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'

"toggle netrw on the left side of the editor
nnoremap <leader>n :Lexplore<CR>
" }}

" Performance Tweak {{
" suggestion from https://stackoverflow.com/a/7187629
set nocursorcolumn
set nocursorline " seem to have a big impact on performance
set norelativenumber
set synmaxcol=200 " limit syntax highlight for long line
syntax sync minlines=256
" suggestion from https://superuser.com/a/302189
set ttyfast " u got a fast terminal
" set ttyscroll=5
" }}

" }}

" UtilFunctions {{

" ToggleDiff {{
fun! ToggleDiff ()
    if (&diff)
        :windo diffof
    else
        :windo diffthis
    endif
endfunction
" }}

" TrimEmptyLine {{
fun! TrimEmptyLine()
    let _s=@/
    let l = line(".")
    let c = col(".")
    :g/^\n\{1,}/d
    let @/=_s
    call cursor(l, c)
endfun
" }}

" TrimWhitespace {{
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" }}

" TrimToOnceSpace {{
" If there more than one space trim it to one space
fun! TrimToOneSpace()
    %s/ \{2,}/ /g
endfun
" }}
" }}

" CopyMatches https://vim.fandom.com/wiki/Copy_search_matches
" Plugin to copy matches (search hits which may be multiline).
" Version 2012-05-03 from http://vim.wikia.com/wiki/VimTip478
"
" :CopyMatches      copy matches to clipboard (each match has newline added)
" :CopyMatches x    copy matches to register x
" :CopyMatches X    append matches to register x
" :CopyMatches -    display matches in a scratch buffer (does not copy)
" :CopyMatches pat  (after any of above options) use 'pat' as search pattern
" :CopyMatches!     (with any of above options) insert line numbers
" Same options work with the :CopyLines command (which copies whole lines).

" Jump to first scratch window visible in current tab, or create it.
" This is useful to accumulate results from successive operations.
" Global function that can be called from other scripts.
function! GoScratch()
  let done = 0
  for i in range(1, winnr('$'))
    execute i . 'wincmd w'
    if &buftype == 'nofile'
      let done = 1
      break
    endif
  endfor
  if !done
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
  endif
endfunction

" Append match, with line number as prefix if wanted.
function! s:Matcher(hits, match, linenums, subline)
  if !empty(a:match)
    let prefix = a:linenums ? printf('%3d  ', a:subline) : ''
    call add(a:hits, prefix . a:match)
  endif
  return a:match
endfunction

" Append line numbers for lines in match to given list.
function! s:MatchLineNums(numlist, match)
  let newlinecount = len(substitute(a:match, '\n\@!.', '', 'g'))
  if a:match =~ "\n$"
    let newlinecount -= 1  " do not copy next line after newline
  endif
  call extend(a:numlist, range(line('.'), line('.') + newlinecount))
  return a:match
endfunction

" Return list of matches for given pattern in given range.
" If 'wholelines' is 1, whole lines containing a match are returned.
" This works with multiline matches.
" Work on a copy of buffer so unforeseen problems don't change it.
" Global function that can be called from other scripts.
function! GetMatches(line1, line2, pattern, wholelines, linenums)
  let savelz = &lazyredraw
  set lazyredraw
  let lines = getline(1, line('$'))
  new
  setlocal buftype=nofile bufhidden=delete noswapfile
  silent put =lines
  1d
  let hits = []
  let sub = a:line1 . ',' . a:line2 . 's/' . escape(a:pattern, '/')
  if a:wholelines
    let numlist = []  " numbers of lines containing a match
    let rep = '/\=s:MatchLineNums(numlist, submatch(0))/e'
  else
    let rep = '/\=s:Matcher(hits, submatch(0), a:linenums, line("."))/e'
  endif
  silent execute sub . rep . (&gdefault ? '' : 'g')
  close
  if a:wholelines
    let last = 0  " number of last copied line, to skip duplicates
    for lnum in numlist
      if lnum > last
        let last = lnum
        let prefix = a:linenums ? printf('%3d  ', lnum) : ''
        call add(hits, prefix . getline(lnum))
      endif
    endfor
  endif
  let &lazyredraw = savelz
  return hits
endfunction

" Copy search matches to a register or a scratch buffer.
" If 'wholelines' is 1, whole lines containing a match are returned.
" Works with multiline matches. Works with a range (default is whole file).
" Search pattern is given in argument, or is the last-used search pattern.
function! s:CopyMatches(bang, line1, line2, args, wholelines)
  let l = matchlist(a:args, '^\%(\([a-zA-Z"*+-]\)\%($\|\s\+\)\)\?\(.*\)')
  let reg = empty(l[1]) ? '+' : l[1]
  let pattern = empty(l[2]) ? @/ : l[2]
  let hits = GetMatches(a:line1, a:line2, pattern, a:wholelines, a:bang)
  let msg = 'No non-empty matches'
  if !empty(hits)
    if reg == '-'
      call GoScratch()
      normal! G0m'
      silent put =hits
      " Jump to first line of hits and scroll to middle.
      ''+1normal! zz
    else
      execute 'let @' . reg . ' = join(hits, "\n") . "\n"'
    endif
    let msg = 'Number of matches: ' . len(hits)
  endif
  redraw  " so message is seen
  echo msg
endfunction
command! -bang -nargs=? -range=% CopyMatches call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 0)
command! -bang -nargs=? -range=% CopyLines call s:CopyMatches(<bang>0, <line1>, <line2>, <q-args>, 1)
