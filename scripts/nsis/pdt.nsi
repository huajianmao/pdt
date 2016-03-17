SetCompressor lzma
!include "MUI.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"

!include AddToPath.nsh
!include WriteEnvStr.nsh

!define ALL_USERS

!define MUI_HEADERIMAGE
# !define MUI_HEADERIMAGE_BITMAP "pdt.bmp"
!define MUI_ABORTWARNING
!define APP_NAME "Parallel Data Transfer v1.0"

!insertmacro GetTime
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

Name "${APP_NAME}"
Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
DirText "安装程序将安装 $(^Name) 在下列文件夹。$\r$\n$\r$\n要安装在不同文件夹，单击 [浏览] 并选择其他文件夹。"
InstallDir "C:\Program Files\pdt"
OutFile "PDTSetup.exe"
 
!define PDT_HOME "$INSTDIR"

Section "setup"
  SetOutPath $INSTDIR
  File /r bin
  File /r doc 
  File /r openssh

  Call SetEnvironmentVariables
  Var /Global TempExePath
  StrCpy $TempExePath "$INSTDIR"
  System::Call 'kernel32::SetEnvironmentVariable(t "PDT_HOME", t "$TempExePath")i'
  
  Call InstallOpenSSHService

  WriteUninstaller "$INSTDIR\uninstall.exe"
  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\Start.${APP_NAME}.lnk" "$INSTDIR\start.exe"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\Uninstall.${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
  Call un.RemoveOpenSSHService
  Call un.RemoveEnvironmentVariables
  RMDir /r $INSTDIR
  RMDir /r "$SMPROGRAMS\${APP_NAME}"
SectionEnd

Function InstallOpenSSHService
  SetOutPath "$INSTDIR\openssh"
  ExecWait "ssh-keygen.exe -A"
  ExecWait "powershell.exe install-sshlsa.ps1"
  ExecWait "sshd.exe install"
  ExecWait "sc config sshd start=auto"
  ExecWait "net start sshd"
FunctionEnd
Function un.RemoveOpenSSHService
  SetOutPath "$INSTDIR\openssh"
  ExecWait "net stop sshd"
  ExecWait "sshd.exe uninstall"
  ExecWait "powershell uninstall-sshlsa.ps1"
FunctionEnd

Function SetEnvironmentVariables
  Push PDT_HOME
  Push ${PDT_HOME}
  Call WriteEnvStr
  Push ${PDT_HOME}\bin
  Call AddToPath
FunctionEnd
Function un.RemoveEnvironmentVariables
  Push PDT_HOME
  Call un.DeleteEnvStr
  Push ${PDT_HOME}\bin
  Call un.RemoveFromPath
FunctionEnd
