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
    const padding = CalcPadding(MaxLineLength(header))
    call CenterLines(['', ''], padding)
    call CenterLines(header, padding)
    const tips = ' Edit[i]   Files[f]   Config[c]   History[h]   Quit[q]'
    cal CenterLines([tips], CalcPadding(strchars(tips)))
    call CenterLines(['', ''], padding)
enddef


var dashboard = {'entries': {} }

def CenterLines(lines: list<string>, padding: number, initEntries: number = 1)
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
    if !BufIsEmpty(0)
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

def MaxLineLength(lines: list<string>): number
    var max_length = 0
    for line in lines
        var line_length = strchars(line)
        if line_length > max_length
            max_length = line_length
        endif
    endfor
    if max_length == 0
        max_length = 100
    endif
    return max_length
enddef


def PaintRecentFiles(initEntries: number)
    var lines = GetRecentFiles()
    var maxLength = MaxLineLength(lines)
    var padding = max([0, (winwidth(0) - maxLength) / 2])
    call append("$", repeat(" ", padding - 4) .. "Recent files:")
    call CenterLines(lines, padding, initEntries)
enddef


def DashBoardEntryFormat(entry_path: string): string
    # 这里依赖vim-devicons插件，需要在加载这个插件之后才能使用
    # 这里会加载文件对应的图标
    if exists('*WebDevIconsGetFileTypeSymbol')
        echomsg "WebDevIconsGetFileTypeSymbol"
        echomsg "WebDevIcons" .. entry_path
        return g:WebDevIconsGetFileTypeSymbol(entry_path) .. ' ' .. entry_path
    else
        echomsg "No WebDevIconsGetFileTypeSymbol"
        return entry_path
    endif
enddef

export def BufIsEmpty(bufNo: number): bool
  return line('$') == 1 && getline(1) == ''
enddef

defcompile MaxLineLength

