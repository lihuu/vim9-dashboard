vim9script

import './dashboard/content.vim' as Content

export def DashboardInstance()
    var mode = mode()
    if  mode == 'i' && !&modifiable
        return
    endif

    if !&hidden && &modified
        write
        return
    endif

    var buf: number
    if Content.BufIsEmpty(0)
        buf = bufnr('%')
    else
        buf = bufnr('%', 1)
    endif

    const win_id = win_getid()
    call win_execute(win_id, 'buffer ' .. buf)

    silent! setlocal
                \ bufhidden=wipe
                \ colorcolumn=
                \ foldcolumn=0
                \ matchpairs=
                \ modifiable
                \ nobuflisted
                \ nocursorcolumn
                \ nocursorline
                \ nolist
                \ nonumber
                \ noreadonly
                \ norelativenumber
                \ nospell
                \ noswapfile
                \ signcolumn=no
                \ filetype=dashboard
                \ statusline=dashboard

    call Content.PaintDashBoard(1)
  enddef

export def DashboardResize()
    if &filetype == 'dashboard'
      call Content.PaintDashBoard(0)
    endif
enddef

