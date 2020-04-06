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

function! s:check_active() abort
  if !has('gui_running')
    return 0
  else
    if has('win32') || has('win64')
      let dll = get(g:, 'vimtweak_dll_path', '')
      if empty(dll)
        let dll = get(split(globpath(&rtp, has('win64') ? 'vimtweak64.dll' : 'vimtweak32.dll'), '\n'), 0, '')
        if empty(dll)
          return 0
        endif
      endif
      let g:transparency_windows_dll = dll
    elseif has('mac')
      if !has('transparency')
        return 0
      endif
    else
      if !executable('transset-df') || !has('float')
        return 0
      endif
    endif
  endif
  return 1
endfunction

function! s:install(flag)
  augroup Transparency
    autocmd!
    if a:flag
      autocmd FocusGained * call transparency#set(g:transparency_config.active)
      autocmd FocusLost   * call transparency#set(g:transparency_config.inactive)
      call transparency#set(g:transparency_config.active)
    else
      call transparency#set(100)
    endif
  augroup END
  let g:transparency_enabled = a:flag
endfunction

" work status
let g:transparency_activate       = s:check_active()
let g:transparency_startup_enable = get(g:, 'transparency_startup_enable', 1)
let g:transparency_ctermbg_none   = get(g:, 'transparency_ctermbg_none', 0)

" use inner
let g:transparency_enabled = 0

" user config
let g:transparency_config = extend(get(g:,'transparency_config',{}),
      \ {
      \  'active'   : 90,
      \  'inactive' : 70
      \ },
      \ 'keep'
      \)

if g:transparency_activate
  noremap <silent> <Plug>(TransparencyOn)     :call <SID>install(v:true)<CR>
  noremap <silent> <Plug>(TransparencyOff)    :call <SID>install(v:false)<CR>
  noremap <silent> <Plug>(TransparencyToggle) :call <SID>install(!g:transparency_enabled)<CR>
  if g:transparency_startup_enable
    call s:install(v:true)
  endif
endif

if !has('gui_running') && g:transparency_ctermbg_none
  augroup Transparency
    autocmd!
    autocmd Colorscheme * highlight Normal      ctermbg=none
    autocmd Colorscheme * highlight NonText     ctermbg=none
    autocmd Colorscheme * highlight LineNr      ctermbg=none
    autocmd Colorscheme * highlight Folded      ctermbg=none
    autocmd Colorscheme * highlight EndOfBuffer ctermbg=none
  augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
