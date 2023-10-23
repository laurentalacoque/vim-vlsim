" test for Vlsi
" Install https://github.com/laurentalacoque/vim-unittest (fixed version of 
" https://github.com/h1mesuke/vim-unittest)
" Run :UnitTest <this file>

let s:here = expand('<sfile>:p:h')
execute 'source' s:here . '/test_yank_sv.vim'
execute 'source' s:here . '/test_yank_v.vim'
execute 'source' s:here . '/test_yank_vhd.vim'
execute 'source' s:here . '/test_paste_v_sv.vim'

