" Plugins: {{{

call plug#begin()

" Programming
Plug 'neoclide/coc.nvim' , {'branch': 'release'}
Plug 'honza/vim-snippets'

" Quality of life
Plug 'ntpeters/vim-better-whitespace'
Plug 'toniz4/vim-stt'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'

" Syntax
Plug 'ap/vim-css-color'
Plug 'baskerville/vim-sxhkdrc'
Plug 'gentoo/gentoo-syntax'
Plug 'vim-python/python-syntax'

" Theming
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

call plug#end()
" }}}
" Theming: {{{

" If on tty, don't use a colorscheme
if $TERM != "linux"
	syntax enable
	set t_Co=16
	set background=light
	colorscheme solarized
endif

" Highlight column when reaching 90 columns
highlight OverLength ctermbg=gray ctermfg=white
match OverLength /\%91v.\%92v./

let g:lightline = {
  \ 'colorscheme': 'solarized',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'readonly': 'LightlineReadonly',
	\   'cocstatus': 'coc#status'
  \ },
  \ 'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [ [ '' ] ]
	\ },
  \ 'component': {
  \ 'lineinfo': '%3l::%-2v',
  \},
\ }

function! LightlineReadonly()
	return &readonly ? '' : ''
endfunction

" }}}
" General Configs: {{{
" Turn on line number + relativenumbers and signcolumn in the number column
set number
set relativenumber
"set signcolumn=number
set synmaxcol=200
let g:stt_auto_insert = 1
let g:stt_auto_quit = 1
set timeoutlen=500

" Misc
set mouse=a
set hidden
set noerrorbells
set enc=utf-8

" Sets up tabs
set tabstop=4
set shiftwidth=4
set cindent

" Sets up better search
set incsearch
set ignorecase
set smartcase

" Selects clipboard
set clipboard=unnamedplus

" Don't show mode (lightline already does it), and let 2 lines for status
set noshowmode
set laststatus=2

" Preview for substitute commands
set inccommand=split

" Diasable backups
set nobackup
set nowritebackup

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Netrw configuration
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_usetab = 0

" }}}
" AutoCommands: {{{

augroup GENERAL
	autocmd!
	" Esc quit netrw to the previous file
	autocmd Filetype netrw nnoremap <buffer> <esc> <C-^>
	" Sets up note and mail files
	autocmd FileType nroff,mail set spell spelllang=pt_br | set tw=80
	autocmd FileType markdown set spell spelllang=en | set tw=80
	autocmd BufWritePost *.ms :silent exec "!make"
augroup end

" }}}
" Key Biddings: {{{
"
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" Maps leader to space
let mapleader = " "

" Fix Y biding
nmap Y y$

" Navigate whithin tabs with alt+i
nmap <A-1> 1gt
nmap <A-2> 2gt
nmap <A-3> 3gt
nmap <A-4> 4gt
nmap <A-5> 5gt
nmap <A-6> 6gt
nmap <A-7> 7gt
nmap <A-8> 8gt
nmap <A-9> :$tabnext<CR>

" Disable Arrow keys in Normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Move within splits with alt+h, j, k, l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Disable search mode highlight
nmap <silent><leader>l :noh<CR>

" Terminal key biddings
nmap <silent><F2> :ToggleTerm<CR>
nmap <silent> <leader>t :ToggleTerm<CR>
tmap <silent><F2> <C-\><C-n>:ToggleTerm<CR>
tmap <silent><C-k> <C-\><C-n><C-k>
tmap <silent><C-j> <C-\><C-n><C-j>

" Strip whitespace
nmap <silent><leader>w :StripWhitespace <CR>

" }}}
" Coc: {{{

" Extensions:

let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-marketplace',
  \ 'coc-pairs',
  \ 'coc-sh',
  \ 'coc-snippets',
  \ 'coc-terminal',
  \ 'coc-vimlsp',
  \ ]

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Less updatetime to cursor hold events
set updatetime=300

" Use tab to navigate the completition menu and for navigating code snippets.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ coc#expandableOrJumpable() ?
		\ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	\ !pumvisible() ? "\<TAB>" :
	\ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
	inoremap <silent><expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>"
		\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>

" vim: fdm=marker ts=2 sw=2
