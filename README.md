# transparency.vim
Gvim transparency

## Aggregation
- Win : [mattn/transparency\-windows\-vim: windows port of http://vim\-users\.jp/2011/10/hack234/](https://github.com/mattn/transparency-windows-vim) (like PublicDomain)
- Mac : [vim\-jp » Hack \#234: Vim外にいるときはVimを透けさせる](https://vim-jp.org/vim-users-jp/2011/10/05/Hack-234.html)
- Other : [Linux の gVim の透過度を設定する](https://gist.github.com/anekos/6241052)

## Requirement
- Windows
  - [mattn/vimtweak: VimTweak : The tweaking dll for GVim\.exe\.](https://github.com/mattn/vimtweak)
- Mac
  - MacVim / support `transparency` option.
- Linux and other (X11 Window System)
  - `transset-df` command

## Setting

Value as percent transparency (0 is full/100 is non-trans).
Members are active / inactive value.

```vim
let g:transparency_config = {
      \  'active'   : 90,
      \  'inactive' : 70
      \ }
```

Startup autocmd setting `g:transparency_startup_enable` (default 1)

## Keymap

```vim
" ex
nmap <F3> <Plug>(TransparencyOn)
nmap <F4> <Plug>(TransparencyOff)
nmap <F5> <Plug>(TransparencyToggle)
```

## License
MIT
