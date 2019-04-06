for f in split(glob('~/.config/nvim/conf/*.vim'), '\n')
    exe 'source' f
endfor
