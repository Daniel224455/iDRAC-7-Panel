@echo off
color 0A
@echo.
:LOGIN
cls
set /p ip="Enter iDRAC IP Address: "
set /p user="Enter iDRAC Username: "
set /p pass="Enter iDRAC Password: "
goto AUTH_IDRAC
@echo.
goto MENU

:AUTH_IDRAC
  cls
  @echo.
  @echo Verifying your iDRAC credentials...
  ipmitool -I lanplus -H %ip% -U %user% -P %pass% chassis power status >nul 2>&1
  if %errorlevel%==0 (
    echo iDRAC handshake success, you are logged in
    timeout /t 2 /nobreak >nul
) else (
    echo Failed to authenticate with iDRAC. Please check your IP, username, or password.
    timeout /t 3 /nobreak >nul
    goto :LOGIN
)

@echo off
:MENU
cls
@echo.
@echo ***************************************************
@echo iDRAC 7 Panel - Current iDRAC user : %user%
@echo ***************************************************
@echo.
@echo List of options
@echo.^<0^> Read iDRAC sensor reports of your Server
@echo.^<1^> Enable manual fan control (non-volatile)
@echo.^<2^> Disable manual fan control
@echo.^<3^> Set custom fan speed
@echo.^<4^> Set fan speed to 5 percent
@echo.^<5^> Set fan speed to 100 percent
@echo.^<6^> iDRAC Power Actions
@echo.^<7^> Dell LCD Settings
@echo.^<8^> Various iDRAC actions
@echo.^<9^> Quick start remote console, requires login
@echo.^<10^> Logout
@echo.^<11^> Exit
@echo.

set /p CHOICE="Please select:"
REM Check for valid input
if "%CHOICE%" equ "0" goto CHECK_INFO
if "%CHOICE%" equ "1" goto ENABLE_CTRL
if "%CHOICE%" equ "2" goto DISABLE_CTRL
if "%CHOICE%" equ "3" goto SFSP_CUSTOM
if "%CHOICE%" equ "4" goto SFSP_5
if "%CHOICE%" equ "5" goto SFSP_100
if "%CHOICE%" equ "6" goto IDRAC_PWR_ACT
if "%CHOICE%" equ "7" goto IDRAC_PWR_LCD
if "%CHOICE%" equ "8" goto IDRAC_VARI_CMDS
if "%CHOICE%" equ "9" goto QCK_SRT_CON
if "%CHOICE%" equ "10" goto LOGOFF_IDRAC
if "%CHOICE%" equ "11" goto PANEL_EXIT

REM If input is not valid, show error message and return to MENU
cls
echo Invalid option, Returning to main menu.
timeout /t 2 /nobreak >nul
goto MENU

