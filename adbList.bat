@echo off

setlocal enableDelayedExpansion
REM Some Variables To Create Directories with
set VERSION=APPVERSION
set TEST=TESTNAME
REM used to remove 'device' from each line
set "replace=device"
set "replaced="
set "source=devicesArray.txt"
set "target=clean.txt"
REM adb command to grab all connected devices

adb devices > devicesListUnclean.txt

findstr /v "List of devices attached" devicesListUnclean.txt > devicesArray.txt

(
   for /F "tokens=1* delims=:" %%a in ('findstr /N "^" %source%') do (
      set "line=%%b"
      if defined line set "line=!line:%replace%=%replaced%!"
      echo(!line!)
) > %target%
REM with the 'clean' file of just device IDs, set them as elements of an array
set idi=0
for /F "usebackq" %%A in (clean.txt) do (
    SET /A idi=!idi! + 1
    set var!idi!=%%A
)
set var
REM now the true work can begin
::SCRIPT ON TABLET

for /L %%x in (1, 1, %idi%) do (

::Push Sygic
echo __Installing Sygic...
adb -s !var%%x! push Navigation\_Sygic\Sygic_LC_rus\SygicTruck /sdcard
adb -s !var%%x! push Navigation\_Sygic\Maps_NT2021-12\Maps /sdcard/SygicTruck

::atsargines kopijos
adb -s !var%%x! shell mkdir /sdcard/apps
adb -s !var%%x! push apk\QuickSupport_15.17.apk /sdcard/apps
adb -s !var%%x! push apk\TeamViewer_TB-8505F.apk /sdcard/apps
adb -s !var%%x! push apk\QsLenovo.apk /sdcard/apps

::Mokymai
adb -s !var%%x! push apk\infotransTraining\trainings /sdcard/Download

::DISABLE Entertainment Space
adb -s %tablet% shell pm disable-user com.google.android.apps.mediahome.launcher

)

pause