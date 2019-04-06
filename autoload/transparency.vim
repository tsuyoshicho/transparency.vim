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

if g:transparency_activate
  if has('win32') || has('win64')
    " v 0 to 100 % transparent value 0 is all-transparent 100 is non-transparent
    function! transparency#set(v)
      " byte 255 to 0(alpha value) -> converted 0 to 255 transparent step(integer)
      let v = (a:v * 255) / 100
      call libcallnr(g:transparency_windows_dll, 'SetAlpha', 255-v)
    endfunction
  elseif has('mac')
    function! transparency#set(v)
      " % 100 to 0(alpha percent) -> converted 0 to 100 transparent step(percent integer)
      let v = 100 - a:v
      let &transparency=v
    endfunction
  else
    function! transparency#set(v)
      " % 0 to 1 transparent step(float)
      let v = floor(a:v) * 0.01
      let cmd = ['transset-df', '--id', string(v:windowid), string(v)]
      call system(join(cmd))
    endfunction
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
