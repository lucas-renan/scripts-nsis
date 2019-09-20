#SiMco 2019 - renan.m
#Script de instala��o e registro de dll's para o TEF-Tasy

;-------pr�-requisitos
!include "x64.nsh" ; Biblioteca para redirecionamento x64
!include "MUI.nsh" ; Biblioteca de janelas
!define MUI_ICON "ext\tasy.ico" ; Atribu� o �cone
!insertmacro MUI_PAGE_INSTFILES ; Macro usada apenas para o �cone
!insertmacro MUI_LANGUAGE "PortugueseBR" ; Atribui a l�ngua padr�o
RequestExecutionLevel Admin ; pede eleva��o de administrador
Name "Ambiente TEF Tasy" ; nome do .exe nas janelas
OutFile "Ambiente_TEF 5.0.exe" ; nome do .exe de sa�da
AutoCloseWindow true ;fecha janela automticamente ap�s instala��o
ShowInstDetails show ;mostra os detalhes da instala��o por padr�o
InstallDir "$TEMP" ; define a pasta %TEMP% como pasta de instala��o

Section "InstalaJava" SEC01 ; instala o Java silenciosamente
	SetOutPath "$TEMP\Tasy_TEMP\bin"
    File "bin\jre1.8.0_22164.msi"
    ExecWait `"$SYSDIR\msiexec.exe" /i "$TEMP\Tasy_TEMP\bin\jre1.8.0_22164.msi" /m /qn /L*V C:\java.log` 
    DetailPrint "etapa instala��o Java conclu�da"
SectionEnd

Section "TasyAgent" SEC02 ; instala o m�dulo Tasy-Agent
    SetOutPath "$TEMP\Tasy_TEMP\bin" ; diret�rio onde ser� a sa�da dos arquivos do .exe
   	File "bin\tasy-agent-x64-1.34.1.msi" ; adiciona arquivo ao .exe 
	ExecWait `"$SYSDIR\msiexec.exe" /i "$TEMP\Tasy_TEMP\bin\tasy-agent-x64-1.34.1.msi" /m /qn /L*V C:\tasyagent.log` ; instala o tasy-agent 
    DetailPrint "etapa instala��o tasy-agent conclu�da"
SectionEnd

Section "Tasy_Files" SEC03
    SetOutPath "$TEMP\Tasy_TEMP\ext"
    
    File "ext\treasury-tef.war"
    CopyFiles "$TEMP\Tasy_TEMP\ext\treasury-tef.war" "C:\ProgramData\tasy-agent\modules" ; c�pia do war
    DetailPrint "etapa treasury conclu�da"
    
    File "ext\config.yml"
    CopyFiles "$TEMP\Tasy_TEMP\ext\config.yml" "C:\ProgramData\tasy-agent\" ; c�pia do yml com ip, senha, portas, etc.
    DetailPrint "etapa config.yml conclu�da"
    
    File "ext\mods.srv"
    CopyFiles "$TEMP\Tasy_TEMP\ext\mods.srv" "C:\ProgramData\tasy-agent\" ; c�pia configura��o tasy-treasury
    DetailPrint "etapa config.yml conclu�da"
SectionEnd

Section "AtalhoTasyWeb" SEC04 ; copia para a �rea de trabalho o �cone do google chrome devidamente configurado
    SetOutPath "$TEMP\Tasy_TEMP\ext"
    File "ext\TASY WEB.lnk" 
    CopyFiles "$TEMP\Tasy_TEMP\ext\TASY WEB.lnk" "C:\Users\Public\Desktop"
    DetailPrint "etapa atalho conclu�da"
SectionEnd

Section "RegistraDLLTasyTef" SEC05 ; cria diret�rio, copia e registra na pasta a dll do TASYTEF
	SetOutPath "$TEMP\Tasy_TEMP\ext"
    ${DisableX64FSRedirection} ; desabilita o redirecionamento autom�tico para SYSWOW64
	CreateDirectory "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	CopyFiles "$TEMP\Tasy_TEMP\ext\TasyTef.dll" "C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\"
	ExecWait '"$TEMP\Tasy_TEMP\ext\RegAsm.exe C:\Windows\Microsoft.NET\assembly\GAC_MSIL\TasyTef\v4.0_1.0.0.0__a4ed44d5b16f1926\TASYTEF.DLL" "ext\TasyTef.dll" /register /codebase /tlb'
SectionEnd

Section "CopiaDLLs" SEC06 ; copia as dll's adicionais para a system32
	SetOutPath "$TEMP\Tasy_TEMP\lib"
    ${DisableX64FSRedirection} ; desabilita o redirecionamento autom�tico para SYSWOW64
	CopyFiles "$TEMP\Tasy_TEMP\lib\*.dll" "C:\Windows\System32"
	CopyFiles "$TEMP\Tasy_TEMP\lib\*.jar" "C:\Windows\System32"
SectionEnd