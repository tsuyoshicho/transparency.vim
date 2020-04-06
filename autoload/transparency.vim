"=============================================================================
" File: transparency.vim
" Author: Tsuyoshi CHO
" Created: 2019-04-06
"=============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

if g:transparency_activate
  if has('win32') || has('win64')
    " v 0 to 100 % transparent value 0 is all-transparent 100 is non-transparent
    function! transparency#set(v) abort
      " byte 0 to 255 step(integer) 255 is non-transparent
      let v = (a:v * 255) / 100
      call libcallnr(g:transparency_windows_dll, 'SetAlpha', v)
    endfunction
  elseif has('mac')
    " v 0 to 100 % transparent value 0 is all-transparent 100 is non-transparent
    function! transparency#set(v) abort
      " % 0 to 100 transparent step(percent integer) 0 is non-transparent
      let v = 100 - a:v
      let &transparency=v
    endfunction
  else
    " v 0 to 100 % transparent value 0 is all-transparent 100 is non-transparent
    function! transparency#set(v) abort
      " % 0 to 1 transparent step(float) 1 is non-transparent
      let v = floor(a:v) * 0.01
      let cmd = ['transset-df', '--id', string(v:windowid), string(v)]
      call system(join(cmd))
    endfunction
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
