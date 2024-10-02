syntax match RecentFilesTitle /\VRecent files/
syntax match UserHomeDirectory /\V~/
syntax match DirectoryDelimiter /\V\/\|\\/
syntax match DirectoryName /\v(\w|-)+(\\)@=/
syntax match DashboardOperationEdit  / Edit\[i\]/
syntax match DashboardOperationFile  / Files\[f\]/
syntax match DashboardOperationConfig  / Config\[c\]/
syntax match DashboardOperationHistory  / History\[h\]/
syntax match DashboardOperationQuit  / Quit\[q\]/
syntax match DashboardRecentFileIndex /\[\d\]/


highlight default link RecentFilesTitle Title
highlight default link UserHomeDirectory Directory
highlight default link DirectoryDelimiter Directory
highlight default link DirectoryName Statement

highlight DashboardOperationEdit guifg=#FA8D07 ctermfg=#FA8D07
highlight DashboardOperationFile guifg=#07FAB1 ctermfg=#07FAB1
highlight DashboardRecentFileIndex guifg=#07FAB1 ctermfg=#07FAB1
highlight DashboardOperationConfig guifg=#0897FD ctermfg=#0897FD
highlight DashboardOperationHistory guifg=#FAE207 ctermfg=#FAE207
highlight DashboardOperationQuit guifg=#9E64FA ctermfg=#9E64FA
highlight DashboardOperationLogo guifg=Yellow ctermfg=Yellow



