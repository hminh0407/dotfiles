" Settings sql
" auto set dir to current file if file is in folder "*dadbod*"
autocmd BufEnter * if expand("%:p:h") =~ 'dadbod' | silent! lcd %:p:h | endif
" }

" Plugin Settings {
    " Autoformat {
        " require: pip install sqlparser
        let g:formatdef_sql = '"sqlformat --reindent --keywords upper --identifiers lower -"'
        let g:formatters_sql = ['sql']
    " }
" }

