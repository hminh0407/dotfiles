" This file store plugins that were tried but nolong fit the work flow. Should be used as a source of reference only

Plug 'tpope/vim-sensible'          " (if using neovim, does not need this) standard vim configuration
Plug 'janko-m/vim-test'            " note use much
Plug 'christoomey/vim-tmux-runner' " vim-test strategy for integration with tmux (note use much)
Plug 'tenfyzhong/tagbar-markdown.vim' , { 'for': 'markdown' } "support tagbar with markdown https://github.com/tenfyzhong/tagbar-markdown.vim (not use much)
Plug 'kannokanno/previm'    , {'for': 'markdown'} " support mermaid (https://github.com/previm/previm)
Plug 'nelstrom/vim-markdown-folding' , {'for': 'markdown'} " folding support for markdown, does not need this plugin as folding has already been supported in vim-wiki
Plug 'tpope/vim-dadbod' " does not support async operation, therefore very slow to be effective (should use mycli or pgcli instead)
Plug 'wannesm/wmgraphviz.vim' " graphviz dot support for vim https://github.com/wannesm/wmgraphviz.vim (not use much)
Plug 'dbeniamine/cheat.sh-vim'     " query for code example with cheat.sh engine https://github.com/chubin/cheat.sh (not use much)
Plug 'baverman/vial'               " framework to write plugins in Python
Plug 'baverman/vial-http'          " (currently the best), rest client for vim https://github.com/baverman/vial-http (not practical)
Plug 'diepm/vim-rest-console'      " http client for vim https://github.com/diepm/vim-rest-console (not practical)
Plug 'weirongxu/plantuml-previewer.vim' " preview plantuml in browser https://github.com/weirongxu/plantuml-previewer.vim (It's better to open with chromium and plantuml support extensions)
Plug 'w0rp/ale'                    " syntax linting (vim-coc is more powerful)
Plug 'Chiel92/vim-autoformat'      " auto format code (vim-coc is more powerful)
Plug 'prabirshrestha/asyncomplete-tags.vim' " note use much
Plug 'tpope/vim-unimpaired'    " add tone of pair features https://github.com/tpope/vim-unimpaired
                             " mostly used for '[u' to encode and ']u' to decode url (could just write custom function)
Plug 'tpope/vim-abolish'              " Abbreviation & Coercion. Ex: crc-camel, crs-snake (could just write custom function)

Plug 'AndrewRadev/splitjoin.vim'      " use case is limited support split/join multiline https://github.com/AndrewRadev/splitjoin.vim
Plug 'tyru/open-browser.vim', { 'for': 'markdown' } " not use much - open uri with system browser, work well with previm and vimwiki
Plug 'junegunn/vim-slash'     " https://github.com/junegunn/vim-slash
    " (conflict with vim-searchindex)
    " Automatically clears search highlight when cursor is moved
    " Improved star-search (visual-mode, highlighting without moving)
    "
Plug 'joshdick/onedark.vim'  " (not as good as gruvbox)
Plug 'ryanoasis/vim-devicons' " https://github.com/ryanoasis/vim-devicons Add icons for nerdtree (not neccessary, besides require installing special font to work)
Plug 'Yggdroot/indentLine'            " https://github.com/Yggdroot/indentLine#readme (conflict with vimwiki)
Plug 'coderifous/textobj-word-column.vim' " https://github.com/coderifous/textobj-word-column.vim
    " Not actually need it since the actions can be done with visual block easily
    " This plugin adds ic, ac, iC, and aC as text-objects. Use them in commands like vic, cic, and daC.

Plug 'junegunn/vim-emoji' " https://github.com/junegunn/vim-emoji
    " conflict with other completion plugin
