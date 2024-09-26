vim9script
if has('nvim')
  finish
endif

import '../autoload/dashboard.vim' as dashboard

augroup dashboard
  autocmd VimEnter * call OnVimEnter()
  autocmd VimResized * call OnVimResized()
augroup END

def OnVimEnter()
  if !argc() && line('$') == 1 && getline('.') == ''
    call dashboard.DashboardInstance()
  endif
  autocmd! dashboard VimEnter
enddef

def OnVimResized()
  call dashboard.DashboardResize()
enddef


nnoremap <buffer><nowait><silent> <cr> :call OpenBuffers()<cr>
nnoremap <buffer><nowait><silent> i :enew <bar> startinsert<cr>
nnoremap <buffer><nowait><silent> e :enew <bar> startinsert<cr>
nnoremap <buffer><nowait><silent> q :q<cr>





