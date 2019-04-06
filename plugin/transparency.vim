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

let g:transparency_activate = 0
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

    function! s:Transparency(v)
      " byte 255 to 0(alpha value) -> converted 0 to 255 transparent step(integer)
      call libcallnr(s:dll, 'SetAlpha', 255-a:v)
    endfunction

  elseif has('mac')
    if !has('transparency')
      finish
    endif

    function! s:Transparency(v)
      " % 0 to 100 transparent step(percent integer)
      let &transparency=a:v
    endfunction
  else
    if !executable('transset-df')
      finish
    endif

    function! s:Transparency(v)
      " % 0 to 1 transparent step(float)
      call system('transset-df --id ' . v:windowid . ' ' . a:v)
    endfunction
  endif
endif
let g:transparency_activate = 1

function! s:Install(flag)
  augroup Transparency
    autocmd!
    if a:flag =~# '^\(1\|[tT]rue\|[yY]es\)$'
      let g:transparency_enabled = 1
      autocmd FocusGained * call s:Transparency(20)
      autocmd FocusLost * call s:Transparency(50)
    else
      let g:transparency_enabled = 0
      call s:Transparency(100)
    endif
  augroup END
endfunction

map <Plug>TransparencyOn     :call <SID>Install('True')
map <Plug>TransparencyOff    :call <SID>Install('False')
map <Plug>TransparencyToggle :call <SID>Install(g:transparency_enabled ? 'False' : 'True')

let &cpo = s:save_cpo
unlet s:save_cpo
