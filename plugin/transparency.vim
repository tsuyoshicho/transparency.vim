"=============================================================================
" File: transparency.vim
" Author: Tsuyoshi CHO
" Created: 2019-04-06
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_transparency')
    finish
endif
let g:loaded_transparency = 1

let s:save_cpo = &cpo
set cpo&vim

if !has('gui_running')
  finish
else
  if has('win32') || has('win64')
    let s:dll = get(g:, 'vimtweak_dll_path', '')
    if empty(s:dll)
      let s:dll = get(split(globpath(&rtp, has('win64') ? 'vimtweak64.dll' : 'vimtweak32.dll'), '\n'), 0, '')
      if empty(s:dll)
        finish
      endif
    endif
  endif
endif

function! s:Transparency(v)
  call libcallnr(s:dll, 'SetAlpha', 255-a:v)
endfunction

function! s:Install(flag)
  augroup TransparencyWindows
    autocmd!
    if a:flag =~# '^\(1\|[tT]rue\|[yY]es\)$'
      autocmd FocusGained * call s:Transparency(20)
      autocmd FocusLost * call s:Transparency(50)
    endif
  augroup END
endfunction

command! -nargs=1 Transparency call <SID>Install(<f-args>)

Transparency Yes

let &cpo = s:save_cpo
unlet s:save_cpo
