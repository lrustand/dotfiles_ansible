" Start NERDTree if no file argument
function! StartUp()
    if !argc() && !exists("s:std_in")
        silent! NERDTree
    end
    if argc() && isdirectory(argv()[0]) && !exists("s:std_in")
        ene
        exe 'silent! NERDTree' argv()[0]
        cd `=argv()[0]`
    end
endfunction
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call StartUp()

" Replace NERDTree folder arrows with folder open close symbols
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsDefaultFolderOpenSymbol='' " symbol for open folder (f07c)
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol='' " symbol for closed folder (f07b)
let g:NERDTreeDirArrowExpandable = ""
let g:NERDTreeDirArrowCollapsible = ""

" Remove extra padding between git icons and file icons
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''

" Remove help string from top of NERDTree
let NERDTreeMinimalUI=1

" Fix vim tmux navigator in nersdtree
let g:NERDTreeMapJumpPrevSibling=""
let g:NERDTreeMapJumpNextSibling=""

