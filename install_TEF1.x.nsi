#SiMco 2019 - renan.m
#Script de instalação e registro de dll's para o TEF-Tasy

Name "Instalador dll's TEF Tasy"
OutFile "Install_dll_TEF 1.14.exe"
!include x64.nsh
RequestExecutionLevel Admin

Section "TasyAgent" SEC01
	File "bin\tasy-agent-x64-1.34.1.msi"
	ExecWait '$INSTDIR\tasy-agent-x64-1.34.1.msi /sPB /rs /l /exe"/qb-! /norestart ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
SectionEnd

Section "AtalhoTasyWeb" SEC02
	CopyFiles "ext\TASY WEB.lnk" "C:\Users\Public\Desktop"
SectionEnd

Section "InstalaJava" SEC03
	File "bin\jre-8u221-windows-x64.exe"
	ExecWait '$INSTDIR\jre-8u221-windows-x64.exe /s /L /exe "ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
SectionEnd

Section "RegistraDLLTasyTef" SEC04
	${DisableX64FSRedirection}
	CreateDirectory "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	CopyFiles "ext\TasyTef.dll" "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	ExecWait '"ext\RegAsm.exe C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\TASYTEF.DLL" "ext\TasyTef.dll" /register /codebase /tlb'
SectionEnd

Section "CopiaDLLs" SEC05
	${DisableX64FSRedirection}
	CopyFiles "lib\*.dll" "C:\Windows\System32"
	CopyFiles "lib\*.jar" "C:\Windows\System32"
SectionEnd
