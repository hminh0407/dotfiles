" It's better to open with chromium and plantuml support extensions
" map <silent><buffer> <F5>  :PlantumlOpen<CR>
" map <silent><buffer> <F6>  :PlantumlStop<CR>
map <silent><buffer> <F5> :exe ':silent !chromium-browser %'<CR>
