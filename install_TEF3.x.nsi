#SiMco 2019 - renan.m
#Script de instalação e registro de dll's para o TEF-Tasy

;-------pré-requisitos
!include "x64.nsh" ; Biblioteca para redirecionamento x64
!include "MUI.nsh" ; Biblioteca de janelas
!define MUI_ICON "ext\tasy.ico" ; Atribuí o ícone
!insertmacro MUI_PAGE_INSTFILES ; Macro usada apenas para o ícone
!insertmacro MUI_LANGUAGE "PortugueseBR" ; Atribui a língua padrão
RequestExecutionLevel Admin ; pede elevação de administrador
Name "Instalador dll's TEF Tasy" ; nome do .exe nas janelas
OutFile "Install_dll_TEF 3.2.exe" ; nome do .exe de saída
AutoCloseWindow true ;fecha janela automticamente após instalação
ShowInstDetails show ;mostra os detalhes da instalação por padrão

Section "TasyAgent" SEC01 ; instala o módulo Tasy-Agent
	File "bin\tasy-agent-x64-1.34.1.msi"
	ExecWait '"msiexec" /i  "bin\tasy-agent-x64-1.34.1.msi"'
SectionEnd

Section "AtalhoTasyWeb" SEC02 ; copia para a área de trabalho o ícone do google chrome devidamente configurado
	CopyFiles "ext\TASY WEB.lnk" "C:\Users\Public\Desktop"
SectionEnd

Section "InstalaJava" SEC03 ; instala o Java silenciosamente
	nsExec::Exec "bin\jre1.8.0_22164.msi"
	ExecWait '"msiexec" /i "bin\jre1.8.0_22164.msi"'
SectionEnd

Section "RegistraDLLTasyTef" SEC04 ; cria diretório, copia e registra na pasta a dll do TASYTEF
	${DisableX64FSRedirection} ; desabilita o redirecionamento automático para SYSWOW64
	CreateDirectory "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	CopyFiles "ext\TasyTef.dll" "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	ExecWait '"ext\RegAsm.exe C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\TASYTEF.DLL" "ext\TasyTef.dll" /register /codebase /tlb'
SectionEnd

Section "CopiaDLLs" SEC05 ; copia as dll's adicionais para a system32
	${DisableX64FSRedirection} ; desabilita o redirecionamento automático para SYSWOW64
	CopyFiles "lib\*.dll" "C:\Windows\System32"
	CopyFiles "lib\*.jar" "C:\Windows\System32"
SectionEnd