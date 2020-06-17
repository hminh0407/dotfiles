" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" General
" Plug 'tpope/vim-sensible'             " standard vim configuration (not neccessary for nvim)
Plug '907th/vim-auto-save'            " autosave
Plug 'szw/vim-maximizer'              " toggle maximizer for current pane
Plug 'tpope/vim-repeat'               " repeat support for plugins
Plug 'tpope/vim-sleuth'               " automatically adjusts 'shiftwidth' and 'expandtab'
Plug 'tpope/vim-surround'             " add, change, delete bracket, paren, carrot...
Plug 'ap/vim-buftabline'              " display buffer files in tabline, very handy
Plug 'wellle/targets.vim'             " extend text objects support
Plug 'ntpeters/vim-better-whitespace' " hightlight trailing whitespace
" Plug 'svermeulen/vim-easyclip' " simplify clipboard functionality for vim
    " cutlass and yoink are the modern implementation
    " but they are quite buggy at the moment
Plug 'svermeulen/vim-cutlass' " make delete operation only delete and not affect yank history
Plug 'svermeulen/vim-yoink'   " auto copy vim yank to clipboard and via versa

" Git
Plug 'tpope/vim-fugitive'     " extend git support
Plug 'airblade/vim-gitgutter' " show git diff for each line

" Markdown
" Plug 'vimwiki/vimwiki' " (though contain too much features, currently the best plugin to work with markdown) https://github.com/vimwiki/vimwiki
Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': { -> mkdp#util#install() } } " https://github.com/iamcco/markdown-preview.nvim

" Search
Plug 'google/vim-searchindex'          " show search information for each search
Plug 'haya14busa/vim-asterisk'         " https://github.com/haya14busa/vim-asterisk make *# work with visualized text
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                " fzf and vim integration
Plug 'dyng/ctrlsf.vim', { 'on': ['<Plug>CtrlSFPrompt', '<Plug>CtrlSFVwordPath', 'CtrlSFToggle'] } " search and replace plugin that support editing result
Plug 'justinmk/vim-sneak'     " enhance vim f search motion https://github.com/justinmk/vim-sneak

" Theme
Plug 'morhetz/gruvbox'       " Retro color scheme for vim (the best scheme)
Plug 'itchyny/lightline.vim' " status line and tab line plugin
Plug 'blueyed/vim-diminactive' " https://github.com/blueyed/vim-diminactive

" Text editor
Plug 'mhinz/vim-startify'             " fancy start screen for vim
Plug 'scrooloose/nerdtree',   { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }
" Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }
Plug 'editorconfig/editorconfig-vim'      " editorconfig plugin for vim https://github.com/editorconfig/editorconfig-vim
Plug 'junegunn/vim-easy-align'            " align text
Plug 'tpope/vim-commentary'               " comment plugin
Plug 'jiangmiao/auto-pairs'               " auto close pairs (quotes, parens, brackets ...)
" Plug 'rhysd/vim-grammarous' " https://github.com/rhysd/vim-grammarous
Plug 'majutsushi/tagbar'           " display tag of current file in a window
Plug 'tpope/vim-abolish'              " Abbreviation & Coercion. Ex: crc-camel, crs-snake (could just write custom function)
Plug 'Yggdroot/indentLine'            " https://github.com/Yggdroot/indentLine#readme (conflict with vimwiki)

" Utilities
Plug 'sk1418/HowMuch'       " calculator for visual selection
" Plug 'itchyny/calendar.vim' " https://github.com/itchyny/calendar.vim

if executable('node') && executable('npm') " use coc if possible
    " Awesome intellisense tool that make vim work like VSCode
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

if executable('tmux')
    " Plug 'wellle/tmux-complete.vim' " complete for tmux integration
    Plug 'christoomey/vim-tmux-navigator' " tmux integration https://github.com/christoomey/vim-tmux-navigator
    " Plug 'wincent/terminus' " https://github.com/wincent/terminus, cursor shape change in insert and replace mode
endif

if executable('ctags')
    Plug 'ludovicchabant/vim-gutentags'
endif

" Language support
Plug 'chr4/nginx.vim', { 'for': 'conf' } " support nginx syntax (https://github.com/chr4/nginx.vim)
Plug 'aklt/plantuml-syntax', { 'for': 'uml' } " syntax support for plantuml
" Plug 'jidn/vim-dbml', { 'for': 'dbml' } " https://github.com/jidn/vim-dbml support dbml language
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } " support JS syntax and folding (https://github.com/pangloss/vim-javascript)

" Initialize plugin system
call plug#end()

" auto install missing plugins on startup
autocmd VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   PlugInstall --sync | q
            \| endif
