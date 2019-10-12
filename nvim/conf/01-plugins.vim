" this script will automatically install vim-plug.
" It should be placed before plug#begin() call
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Core {
" General
Plug 'tpope/vim-sensible'     " standard vim configuration
Plug '907th/vim-auto-save'    " autosave
Plug 'szw/vim-maximizer'      " toggle maximizer for current pane
Plug 'tpope/vim-repeat'       " repeat support for plugins
Plug 'tpope/vim-sleuth'       " automatically adjusts 'shiftwidth' and 'expandtab'
Plug 'mhinz/vim-startify'     " fancy start screen for vim
Plug 'ap/vim-buftabline'      " display buffer files in tabline, very handy
Plug 'svermeulen/vim-easyclip' " simplify clipboard functionality for vim (old
" plugin, use cutclass and yoink instead)
" Plug 'svermeulen/vim-cutlass' " make delete operation only delete and not affect yank history
" Plug 'svermeulen/vim-yoink'   " auto copy vim yank to clipboard and via versa
Plug 'justinmk/vim-sneak'     " enhance vim f search motion https://github.com/justinmk/vim-sneak
Plug 'scrooloose/nerdtree',   { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }

" Git
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }
Plug 'tpope/vim-fugitive'     " extend git support
Plug 'airblade/vim-gitgutter' " show git diff for each line

" Markdown
Plug 'vimwiki/vimwiki' " (though contain too much features, currently the best plugin to work with markdown) https://github.com/vimwiki/vimwiki
" Plug 'tyru/open-browser.vim', { 'for': 'markdown' } " open uri with system browser, work well with previm and vimwiki

" Search
Plug 'google/vim-searchindex'          " show search information for each search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                " fzf and vim integration
Plug 'dyng/ctrlsf.vim', { 'on': ['<Plug>CtrlSFPrompt', '<Plug>CtrlSFVwordPath', 'CtrlSFToggle'] } " search and replace plugin that support editing result

" Theme
Plug 'morhetz/gruvbox'       " Retro color scheme for vim (the best scheme)
" Plug 'joshdick/onedark.vim'  " (not as good as gruvbox)
Plug 'itchyny/lightline.vim' " status line and tab line plugin

" Text editor
Plug 'editorconfig/editorconfig-vim'  " editorconfig plugin for vim https://github.com/editorconfig/editorconfig-vim
Plug 'tpope/vim-surround'             " add, change, delete bracket, paren, carrot...
Plug 'junegunn/vim-easy-align'        " align text
Plug 'tpope/vim-commentary'           " comment plugin
Plug 'wellle/targets.vim'             " extend text objects support
Plug 'jiangmiao/auto-pairs'           " auto close pairs (quotes, parens, brackets ...)
Plug 'ntpeters/vim-better-whitespace' " hightlight trailing whitespace
" }

" Utilities
Plug 'sk1418/HowMuch'       " calculator for visual selection
Plug 'itchyny/calendar.vim' " https://github.com/itchyny/calendar.vim

if executable('node') && executable('npm') " use coc if possible
    " Awesome intellisense tootl that make vim work like VSCode
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
else
    " asynccompletor with vim lsp to support auto complete (lighter and faster than youcompleteme)
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-buffer.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'prabirshrestha/asyncomplete-neosnippet.vim' " integration with asyncomplete

    Plug 'Shougo/neosnippet.vim'                      " https://github.com/Shougo/neosnippet.vim
endif

if executable('tmux')
    Plug 'wellle/tmux-complete.vim' " complete for tmux integration
    Plug 'christoomey/vim-tmux-navigator' " tmux integration https://github.com/christoomey/vim-tmux-navigator
endif

" Advance {
if executable('ctags')
    Plug 'ludovicchabant/vim-gutentags'
endif

" Awesome intellisense tootl that make vim work like VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Language support
Plug 'majutsushi/tagbar'           " display tag of current file in a window
Plug 'chr4/nginx.vim', { 'for': 'conf' } " support nginx syntax (https://github.com/chr4/nginx.vim)

" Plantuml
Plug 'aklt/plantuml-syntax', { 'for': 'uml' } " syntax support for plantuml
" }

" Initialize plugin system
call plug#end()

" auto install missing plugins on startup
autocmd VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   PlugInstall --sync | q
            \| endif
