#SiMco 2019 - renan.m
#Script de instalação e registro de dll's para o TEF-Tasy

Name "Instalador dll's TEF Tasy"
OutFile "Install_dll_TEF 2.2.exe"
!include x64.nsh
RequestExecutionLevel Admin

Section "Principal" TASY
	
	;instala Tasy Agent
	MessageBox MB_YESNO "Instalar o TasyAgent?" /SD IDYES IDNO fimTasyAgent
	File "bin\tasy-agent-x64-1.34.1.msi"
	ExecWait '$INSTDIR\tasy-agent-x64-1.34.1.msi /sPB /rs /l /exe"/qb-! /norestart ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
	fimTasyAgent:
	
	;copia o atalho no desktop
	MessageBox MB_YESNO "Copiar Atalho para o desktop?" /SD IDYES IDNO fimCopiaAtalho
	CopyFiles "ext\TASY WEB.lnk" "C:\Users\Public\Desktop"
	fimCopiaAtalho:

	;instala o Java
	MessageBox MB_YESNO "Instalar o Java?" /SD IDYES IDNO fimInstalaJava
	File "bin\jre-8u221-windows-x64.exe"
	ExecWait '$INSTDIR\jre-8u221-windows-x64.exe /s /L /exe "ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"'
	fimInstalaJava:

	${DisableX64FSRedirection}
	
	;registra as dll's no GAC com o RegAsm do .NETframework
	MessageBox MB_YESNO "Registrar dll TasyTef.dll?" /SD IDYES IDNO fimRegistraDLLTasyTef
	CreateDirectory "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	CopyFiles "ext\TasyTef.dll" "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	ExecWait '"ext\RegAsm.exe C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\TASYTEF.DLL" "ext\TasyTef.dll" /register /codebase /tlb'
	fimRegistraDLLTasyTef:

	;instala as libs na system32
	MessageBox MB_YESNO "Instalar as dll's para o Tasy-Agent?" /SD IDYES IDNO fimCopiaDLLs
	CopyFiles "lib\*.dll" "C:\Windows\System32"
	CopyFiles "lib\*.jar" "C:\Windows\System32"
	fimCopiaDLLs:
	MessageBox MB_ICONINFORMATION "Concluido"
SectionEnd
