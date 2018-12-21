set ruler
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'Valloric/YouCompleteMe'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'fholgado/minibufexpl.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Obviously, I have my own color scheme
colorscheme chrisrossi

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Navigating buffers
let g:miniBufExplModSelTarget = 1
map <A-right> :MBEbn<CR>
map <A-left> :MBEbp<CR>
map <A-1> :b1<CR>
map <A-2> :b2<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" Use system clipboard
set clipboard=unnamedplus

" Pep8
au BufNewFile,BufRead *.py set
    \ autoindent
    \ fileformat=unix

set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set cc=80
let python_highlight_all=1
syntax on

"Strip trailing whitespace from Python source files
autocmd BufWritePre *.py :%s/\s\+$//e

" Other files
au BufNewFile,BufRead *.js,*.html,*.css set
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

"Handlebars
au BufRead,BufNewFile *.handlebars,*.hbs set ft=handlebars

"ZPT
au BufRead,BufNewFile *.pt set ft=html
autocmd Filetype html setlocal ts=2 sts=2 sw=2

"syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--max-line-length=80'
let g:syntastic_full_redraws = 1
let g:syntastic_enable_signs = 0

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Some useful keyboard shortcuts
map <leader>q :qall<CR>
map <leader>w :bd<CR>

" Always leave 10 lines visible at top or bottom of screen
set scrolloff=10

" Makes mousing more intuitive in terminal?
:set mouse=a

" 256 colors
set t_Co=256

" Allow backspace to deindent automatically indented text
set backspace=2

" Add the virtualenv's site-packages to vim path
py << EOF
import os
import sys

def activate_virtual_env(project_base_dir):
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin', 'activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))

def activate_buildout(folder):
    bin_folder = os.path.join(folder, 'bin')
    old_path = os.environ.get('PATH', '')
    os.environ['PATH'] = bin_folder + os.pathsep + old_path
    bin_py = os.path.join(bin_folder, 'py')
    code = open(bin_py).read()
    code = code[:code.index('\n_interactive')]
    exec code

if 'VIRTUAL_ENV' in os.environ:
    # Use virtual env if one is activated (rare for me)
    activate_virtual_env(os.environ['VIRTUAL_ENV'])

else:
    # Walk up tree looking for a buildout or virtual environment 
    # to activate
    folder = os.getcwd()
    while folder != '/':
        bin_py = os.path.join(folder, 'bin', 'py')
        if os.path.exists(bin_py):
            activate_buildout(folder)
            break

        activate_this = os.path.join(folder, 'bin', 'activate_this.py')
        if os.path.exists(activate_this):
            activate_virtual_env(folder)
            break

        activate_this = os.path.join(folder, 'venv', 'bin', 'activate_this.py')
        if os.path.exists(activate_this):
            activate_virtual_env(os.path.join(folder, 'venv'))
            break

        folder = os.path.split(folder)[0]
EOF
