
@echo off

REM Daniel James
REM For the University of Colorado, Boulder
REM 2015-10-30 09:26 AM
REM edited as of 3/28/2016, 9:20:19 AM



:---------------------------------------
REM first the time stamp
REM This time stamp script taken from the following URL:
REM http://www.winnetmag.com/windowsscripting/article/articleid/9177/windowsscripting_9177.html

REM Create the date and time elements.


for /f "tokens=1-7 delims=:/-, " %%i in ('echo exit^|cmd /q /k"prompt $d $t"') do (
   for /f "tokens=2-4 delims=/-,() skip=1" %%a in ('echo.^|date') do (
      set dow=%%i
      set %%a=%%j
      set %%b=%%k
      set %%c=%%l
      set hh=%%m
      set min=%%n
      set ss=%%o
   )
)

REM Let's see the result.
echo.
echo Today is %dow% %yy%-%mm%-%dd% @ %hh%:%min%:%ss%

echo.

set timeStamp=%yy%-%mm%-%dd%

:----------------------------------------
echo.
echo Thus begins the backup
echo Are you ready for this journey? [y] or [n]
set /p web=Type option:
if "%web%"=="y" goto home
if "%web%"=="ye" goto home
if "%web%"=="yes" goto home
if "%web%"=="n" exit
if "%web%"=="no" exit
if "%web%"=="x" exit
pause


:home

SET /P identiKey=First step, what is the user account of the user you are backing up?: %=%

echo You said %identiKey%
echo Is this what you meant? [y] [n] or [x] for Exit
set /p web=Type option:
if "%web%"=="y" goto step1
if "%web%"=="n" goto home
if "%web%"=="x" exit
pause


:step1

set host=%COMPUTERNAME%
echo The computer is named %host%.

echo I will now open up that user's profile folder.
pause
explorer %SystemDrive%\users\%identiKey%

echo Make sure you have permission to view and browse the folder.
echo It's the only way this script will back up properly.
echo If you are currently logged in as that user, open documents may have errors when copying over.

echo.
echo.
SET /P backUP=What is the drive letter (and colon) - OR - full network address of where you are backing up?: %=%

echo You said %backUP%
echo Is this what you meant? [y] [n] or [x] for Exit
set /p web=Type option:
if "%web%"=="y" goto step2
if "%web%"=="n" goto step1
if "%web%"=="x" exit
pause



:step2


echo.
echo.
echo We are Robocopying to %backUP%\%timeStamp%_%identiKey%\%host%
echo.

set /p web=Proceed? y [proceed] n [start over] x [exit]:
if "%web%"=="y" goto step3
if "%web%"=="n" goto step2
if "%web%"=="x" exit


:step3

:: make sure the destination directories exist
:: http://stackoverflow.com/questions/4165387/create-folder-with-batch-but-only-if-it-doesnt-already-exist

:: and, don't forget the logs


if not exist "%backUP%\%timeStamp%_%identiKey%" mkdir "%backUP%\%timeStamp%_%identiKey%"

if not exist "%backUP%\%timeStamp%_%identiKey%\%host%" mkdir "%backUP%\%timeStamp%_%identiKey%\%host%"

REM echo The name will begin with a time-stamp of today's date: %timeStamp%
set backUP=%backUP%\%timeStamp%_%identiKey%\%host%

if not exist "%backUP%\BackupLogs" mkdir "%backUP%\BackupLogs"

echo At any time, if you want to stop this backup process, hit Ctrl-C.
echo Backing up your main profile
Robocopy.exe "%SystemDrive%\users\%identiKey%" "%backUP%" /XJ /XO /XA:SH /S /Z /R:1 /W:1 /MT:32 /V /XD "%SystemDrive%\Users\%identiKey%\Google Drive" /XD "%SystemDrive%\Users\%identiKey%\OneDrive" /XD "%SystemDrive%\Users\%identiKey%\OneDrive" /XD "%SystemDrive%\Users\%identiKey%\Dropbox" /XD "%SystemDrive%\Users\%identiKey%\SpiderOak" /XD "%SystemDrive%\Users\%identiKey%\Box" /LOG+:"%backUP%\BackupLogs\%timeStamp%_BackupLog.txt"

echo At any time, if you want to stop this backup process, hit Ctrl-C.
echo Backing up your main profile (one last time around to refresh the log file and catch any other changes)
Robocopy.exe "%SystemDrive%\users\%identiKey%" "%backUP%" /XJ /XO /XA:SH /XD "%SystemDrive%\users\%identiKey%\AppData" /XD "%SystemDrive%\Users\%identiKey%\Google Drive" /XD "%SystemDrive%\Users\identiKey%\OneDrive" /XD "%SystemDrive%\Users\%identiKey%\Google Drive" /XD "%SystemDrive%\Users\%identiKey%\ODBA" /XD "%SystemDrive%\Users\%identiKey%\OneDrive" /XD "%SystemDrive%\Users\%identiKey%\Dropbox" /S /Z /R:1 /W:1 /MT:32 /V  /LOG+:"%backUP%\BackupLogs\%timeStamp%_BackupLog.txt"


echo Aaaand we're done!

pause
