
"---------------------------------------------------------------------------
" ステータスバーに文字コードと改行コードを表示
"---------------------------------------------------------------------------
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"---------------------------------------------------------------------------
" 挿入モード限定動作
" 移動系を設定
"---------------------------------------------------------------------------
" 下に移動"{{{
inoremap <C-n> <Down>
" 上に移動
inoremap <C-p> <Up>
" 左に移動
inoremap <C-b> <Left>
" 右に移動
inoremap <C-f> <Right>
" キル
inoremap <C-k> <C-o>D
" 一字削除
inoremap <C-d> <Del>
" 文の先頭へ
inoremap <C-a> <Home>
" 文の終わりへ
inoremap <C-e> <End>

"---------------------------------------------------------------------------
" 単語移動
"---------------------------------------------------------------------------
inoremap <silent> <C-l><C-l> <S-Right>
inoremap <silent> <C-h><C-h> <S-Left>

"---------------------------------------------------------------------------
" 空白を挿入
"---------------------------------------------------------------------------
inoremap <silent> <C-i><C-i> <Space><LEFT>

"---------------------------------------------------------------------------
" ウィンドウ分割
"---------------------------------------------------------------------------
nnoremap <silent> <C-x>1 :only<CR>
nnoremap <silent> <C-x>2 :sp<CR>
nnoremap <silent> <C-x>3 :vsp<CR>

"---------------------------------------------------------------------------
" 括弧
"---------------------------------------------------------------------------
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
inoremap <> <><LEFT>

"------------------------------------------------------------------------
"カーソルを表示行で移動する。物理行移動は<C-n>,<C-p>
"------------------------------------------------------------------------
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

"------------------------------------------------------------------------
" 関数定義へジャンプ
"------------------------------------------------------------------------
nnoremap <C-[> <C-t>

"------------------------------------------------------------------------
" ハイライトを消す
"------------------------------------------------------------------------
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"------------------------------------------------------------------------
" インクリメンタルサーチ
"------------------------------------------------------------------------
set incsearch

"------------------------------------------------------------------------
" 折りたたみ機能
"------------------------------------------------------------------------
set foldmethod=marker

"------------------------------------------------------------------------
" 編集中のファイルをカレントディレクトリに変更する
"------------------------------------------------------------------------
if exists('+autochdir')
    set autochdir
endif

"------------------------------------------------------------------------
" デフォルトスタイル
"------------------------------------------------------------------------
let g:molokai_original = 1
" :colorscheme molokai
:colorscheme koehler
syntax on

"---------------------------------------------------------------------------
" コーディング関係
" 改行時にコメントしない
"---------------------------------------------------------------------------
set formatoptions-=ro
augroup vimrc_group_formatoptions
    autocmd!
    autocmd FileType * setlocal formatoptions-=ro
augroup END

"------------------------------------------------------------------------
" エラー回避
"------------------------------------------------------------------------
set fenc=utf-8
set enc=utf-8
set fencs=iso-2022-jp,utf-8,euc-jp,cp932

"------------------------------------------------------------------------
" タブで管理(plugin/minibufexpl.vim)
"------------------------------------------------------------------------
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
"let g:miniBufExplModSelTarget = 1 
"}}}

"------------------------------------------------------------------------
" :Gccコマンド
"------------------------------------------------------------------------
command! Gcc call s:Gcc()"{{{

function! s:Gcc()
    w
    let fname=expand("%")
    let command="gcc " . fname . " -o " . fname . ".out 2>&1"
    let res=system(command)
    let y = 121
    let n = 110
    let key = y

    if strlen(res) > 0
        echo res
        echo " "
        echo "continue? [y/n]:"
        let key = getchar()
    endif

    if key == y
        :! `echo % | sed "s/^\([^\/]\)/.\/\1/g"`.out
    endif

endfunction

"
" :TexShopコマンド
"
command! Pdf call s:Pdf()
function! s:Pdf()
    echo "--- TexShop --- "
    "write the file
    :w

    let thePath = getcwd() .'/'. expand("%")
    let execString = 'osascript -e "tell app \"TeXShop\"" -e "set theDoc to open ((POSIX file \"'.thePath.'\") as alias)" -e "tell theDoc to typesetinteractive" -e "end tell"'
    exec 'silent! !'.execString
    return ''
    echo "--- Complete! --- "
endfunction"}}}

"-------------------------------------------------------------------------------------------
" TexShopコマンド
"-------------------------------------------------------------------------------------------"
"set fileencodings=sjis"{{{

" Run LaTeX through TexShop
function! SRJ_runLatex()
     " if &ft != 'tex'
         " echo "calling srj_runLatex from a non-tex file"
         " return ''
     " end

    "write the file
    :w

    let thePath = getcwd() .'/'. expand("%")

    let execString = 'osascript -e "tell app \"TeXShop\"" -e "set theDoc to open ((POSIX file \"'.thePath.'\") as alias)" -e "tell theDoc to typesetinteractive" -e "end tell"'
    exec 'silent! !'.execString
    return ''
endfunction
no  <expr> <D-r> SRJ_runLatex()
vn  <expr> <D-r> SRJ_runLatex()
ino <expr> <D-r> SRJ_runLatex()
"}}}

"-------------------------------------------------------------------------------------------
" タブページの切り替えをWindowsのように
"-------------------------------------------------------------------------------------------
if v:version >= 700
    nnoremap <C-Right> gt
    nnoremap <C-Left> gT
endif

"-------------------------------------------------------------------------------------------
"<TAB>で補完
"-------------------------------------------------------------------------------------------
" {{{ Autocompletion using the TAB key
" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<TAB>"
    else
        if pumvisible()
            return "\<C-N>"
        else
            return "\<C-N>\<C-P>"
        end
    endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" }}} Autocompletion using the TAB key

"-------------------------------------------------------------------------------------------
"neocomplcache
"-------------------------------------------------------------------------------------------
"{{{
"Note: This option must set it in .vimrc(_vimrc). NOT IN .gvimrc(_gvimrc)!
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
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions',
            \ 'coffee' : $HOME.'/vim_dict/javascript.dict'
            \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><silent> <CR> <SID>my_cr_function()
function! s:my_cr_function()
    return pumvisible() ? neocomplcache#close_popup() . "\<CR>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"}}}

"-------------------------------------------------------------------------------------------
" snippets
" Plugin key-mappings.
"-------------------------------------------------------------------------------------------
"{{{
imap <C-q>     <Plug>(neocomplcache_snippets_expand)
smap <C-q>     <Plug>(neocomplcache_snippets_expand)

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
" \ "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
"}}}

"-------------------------------------------------------------------------------------------
" coffeeScript
"-------------------------------------------------------------------------------------------
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!

"-------------------------------------------------------------------------------------------
" vim-indent-guides
"-------------------------------------------------------------------------------------------
set tabstop=4 "{{{
set shiftwidth=4
set softtabstop=4
set expandtab

" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量
let g:indent_guides_start_level=1
" 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" ガイドの幅
let g:indent_guides_guide_size = 1
" 奇数
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black guibg=black ctermbg=1
" 偶数
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey guibg=darkgrey ctermbg=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey guibg=DarkSlateGray ctermbg=2 "}}}

"-------------------------------------------------------------------------------------------
" カレント行
"-------------------------------------------------------------------------------------------
" カレント行ハイライト
set cursorline
" アンダーラインをひく
autocmd VimEnter,ColorScheme * : highlight CursorLine cterm=underline ctermbg=234

"-------------------------------------------------------------------------------------------
" Simple-Javascript-Indenter
"-------------------------------------------------------------------------------------------
" この設定入れるとshiftwidthを1にしてインデントしてくれる
let g:SimpleJsIndenter_BriefMode = 1
" この設定入れるとswitchのインデントがいくらかマシに
let g:SimpleJsIndenter_CaseIndentLevel = -1


"-------------------------------------------------------------------------------------------
" TagBar
"-------------------------------------------------------------------------------------------
nnoremap <F9> :TagbarToggle<CR>

" ctagsはMacVim-kaoriyaの使ってる
let g:tagbar_ctags_bin = '/Applications/MacVim.app/Contents/MacOS/ctags'


"-------------------------------------------------------------------------------------------
" TweetVim
"-------------------------------------------------------------------------------------------
" タイムライン選択用の Unite を起動する
nnoremap <silent> t :Unite tweetvim<CR>
" 発言用バッファを表示する
nnoremap <silent> s :TweetVimSay<CR>

"-------------------------------------------------------------------------------------------
" Unite
"-------------------------------------------------------------------------------------------
nnoremap <silent> ub :Unite buffer<CR>
nnoremap <silent> uf :Unite file<CR>
nnoremap <silent> uo :Unite outline<CR>

"-------------------------------------------------------------------------------------------
"vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" vim-scripts リポジトリ (1)
Bundle 'neocomplcache'
Bundle 'neocomplcache-snippets_complete'
Bundle 'sudo.vim'
Bundle 'unite.vim'
Bundle 'unite-font'
Bundle 'unite-colorscheme'
Bundle 'tComment'
Bundle 'surround.vim'
Bundle 'vim-coffee-script'
Bundle 'TagBar'

" github の任意のリポジトリ (2)
Bundle 'thinca/vim-quickrun'
Bundle 'gmarik/vundle'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'szw/vim-tags'
Bundle 'basyura/TweetVim'
Bundle 'basyura/twibill.vim'
Bundle 'mattn/webapi-vim'
Bundle 'Shougo/unite.vim'
Bundle 'h1mesuke/unite-outline'
Bundle 'tyru/open-browser.vim'
Bundle 'basyura/bitly.vim'
Bundle 'thinca/vim-ref'
Bundle 'mattn/emmet-vim'
Bundle 'soh335/vim-symfony'

" github 以外のリポジトリ (3)
"Bundle "git://git.wincent.com/command-t.git"

filetype plugin indent on
"-------------------------------------------------------------------------------------------
