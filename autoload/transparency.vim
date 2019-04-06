"=============================================================================
" File: transparency.vim
" Author: Tsuyoshi CHO
" Created: 2019-04-06
"=============================================================================

scriptencoding utf-8

if !exists('g:loaded_transparency')
    finish
endif
let g:loaded_transparency = 1

let s:save_cpo = &cpo
set cpo&vim



let &cpo = s:save_cpo
unlet s:save_cpo
