" ----------------------------- Vundle Start -----------------------------
set nocompatible
filetype on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'winmanager'
Plugin 'SuperTab'
Plugin 'scrooloose/nerdtree-git-plugin'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'taglist.vim'
Plugin 'a.vim'
Plugin 'w0rp/ale' "语法检查
"Plugin 'Neocomplete
"Plugin 'Valloric/YouCompleteMe' "自动补全
call vundle#end()
filetype plugin indent on
 "----------------------------- Vundle End   -----------------------------"

syntax on
"winpos 5 5
"set lines=40 columns=155
set go="color asmanian2"
set guifont=Courier_New:h10:cANSI
autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul
set ruler
set showcmd
"set cmdheight=1
"set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离
set novisualbell    " 不要闪烁
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容
set laststatus=1    " 启动显示状态行(1),总是显示状态行(2)
"set foldenable      " 允许折叠
set foldmethod=manual   " 手动折叠
"set background=dark "背景使用黑色
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif
" 设置配色方案
colorscheme morning

"字体
if (has("gui_running"))
   set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
endif

"自动跳到上次关闭时光标所在行
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"--------------新建.c,.h,.sh,.java文件，自动插入文件头-----------------------------
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'sh'
        call setline(1,"\***************************************************************************")
        call append(line("."), "*File Name: ".expand("%"))
        call append(line(".")+1, "*Author: WenZhiming")
        call append(line(".")+2, "*mail: iwenzhiming@163.com")
        call append(line(".")+3, "*Created Time: ".strftime("%c"))
        call append(line(".")+4, "*Last Modified: ".strftime("%c"))
        call append(line(".")+5, "*Description: ")
        call append(line(".")+6, "\*************************************************************************")
        call append(line(".")+7, "\#! /bin/bash")
        call append(line(".")+8, "")
    else
        call setline(1, "/***************************************************************************")
        call append(line("."), "*File Name: ".expand("%"))
        call append(line(".")+1, "*Author: WenZhiming")
        call append(line(".")+2, "*Mail: iwenzhiming@163.com ")
        call append(line(".")+3, "*Created Time: ".strftime("%c"))
        call append(line(".")+4, "*Last Modified: ".strftime("%c"))
        call append(line(".")+5, "*Description: ")
        call append(line(".")+6, "************************************************************************/")
        call append(line(".")+7, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+8, "#include<iostream>")
        call append(line(".")+10, "")
    endif
    if &filetype == 'c'
        call append(line(".")+8, "#include<stdio.h>")
        call append(line(".")+9, "#include<stdlib.h>")
        call append(line(".")+10, "#include<string.h>")
        call append(line(".")+11, "")
    endif
    autocmd BufNewFile * normal G
endfunc
"--------------------------------------------------------------------------------------

"------------------------------自动修改Last Modified时间-------------------
autocmd BufWritePre *.cpp,*.h,*.c,*.sh exec ":call TimeStamp('*')"
func TimeStamp(...)  
     let sbegin = ''  
     let send = ''  
     let pend = ''  
     if a:0 >= 1  
         let sbegin = '' . a:1  
         let sbegin = substitute(sbegin, '*', '\\*', "g")  
         let sbegin = sbegin . '\s*'  
     endif  
     if a:0 >= 2  
         let send = '' . a:2  
         let pend = substitute(send, '*', '\\*', "g")  
     endif  
     let pattern = 'Last Modified: .\+' . pend  
     let pattern = '^\s*' . sbegin . pattern . '\s*$'  
     "let now = strftime('%Y-%m-%d %H:%M:%S',localtime())  
     let now = strftime("%c")  

     let row = search(pattern, 'n')  
     if row  == 0  
         let now = a:1 . 'Last Modified:  ' . now . send  
         call append(2, now)  
     else  
         let curstr = getline(row)  

         let col = match( curstr , 'Last')  
         let now = a:1 . 'Last Modified:  ' . now . send  
         call setline(row, now)  
     endif  
 endfunc

 "----------------------------------------------------------------------------
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>
" 映射全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc>ggVGY
map <F12> gg=G
" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y
"去空行
nnoremap <F2> :g/^\s*$/d<CR>
"比较文件
nnoremap <C-F2> :vert diffsplit
"新建标签
map <M-F2> :tabnew<CR>
"列出当前目录文件
map <F3> :tabnew .<CR>
"打开树状文件目录
map <C-F3> \be
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"代码补全
set completeopt=preview,menu
"允许插件
filetype plugin on
"共享剪贴板
set clipboard+=unnamed
"从不备份
set nobackup
"make 运行
:set makeprg=g++\ -Wall\ \ %
"自动保存
set autowrite
set ruler                   " 打开状态栏标尺
"set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
"set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\
" 设置在状态行显示的信息
set foldcolumn=0
"1. manual //手工定义折叠 
"2. indent //用缩进表示折叠 
"3. expr　//用表达式来定义折叠 
"4. syntax //用语法高亮来定义折叠 
"5. diff //对没有更改的文本进行折叠
"6. marker //用标志折叠 "
set foldmethod=indent
set foldlevel=99 
"set foldenable              " 开始折叠
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 语法高亮
set syntax=on
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
"自动对齐
set ai
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 总是显示状态行
set laststatus=2
" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 为C程序提供自动缩进
set smartindent
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt


