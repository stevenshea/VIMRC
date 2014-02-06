"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimrc by XY
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Which OS?
if (has("win32") || has("win64") || has("win32unix"))
    let g:isWin = 1
else
    let g:isWin = 0
endif

" Console or GVIM?
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maximize window at WINOS
if ((g:isWin) && (g:isGUI))
    au GUIEnter * simalt ~x
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy manipulation of 'runtimepath', 'path', 'tags', etc
call pathogen#runtime_append_all_bundles()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent and tabstop
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"smartindent
set si

"tabstop
set ts=4

"shiftwidth
set sw=4

"expandtab
set et

"softtabstop
set sts=4

"autoindent
set ai



" Remove welcome msg
set shortmess=atI

" Ruler
set ru

" Line number
set nu

" Hide mouse when typing
set mh

" Use visual bell instead of beeping
set vb

set nocompatible

set dy=lastline

set backspace=indent,eol,start

colo northsky 

" Syntax highlight
sy on

set nobackup

set noswapfile

set hlsearch

set showmatch

"autochdir
set acd

"enable loading the plugin/indent files for specific file types
filetype on
filetype plugin indent on



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set charset, use utf8 by default
if (g:isWin)
    let &termencoding=&encoding " Text encoding under win is cp936 at most cases
    set fileencodings=utf8,cp936,ucs-bom,latin1

    " Set the menu & the message to English
    set langmenu=en_US
    let $LANG = 'en_US'
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
else
    set encoding=utf8
    set fileencodings=utf8,gb2312,gb18030,ucs-bom,latin1
endif





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusbar
set laststatus=2      " always display statusbar
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" Get current path, covert $HOME to ~
function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction
set statusline=[%n]\ %f%m%r%h\ \|\ \ pwd:\ %{CurDir()}\ \ \|%=\|\ %l,%c\ %p%%\ \|\ ascii=%b,hex=%b%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}\ \|\ %{$USER}\ @\ %{hostname()}\ 



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI options
if (g:isGUI)
    set go=i
    if (g:isWin)
        set guifont=Lucida_Console:h12:w6  " GUI font on WINOS
    else
        set guifont=Monospace\ 12          " GUI font on Linux
    endif
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard remapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab mappings 
map <M-1> 1gt 
map <M-2> 2gt 
map <M-3> 3gt 
map <M-4> 4gt 
map <M-5> 5gt 
map <M-6> 6gt 
map <M-7> 7gt 
map <M-8> 8gt 
map <M-9> 9gt 
map <M-t> :tabnew<CR> 
map <M-w> :tabclose<CR>
map! <M-1> <esc>1gt 
map! <M-2> <esc>2gt 
map! <M-3> <esc>3gt 
map! <M-4> <esc>4gt 
map! <M-5> <esc>5gt 
map! <M-6> <esc>6gt 
map! <M-7> <esc>7gt 
map! <M-8> <esc>8gt 
map! <M-9> <esc>9gt 
map! <M-t> <esc>:tabnew<CR> 
map! <M-w> <esc>:tabclose<CR>

" Toggle nerdtree and taglist
map <F1> :NERDTreeToggle<CR>
map <F2> :TlistToggle<CR>
map! <F1> <esc>:NERDTreeToggle<CR>
map! <F2> <esc>:TlistToggle<CR>

" Copy/Cut/Paste from system clipboard
map <F5> "+y
map <F6> "+x
map <F7> "+p



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Update the index of ctags and cscope
" href: http://www.vimer.cn/2009/10/把vim打造成一个真正的ide2.html
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F4> :call Do_CsTag()<CR>

function! Do_CsTag()
    let dir = getcwd()

    " first remove the current tags and cscope files, if cannot be deleted, prompt error
    if ( DeleteFile(dir, "tags") ) 
        return 
    endif
    if ( DeleteFile(dir, "cscope.files") ) 
        return 
    endif
    if ( DeleteFile(dir, "cscope.out") ) 
        return 
    endif

    if(executable('ctags'))
        silent! execute "!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:isWin)
            silent! execute "!dir /s/b *.c,*.cpp,*.cc,*.h,*.s,*.java >> cscope.files"
        else
            silent! execute "!find . -iname '*.[ch]' -o -name '*.cpp' > cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
    " redraw screen
    execute "redr!"
endfunction



function! DeleteFile(dir, filename)
    if filereadable(a:filename)
        if (g:isWin)
            let ret = delete(a:dir."\\".a:filename)
        else
            let ret = delete("./".a:filename)
        endif
        if (ret != 0)
            echohl WarningMsg | echo "Failed to delete ".a:filename | echohl None
            return 1
        else
            return 0
        endif
    endif
    return 0
endfunction



" cscope key binding
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
    
    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1 
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 1
" set the max list in the popup menu. increase the speed
let g:neocomplcache_max_list=20
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
let g:neocomplcache_auto_completion_start_length=1
" ignore letter case
let g:neocomplcache_enable_ignore_case=1

" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taglist
" Depend on Exuberant Ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Tlist_Auto_Highlight_Tag = 1
let g:Tlist_Auto_Open = 1
let g:Tlist_Auto_Update = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Use_Right_Window = 1

