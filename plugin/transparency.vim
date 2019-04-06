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
  " echomsg "non gui"
  finish
else
  if has('win32') || has('win64')
    let dll = get(g:, 'vimtweak_dll_path', '')
    if empty(dll)
      let dll = get(split(globpath(&rtp, has('win64') ? 'vimtweak64.dll' : 'vimtweak32.dll'), '\n'), 0, '')
      if empty(dll)
        " echomsg "no dll"
        finish
      endif
    endif
    let g:transparency_windows_dll = dll
  elseif has('mac')
    if !has('transparency')
      " echomsg "no opt"
      finish
    endif
  else
    if !executable('transset-df') || !has('float')
      " echomsg "no cmd"
      finish
    endif
  endif
endif
let g:transparency_activate = 1

let g:transparency_config = add(get(g:,'transparency_config',{}),
      \ {
      \  'active'   : 50,
      \  'inactive' : 20
      \ }
      \)

let g:transparency_enabled = 0
function! s:Install(flag)
  augroup Transparency
    autocmd!
    if a:flag =~# '^\(1\|[tT]rue\|[yY]es\)$'
      let g:transparency_enabled = 1
      autocmd FocusGained * call transparency#set(g:transparency_config.inactive)
      autocmd FocusLost   * call transparency#set(g:transparency_config.active)
    else
      let g:transparency_enabled = 0
      call transparency#set(100)
    endif
  augroup END
endfunction

map <Plug>TransparencyOn     :call <SID>Install('True')
map <Plug>TransparencyOff    :call <SID>Install('False')
map <Plug>TransparencyToggle :call <SID>Install(g:transparency_enabled ? 'False' : 'True')

if get(g:,'transparency_startup_enable',1)
  call s:Install('True')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
