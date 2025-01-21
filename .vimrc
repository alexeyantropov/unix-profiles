syntax on
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set regexpengine=1
set viminfo='1000,h
set nofoldenable

" Makes vim jumps at the last position in a file.
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif
