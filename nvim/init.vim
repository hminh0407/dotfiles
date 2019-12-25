" this script will automatically install vim-plug.
" It should be placed before plug#begin() call
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

for f in split(glob('~/.vim/conf/*.vim'), '\n')
    exe 'source' f
endfor