:CHECK_INFO
) else ( 
   cls 
   @echo off
   @echo.
   @echo Reading current iDRAC readings...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% sdr elist
   @echo getting chassis status...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% chassis status
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.

:ENABLE_CTRL
) else (
   cls
   @echo off
   @echo.
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x01 0x00
   @echo Manual Fan control enabled.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.

:DISABLE_CTRL
) else ( 
   cls
   @echo.
   @echo Disabling manual fan control..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x01 0x01
   @echo Successfully disabled manual fan control. From now on iDRAC will control the fans
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.

:SFSP_CUSTOM
) else (
   cls
   @echo.
   set /p percent="Enter Percentage (0-100) in hexadecimal (0x00-0x64) : "
   @echo Setting your custom fan speed....
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff %percent%
   @echo Successfully set custom fan speed.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.

:SFSP_5
) else (
   cls
   @echo.
   @echo Setting fan speed to 5 percent....
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x05
   @echo Successfully set fan speed to 5 percent.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.

:SFSP_100
) else ( 
   cls
   @echo.
   @echo Setting fan speed to max speed....
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x64
   @echo Successfully set fan speed to maximum.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.  

:LOGOFF_IDRAC
) else (
   cls
   @echo.
   @echo Logging out...
   timeout /t 1 /nobreak >nul
   goto LOGIN 

:QCK_SRT_CON
) else (
   cls
   @echo.
   @echo WARNING : THIS WILL START YOUR DEFAULT WEB BROWSER IF YOU CONTINUE
   @echo YOU ALSO MUST HAVE JAVA INSTALLED, AFTER YOU LOG INTO THE SITE RUN VIEWER.JNLP
   @echo PRESS ANY KEY TO START THE SITE
   pause >nul
   start https://%ip%/login.html?console
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto MENU
   @echo.
        

:IDRAC_VARI_CMDS   
) else (
   cls 
   @echo. 
   @echo Loading iDRAC Various Actions...
   timeout /t 2 /nobreak >nul
   @echo Entering iDRAC Various Actions menu..
   timeout /t 1 /nobreak >nul
   goto IDRAC_VARIOUS

:IDRAC_VARIOUS
) else (
   cls
   @echo.
   @echo Choose which iDRAC action to launch.   
   @echo.^<0^> Get User list
   @echo.^<1^> Start ID Button to blink temporarily
   @echo.^<2^> Get iDRAC SEL Protocol Logs
   @echo.^<3^> Print FRU Information
   @echo.^<4^> Stress Test your Server
   @echo.^<5^> Return to main menu
   @echo.
   set /p CHOICE="Please select:"
   REM Check for valid input
   cls
   if "%CHOICE%" equ "0" goto READ_USRLST
   if "%CHOICE%" equ "1" goto IDRAC_ID_BTN
   if "%CHOICE%" equ "2" goto SEL_ELIST
   if "%CHOICE%" equ "3" goto PRNT_FRU
   if "%CHOICE%" equ "4" goto TROLL_SRV
   if "%CHOICE%" equ "5" goto RET_MAINMENU
   REM If input is not valid, show error message and return to IDRAC_VARIOUS
   cls
   echo Invalid option, Returning to iDRAC Various Actions menu.
   timeout /t 2 /nobreak >nul
   goto IDRAC_VARIOUS

:READ_USRLST
   cls
   @echo.
   @echo Reading user list...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% user list 1
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% user summary 1
   @echo Successfully read user list.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_VARIOUS  

:IDRAC_ID_BTN
) else (
   cls
   @echo.
   @echo Blinking iDRAC ID Button...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% chassis identify 
   @echo ID Button should be blinking now.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_VARIOUS 

:SEL_ELIST
) else (
   cls 
   @echo.
   @echo Getting logs from iDRAC...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% sel elist
   @echo.
   @echo.
   @echo Successfully got list.   
   @echo Press any key to return to main menu.
   pause >nul 
   goto IDRAC_VARIOUS

:PRNT_FRU
) else (
   cls
   @echo.
   @echo Printing FRU Information...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% fru print
   @echo Successfully printed FRU Information
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_VARIOUS 

:TROLL_SRV
) else (
   cls
   @echo.
   @echo Filling protocol logs...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x05
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x64
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x05
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x64
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x50
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x24
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x00
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x44
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% event 1     
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% event 2
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% event 3
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% event 1   
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% raw 0x30 0x30 0x02 0xff 0x05
   @echo PASSED
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_VARIOUS 

:IDRAC_PWR_ACT
) else (
   cls 
   @echo. 
   @echo Loading iDRAC Power Actions...
   timeout /t 2 /nobreak >nul
   @echo Entering iDRAC Power Actions menu..
   timeout /t 1 /nobreak >nul
   goto IDRAC_ACTIONS 

 :PANEL_EXIT
) else (
   cls
   @echo.
   exit
   @echo.


:IDRAC_ACTIONS
) else ( 
   cls
   @echo.
   @echo Choose which iDRAC action to launch.
   @echo.^<0^> Read power status
   @echo.^<1^> Turn the server on
   @echo.^<2^> Turn the server off
   @echo.^<3^> Power cycle
   @echo.^<4^> Reset your server
   @echo.^<5^> Enter iDRAC-Diag
   @echo.^<6^> Soft reset server
   @echo.^<7^> Cold reset iDRAC7
   @echo.^<8^> Return to main menu
   @echo.
   set /p CHOICE="Please select:"
   REM Check for valid input
   cls
   if "%CHOICE%" equ "0" goto READ_PWRSTAT
   if "%CHOICE%" equ "1" goto TURN_SRV_ON
   if "%CHOICE%" equ "2" goto TURN_SRV_OFF
   if "%CHOICE%" equ "3" goto PWR_CYCLE
   if "%CHOICE%" equ "4" goto RST_SERVER
   if "%CHOICE%" equ "5" goto IDRAC_DIAG
   if "%CHOICE%" equ "6" goto SOFT_RST
   if "%CHOICE%" equ "7" goto COLD_IDRAC_RST
   if "%CHOICE%" equ "8" goto RET_MAINMENU
   REM If input is not valid, show error message and return to IDRAC_ACTIONS
   cls
   echo Invalid option, Returning to iDRAC Power Actions menu.
   timeout /t 2 /nobreak >nul
   goto IDRAC_ACTIONS

:READ_PWRSTAT
) else (
   cls
   @echo.
   @echo Reading power status..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power status
   @echo Successfully read power status.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS 

:TURN_SRV_ON
) else ( 
   cls 
   @echo.
   @echo Turning server on...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power on
   @echo Successfully turned the server on.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS     

:TURN_SRV_OFF
) else ( 
   cls 
   @echo.
   @echo Turning server off...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power off
   @echo Successfully turned the server off.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS   

:PWR_CYCLE
) else ( 
   cls 
   @echo.
   @echo Power cycling your server...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power cycle
   @echo Successfully launched a power cycle.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS

:RST_SERVER
) else ( 
   cls 
   @echo.
   @echo Resetting your server...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power reset
   @echo Launched server reset
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS

:IDRAC_DIAG
) else ( 
   cls 
   @echo.
   @echo Putting your server into iDRAC_DIAG mode...
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power diag 
   @echo your server might be in diag mode now... 
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS

:SOFT_RST
) else ( 
   cls 
   @echo.
   @echo Soft resetting your server... 
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% power soft  
   @echo resetted server..
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS

:COLD_IDRAC_RST
) else ( 
   cls 
   @echo.
   @echo Cold resetting iDRAC7... 
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% mc reset cold
   @echo resetted iDRAC7..
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_ACTIONS   

:RET_MAINMENU
) else ( 
  @echo.
  @echo Re-loading options from main menu...
  timeout /t 2 /nobreak >nul   
  @echo successfully loaded options... returning to main menu
  timeout /t 1 /nobreak >nul
  goto MENU 


:IDRAC_PWR_LCD
) else (
   cls 
   @echo. 
   @echo Loading iDRAC LCD Presets...
   timeout /t 2 /nobreak >nul
   @echo Entering iDRAC LCD Presets menu..
   timeout /t 1 /nobreak >nul
   goto IDRAC_DELL_LCD  

:IDRAC_DELL_LCD
) else ( 
   cls
   @echo.
   @echo Choose which iDRAC LCD Presets to apply.
   @echo.^<0^> None
   @echo.^<1^> Model Name
   @echo.^<2^> IPV4 Address
   @echo.^<3^> MAC Address
   @echo.^<4^> System Name
   @echo.^<5^> Service Tag
   @echo.^<6^> IPV6 Address
   @echo.^<7^> Ambient Temperature
   @echo.^<8^> System Wattage
   @echo.^<9^> Asset Tag (May be undefined)
   @echo.^<10^> Custom
   @echo.^<11^> Return to main menu
   @echo.
   set /p CHOICE="Please select:"
   REM Check for valid input
   cls
   if "%CHOICE%" equ "0" goto NO_LCD_TXT
   if "%CHOICE%" equ "1" goto MODEL_NAME_LCD
   if "%CHOICE%" equ "2" goto IPV4_LCD
   if "%CHOICE%" equ "3" goto MAC_LCD
   if "%CHOICE%" equ "4" goto SYS_NAME_LCD
   if "%CHOICE%" equ "5" goto SERV_TAG_LCD
   if "%CHOICE%" equ "6" goto IPV6_LCD
   if "%CHOICE%" equ "7" goto AMBIENT_TEMP_LCD
   if "%CHOICE%" equ "8" goto SYS_WATT_LCD
   if "%CHOICE%" equ "9" goto ASST_TAG_LCD
   if "%CHOICE%" equ "10" goto CUSTOM_TXT_LCD
   if "%CHOICE%" equ "11" goto RET_MAINMENU

   REM If input is not valid, show error message and return to IDRAC_DELL_LCD
   cls
   echo Invalid option, Returning to iDRAC LCD Presets menu.
   timeout /t 2 /nobreak >nul
   goto IDRAC_DELL_LCD 

:NO_LCD_TXT
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to empty..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode none 
   @echo Successfully set LCD Text to empty.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD   

:MODEL_NAME_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to PowerEdge model name..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode modelname 
   @echo Successfully set LCD Text to PowerEdge model name.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD 

:IPV4_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to IPV4 Address..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode ipv4address 
   @echo Successfully set LCD Text to IPV4 Address.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD   

:MAC_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to MAC Address..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode macaddress 
   @echo Successfully set LCD Text to MAC Address.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD 

:SYS_NAME_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to System Name..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode systemname 
   @echo Successfully set LCD Text to System Name.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD  

:SERV_TAG_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to Service Tag..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode servicetag 
   @echo Successfully set LCD Text to Service Tag.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD 

:IPV6_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to IPV6 Address..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode ipv6address 
   @echo Successfully set LCD Text to IPV6 Address.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD    

:AMBIENT_TEMP_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to Ambient Temperature..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode ambienttemp 
   @echo Successfully set LCD Text to Ambient Temperature.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD   

:SYS_WATT_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to System Wattage..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode systemwatt 
   @echo Successfully set LCD Text to System Wattage.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD  

:ASST_TAG_LCD
) else ( 
   cls 
   @echo.
   @echo Setting LCD Text to Asset Tag..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode assettag 
   @echo Successfully set LCD Text to Asset Tag.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD  

:CUSTOM_TXT_LCD
) else ( 
   cls 
   @echo.
   set /p custtext="Enter Custom Text: "
   @echo Setting LCD Text to your custom text..
   ipmitool -I lanplus -H %ip% -U %user% -P %pass% delloem lcd set mode userdefined "%custtext%"
   @echo Successfully set LCD Text to your custom text.
   @echo.
   @echo.
   @echo Press any key to return to main menu.
   pause >nul
   goto IDRAC_DELL_LCD                          
)