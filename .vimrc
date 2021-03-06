set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Lokaltog/vim-powerline'
Plugin 'https://github.com/tpope/vim-commentary.git'
Plugin 'https://github.com/terryma/vim-smooth-scroll.git'
Plugin 'https://github.com/tomasr/molokai.git'
Plugin 'https://github.com/fholgado/minibufexpl.vim.git'
Plugin 'Chiel92/vim-autoformat'
Plugin 'scrooloose/nerdtree'
call vundle#end()
filetype plugin indent on
syntax on

set autoindent
set ts=4
set st=4
set sw=4
set expandtab
set smarttab
set nu
set background=dark
set t_Co=256
set laststatus=2

colorscheme molokai

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

let g:Powerline_symbols = 'fancy'
let g:Powerline_colorscheme = 'solarized256'
let g:Powerline_theme = 'solarized256'

nnoremap <F9> :call Compile()<CR>
function Compile()
    exec "w"
    if &filetype == "cpp"
        exec "!clear && echo Compiling... && g++ -std=c++11 -Wall %"
        if v:shell_error == 0
            exec "!./a.out"
        endif
    elseif &filetype == "python"
        exec "!clear && python3 %"
    elseif &filetype == "java"
        exec "!clear && echo Compiling... && javac %"
        if v:shell_error == 0
            exec "!java %<"
        endif
    else
        echo &filetype
        echo "Not considered!"
    endif
endfunction

set completeopt=longest,menu
let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py', '~/cppcode/*']
let g:ycm_seed_identifiers_with_syntax = 1

nmap <Leader>fl :NERDTreeToggle<CR>
let NERDTreeWinSize=20
let NERDTreeWinPos="right"
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1

nmap <Leader>bl :MBEToggle<CR>
let g:miniBufExplVSplit = 20 
let g:miniBufExplBRSplit = 0 
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