"------------------------------自动补全---------------------------------------
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {<CR>}<ESC>O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
filetype plugin indent on
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu
"-----------------------------------------------------------------------------


"-------------------------CTags settings--------------------------------------
let Tlist_Sort_Type = "name"    " 按照名称排序
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口
let Tlist_Compart_Format = 1    " 压缩方式
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer
let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags
let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树
autocmd FileType java set tags+=D:\tools\java\tags
"autocmd FileType h,cpp,cc,c set tags+=D:\tools\cpp\tags
"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags
set tags=tags
"set autochdir
"--------------------------------------------------------------------------------



"----------------------------------winmanager配置--------------------------------
let loaded_winmanager = 1 "1 You can avoid loading this plugin.
let g:persistentBehaviour = 0
let g:winManagerWidth = 30 "the width of the explorer areas,default 25.
let g:NERDTree_title='NERD Tree'
let g:winManagerWindowLayout='NERDTraee|TagList'
map <c-w><c-t> :WMToggle<cr> 
map <c-w><c-f> :FirstExplorerWindow<cr>
map <c-w><c-b> :BottomExplorerWindow<cr>
function! NERDTree_Start()
	exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
	return 1
endfunction
"---------------------------------------------------------------------------------



"--------------Taglis settins-----------------------------------
let Tlist_Auto_Open=1 "默认打开taglist,使用wnindowmanager时不自动打开
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_File_Fold_Auto_Close = 1 "t只显示当前文件tag，其它文件的tag都被折叠起来
let Tlist_Show_One_File = 0 "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 0 "在右侧窗口中显示taglist窗口
let Tlist_Use_SingleClick=1 "单击跳转到指定标签位置
let Tlist_WinWidth = 25
"let Tlist_WinHeight = 0
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
"------------------------------------------------------------------------------

"------------------------------------NERDTree settings--------------------------------
map <F3> : NERDTreeToggle<CR>
autocmd VimEnter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" 是否显示隐藏文件
let NERDTreeShowHidden=1
let NERDTreeWinSize=30
"忽略以下文件
let NERDTreeIgnore=['\.pyc','\~$','\.swp','\moc_','\ui_','\.o$']
" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
"---------------------------------------------------------------------------------



"----------------------nerdcommenter settings--------------------------------------
let mapleader="c"
set timeout timeoutlen=1500
",ca在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//  
",cc注释当前行
",c<space> 切换注释/非注释状态
",cs 以”性感”的方式注释
",cA 在当前行尾添加注释符，并进入Insert模式
",cu 取消注释
",c$ 从光标开始到行尾注释  ，这个要说说因为c$也是从光标到行尾的快捷键，这个按过逗号（，）要快一点按c$
"2,cc 光标以下count行添加注释 
"2,cu 光标以下count行取消注释
"2,cm:光标以下count行添加块注释(2,cm)
"Normal模式下，几乎所有命令前面都可以指定行数
"Visual模式下执行命令，会对选中的特定区块进行注释/反注释
"---------------------------------------------------------------------------------


"----------------------ctrlp settings---------------------------------------------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"Use a custom file listing command
"let g:ctrlp_user_command = 'find %s -type f'

"Ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
"------------------------------------------------------------------------------------

"---------------------ale.vim settings---------------------------------------
"keep the sign gutter open
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'X'
let g:ale_sign_warning = '!'
"使用clang对c和c++进行语法检查，对python使用pylint进行语法检查
let g:ale_linters = {
\   'c++': ['clang'],
\   'c': ['clang'],
\   'python': ['pylint'],
\}
" echo message
" %s is the error message itself
" %linter% is the linter name
" %severity is the severity type
 let g:ale_echo_msg_error_str = 'E'
 let g:ale_echo_msg_warning_str = 'W'
 let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" use quickfix list instead of the loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
nmap <Leader>s :ALEToggle<CR>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-J> <Plug>(ale_next_wrap)
" run lint only on saving a file
let g:ale_lint_on_text_changed = 'never'
" dont run lint on opening a file
let g:ale_lint_on_enter = 0
"------------------------END ale.vim--------------------------------------


"-------------------------支持鼠标复制粘贴--------------------------------
if has( 'mouse' )
	set mouse=a
endif
"-------------------------------------------------------------------------
