" It's better to open with chromium and plantuml-viewer  extension (need to update extension config to 'Allow Access To File URL')
" map <silent><buffer> <F5> :exe ':silent !chromium-browser %'<CR>
map <silent><buffer> <F5> :call OpenUml()<CR>

" This method use https://github.com/weirongxu/plantuml-previewer.vim
" map <silent><buffer> <F5>  :PlantumlOpen<CR>
" map <silent><buffer> <F6>  :PlantumlStop<CR>

function! OpenUml()
    let home = $HOME
    let plantwebExist = executable('plantweb')
    let currentFolder = expand('%:p:h')
    let currentFile = expand('%')
    let currentFileWithoutExtension = expand('%:r')
    let tmpFolder = home . "/tmp"
    let createFolder = mkdir(tmpFolder, "p")

    if !plantwebExist
        return
    endif

    " generate svg file
    execute "!plantweb --format svg " . currentFolder . "/" . currentFile

    let generatedFile = currentFileWithoutExtension . ".svg"
    let generatedFilePath = currentFolder . "/" . generatedFile
    let tmpFilePath = tmpFolder . "/" . generatedFile

    " move file to tmp folder
    silent execute "!mv " . generatedFilePath . " " . tmpFilePath

    " open file with chrome
    silent execute "!chromium-browser " . tmpFilePath

endfunction
