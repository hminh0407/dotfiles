" Settings sql
" }

" Plugin Settings {
    " Autoformat {
        " require: pip install sqlparser
        let g:formatdef_sql = '"sqlformat --reindent --keywords upper --identifiers lower -"'
        let g:formatters_sql = ['sql']
    " }
" }

