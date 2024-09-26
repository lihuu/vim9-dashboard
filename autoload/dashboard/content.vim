vim9script

const vim_header = [
 '██╗   ██╗██╗███╗   ███╗ █████╗ ',
 '██║   ██║██║████╗ ████║██╔══██╗',
 '██║   ██║██║██╔████╔██║╚██████║',
 '╚██╗ ██╔╝██║██║╚██╔╝██║ ╚═══██║',
 ' ╚████╔╝ ██║██║ ╚═╝ ██║ █████╔╝',
 '  ╚═══╝  ╚═╝╚═╝     ╚═╝ ╚════╝ ',
 '',
 '' ]

def PaintHeader()
  var header = exists("g:vim_dashboard_custom_header") ? g:vim_dashboard_custom_header : vim_header
  var maxLineLength = dashboard#utils#maxLineLength(header)
  const padding = CalcPadding(maxLineLength)
  call dashboard#utils#centerLines(['', ''], padding)
  call dashboard#utils#centerLines(header, padding)
  call dashboard#utils#centerLines(['', ''], padding)
enddef

var dashboard = {'entries': {} }

def CenterLines(lines: list<string>, padding: number, initEntries: any)
  for line in lines
    var centered_line = repeat(' ', padding) .. DashBoardEntryFormat(line)
    call append('$', centered_line)
    if initEntries == 1
      dashboard.entries[line('$')] = line
    endif
  endfor
enddef

def CalcPadding(length: number): number
  const width = winwidth(0)
  return max([0, (width - length) / 2])
enddef


export def PaintDashBoard(initEntries: number)
  # 在这里绘制需要展示的图形
  if !&modifiable
    setlocal modifiable
  endif
  if !dashboard#utils#buf_is_empty(0)
    silent! :%d _
  endif
  PaintHeader()
  PaintRecentFiles(initEntries)
  silent! setlocal nomodified nomodifiable
enddef

def g:OpenBuffers() 
  var filePath = substitute(get(dashboard.entries, line('.'), ''), "\\", "/", "g")
  if filePath != ''
    execute 'edit ' .. filePath
  endif
enddef

def GetRecentFiles(): list<string>
  var recent_files = v:oldfiles

  var file_list = []
  var maxSize = 10
  for item in recent_files
    if item != '' && len(file_list) < maxSize 
      call add(file_list, item)
    endif
  endfor
  return file_list
enddef

def PaintRecentFiles(initEntries: number)
  var lines = GetRecentFiles()
  var maxLength = dashboard#utils#maxLineLength(lines)
  var padding = max([0, (winwidth(0) - maxLength) / 2])
  call append("$", repeat(" ", padding - 4) .. "Recent files:")
  call CenterLines(lines, padding, initEntries)
enddef


def DashBoardEntryFormat(entry_path: string): string
  # 这里依赖vim-devicons插件，需要在加载这个插件之后才能使用
  # 这里会加载文件对应的图标
  if exists('*WebDevIconsGetFileTypeSymbol')
    return g:WebDevIconsGetFileTypeSymbol(entry_path) .. ' ' .. entry_path
  else
    return entry_path
  endif
enddef


