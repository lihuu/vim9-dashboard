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

const tips = ' Edit[i]   Files[f]   Config[c]   History[h]   Quit[q]'

def PaintHeader()
    var header = exists("g:vim_dashboard_custom_header") ? g:vim_dashboard_custom_header : vim_header
    const padding = CalcPadding(MaxLineLength(header))
    PaddingLines(['', ''], padding)
    PaddingLines(header, padding)
    PaddingLines([tips], CalcPadding(strchars(tips)))
    PaddingLines(['', ''], padding)
enddef

var dashboard = {'entries': {}, 'offset': 0, minRow: 0, maxRow: 0, minColumn: 0, maxColumn: 0}

def PaddingLines(lines: list<string>, padding: number )
    for line in lines
        PrintPaddingLine(line, padding)
    endfor
enddef

def PrintPaddingLine(line: string, padding: number)
    var centered_line = repeat(' ', padding) .. line
    append('$', centered_line)
enddef


def CalcPadding(length: number): number
    const width = winwidth(0)
    return max([0, (width - length) / 2])
enddef


export def PaintDashBoard(initEntries: number)
    if !&modifiable
        setlocal modifiable
    endif
    if !BufIsEmpty(0)
        silent! :%d _
    endif
    PaintHeader()
    PrintRecentFiles(initEntries)
    silent! setlocal nomodified nomodifiable
enddef

def g:OpenBuffers(index: number = -1) 
    var fileIndex = 0
    if index < 0
        fileIndex = line('.')
    else
        fileIndex = index + dashboard.offset + 1
    endif
        var filePath = substitute(get(dashboard.entries, fileIndex, ''), "\\", "/", "g")
        if filePath != ''
            execute 'edit ' .. filePath
        endif
enddef

def g:LimitCursor()
    var maxRow = dashboard.maxRow
    var minRow = dashboard.minRow
    var minColumn = dashboard.minColumn
    var maxColumn = dashboard.maxColumn
    echom "LimitCursor"
    var cursor = getcurpos()
    var row = cursor[1]
    var column = cursor[2]
    if row < minRow
        call cursor(minRow, column)
    elseif row > maxRow
        call cursor(maxRow, column)
    elseif column < minColumn
        call cursor(row, minColumn)
    elseif column > maxColumn
        call cursor(row, maxColumn)
    endif
enddef


def GetRecentFiles(): list<string>
    var recent_files = v:oldfiles
    var file_list = []
    var maxSize = exists("g:dashboard_recent_files_max_size") ? g:dashboard_recent_files_max_size : 10
    var index = 0
    for item in recent_files
        if item != '' && len(file_list) < maxSize 
            add(file_list, item)
            index += 1
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

def PrintRecentFiles(initEntries: number)
    var lines = GetRecentFiles()
    var maxLength = MaxLineLength(lines)
    var padding = max([0, (winwidth(0) - strchars(tips)) / 2])
    append("$", repeat(" ", padding) .. "MRU:")
    var index = 0
    dashboard.offset = line('$')
    for line in lines
        var centered_line = repeat(' ', padding) .. "[" .. index .. "] " .. DashBoardEntryFormat(line)
        append('$', centered_line)
        if initEntries == 1
            dashboard.entries[line('$')] = line
            execute 'nnoremap <buffer><silent><nowait> ' index ':call OpenBuffers(' .. index .. ')<cr>'
        endif
        index += 1
    endfor
    echomsg 'Dashboard loaded ' .. &filetype
    dashboard.minRow = line('$') - len(lines)
    dashboard.maxRow = line('$')
    dashboard.minColumn = padding + 2
    dashboard.maxColumn = padding + 2

    autocmd dashboard CursorMoved <buffer> :call g:LimitCursor()
enddef

def DashBoardEntryFormat(entry_path: string): string
    # In a compiled |:def| function the evaluation is done at runtime.  
    # Use `exists_compiled()` to evaluate the expression at compile time.
    if exists_compiled('g:WebDevIconsGetFileTypeSymbol')
        # check if the vim-devicons plugin is loaded. This function is provided by the plugin and is
        # used to get the icon for a file type.
        return g:WebDevIconsGetFileTypeSymbol(entry_path) .. entry_path
    else
        return entry_path
    endif
enddef
defcompile DashBoardEntryFormat

export def BufIsEmpty(bufNo: number): bool
    return line('$') == 1 && getline(1) == ''
enddef

defcompile MaxLineLength

