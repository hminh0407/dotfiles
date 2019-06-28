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
  Plug 'tpope/vim-sensible'      " standard vim configuration
  Plug '907th/vim-auto-save'     " autosave
  Plug 'szw/vim-maximizer'       " toggle maximizer for current pane
  Plug 'tpope/vim-repeat'        " repeat support for plugins
  Plug 'tpope/vim-sleuth'        " automatically adjusts 'shiftwidth' and 'expandtab'
  Plug 'mhinz/vim-startify'      " fancy start screen for vim
  Plug 'ap/vim-buftabline'       " display buffer files in tabline, very handy
  Plug 'svermeulen/vim-easyclip' " simplify clipboard functionality for vim
  Plug 'itchyny/calendar.vim'    " https://github.com/itchyny/calendar.vim
  Plug 'vimwiki/vimwiki'         " https://github.com/vimwiki/vimwiki
  Plug 'rhysd/clever-f.vim'      " https://github.com/rhysd/clever-f.vim
  Plug 'tpope/vim-unimpaired'    " add tone of pair features https://github.com/tpope/vim-unimpaired
                                 " mostly used for '[u' to encode and ']u' to decode url

  " Git
  Plug 'tpope/vim-fugitive'     " extend git support
  Plug 'airblade/vim-gitgutter' " show git diff for each line

  " Markdown
  Plug 'tyru/open-browser.vim' " open uri with system browser, work well with previm
  Plug 'kannokanno/previm'    , {'for': 'markdown'} " support mermaid (https://github.com/previm/previm)
  " does not need this plugin as folding has already been supported in vim-wiki
  " Plug 'nelstrom/vim-markdown-folding' , {'for': 'markdown'} " folding support for markdown

  " Navigation
  Plug 'scrooloose/nerdtree',         { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }

  " Search
  Plug 'google/vim-searchindex'          " show search information for each search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'                " fzf and vim integration
  Plug 'dyng/ctrlsf.vim'                 " search and replace plugin that support editing result

  " Theme
  Plug 'morhetz/gruvbox'               " Retro color scheme for vim
  Plug 'itchyny/lightline.vim'         " status line and tab line plugin

  " Text editor
  Plug 'tpope/vim-surround'             " add, change, delete bracket, paren, carrot...
  Plug 'junegunn/vim-easy-align'        " align text
  Plug 'tpope/vim-commentary'           " comment plugin
  Plug 'wellle/targets.vim'             " extend text objects support
  Plug 'jiangmiao/auto-pairs'           " auto close pairs (quotes, parens, brackets ...)
  Plug 'ntpeters/vim-better-whitespace' " hightlight trailing whitespace
  Plug 'tpope/vim-abolish'              " Abbreviation & Coercion (can convert case. ex:snake,camel,mix,dot...)
  Plug 'sk1418/HowMuch'                 " calculator for visual selection

" }

" Advance {
  " asynccompletor with vim lsp to support auto complete (lighter and faster than youcompleteme)
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'ryanolsonx/vim-lsp-python'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'wellle/tmux-complete.vim'
  if executable('ctags')
    Plug 'prabirshrestha/asyncomplete-tags.vim'
    Plug 'ludovicchabant/vim-gutentags'
  endif
  " if having problem with error 'failed to initialize pyls with error pycodestyle'. Try below (install with sudo to apply for all user)
  " sudo pip uninstall python-language-server
  " sudo pip install setuptools --upgrade
  " sudo pip install python-language-server

  " Dadbod (Database connection)
  " Plug 'tpope/vim-dadbod' " has not support async yet https://github.com/tpope/vim-dadbod

  " Direnv
  " Plug 'direnv/direnv.vim' " integrate with direnv https://github.com/direnv/direnv.vim

  " Graphviz
  " Plug 'wannesm/wmgraphviz.vim' " graphviz dot support for vim https://github.com/wannesm/wmgraphviz.vim

  " Language support
  Plug 'Chiel92/vim-autoformat'      " auto format code
  Plug 'janko-m/vim-test'            " unit test tool
  Plug 'christoomey/vim-tmux-runner' " vim-test strategy for integration with tmux
  Plug 'majutsushi/tagbar'           " display tag of current file in a window
  Plug 'w0rp/ale'                    " syntax linting
  Plug 'dbeniamine/cheat.sh-vim'     " query for code example with cheat.sh engine https://github.com/chubin/cheat.sh

  " Http Client
  " Plug 'baverman/vial'               " framework to write plugins in Python
  " Plug 'baverman/vial-http'          " (currently the best), rest client for vim https://github.com/baverman/vial-http
  Plug 'diepm/vim-rest-console'      " http client for vim https://github.com/diepm/vim-rest-console

  " Plantuml
  Plug 'aklt/plantuml-syntax'             " syntax support for plantuml
  " It's better to open with chromium and plantuml support extensions
  " Plug 'weirongxu/plantuml-previewer.vim' " preview plantuml in browser https://github.com/weirongxu/plantuml-previewer.vim

  " Snippets
  Plug 'Shougo/neosnippet.vim'                      " https://github.com/Shougo/neosnippet.vim
  Plug 'prabirshrestha/asyncomplete-neosnippet.vim' " integration with asyncomplete

  " Tag
  Plug 'ludovicchabant/vim-gutentags' " auto generate tag files
" }

" Initialize plugin system
call plug#end()

" auto install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
