@echo off

"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\writable\path\to\log\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://benefledi:VzVR4s4y@ftp.wealthcareadmin.com/ -hostkey=""ecdsa-sha2-nistp256 256 EYKqkrqNlGfoP9bmB1cGKVTh5xGfof4YJb4+W1ozQmg=""" ^
    "Your command 1" ^
    "Your command 2" ^
    "exit"

set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
  echo Success
) else (
  echo Error
)

exit /b %WINSCP_RESULT%