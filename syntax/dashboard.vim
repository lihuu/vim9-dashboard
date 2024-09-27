syntax match RecentFilesTitle /\VRecent files/
syntax match UserHomeDirectory /\V~/
syntax match DirectoryDelimiter /\V\/\|\\/
syntax match DirectoryName /\v(\w|-)+(\\)@=/


highlight default link RecentFilesTitle Title
highlight default link UserHomeDirectory Directory
highlight default link DirectoryDelimiter Directory
highlight default link DirectoryName Statement

highlight DashboardOperationEdit guifg=#FA8D07 ctermfg=#FA8D07
highlight DashboardOperationFile guifg=#07FAB1 ctermfg=#07FAB1
highlight DashboardOperationConfig guifg=#0897FD ctermfg=#0897FD
highlight DashboardOperationHistory guifg=Yellow ctermfg=Yellow
highlight DashboardOperationQuit guifg=Yellow ctermfg=Yellow
highlight DashboardOperationLogo guifg=Yellow ctermfg=Yellow



