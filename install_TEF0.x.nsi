#SiMco 2019 - renan.m
#Script de instalação e registro de dll's para o TEF-Tasy

!include x64.nsh
RequestExecutionLevel Admin

;Nome do arquivo
Name "Instalador dll's TEF Tasy"
OutFile "Install_dll_TEF 0.5.exe"

Function Instalar
	MessageBox MB_YESNO "Instalar as dll's?"  IDYES true IDNO false
	true: Call Copia
	false: Quit
FunctionEnd

Function Copia
SetOutPath $SysDir

;Verifica se sistema é x64
;executa a cópia das dll's
${If} ${RunningX64}
	;verificar https://nsis-dev.github.io/NSIS-Forums/html/t-318746.html
	${DisableX64FSRedirection}
	File /r "lib64\*.dll" ;  Instala as dll's para Windows 64-bits
		SetErrors
		IfErrors 0 +2
		MessageBox MB_OK "Falha ao copiar"
	;Registra a dll TasyTef
	nsExec::Exec '"ext\RegAsm.exe" /tlb /register /codebase /nologo /silent "ext\TasyTef.dll"'
		IfErrors 0 +2
		MessageBox MB_OK "Falha ao registrar TasyTef.dll"
	#Pop $0 ; Process exit code or "error" in $0
	${EnableX64FSRedirection}
	
	; Instala as dll's para Windows 32-bits
	${Else}
		File /r "lib32\*.dll"
${EndIf}
MessageBox MB_OK "Instalação concluída\n com sucesso"
FunctionEnd

Function TasyAgent
	${If} ${RunningX64}
		File "bin\tasy-agent-x64-1.34.1.msi"
	${Else}
		File "bin\tasy-agent-x86-1.34.1.msi"
	${EndIf}

FunctionEnd

Function "Teste"
	MessageBox MB_OK "Funciona!"
FunctionEnd

Section "-Prerequisitos"
	MessageBox MB_YESNO "Instalar Tasy Agent?" IDYES true IDNO false
	true: Call TasyAgent
	false: Abort
SectionEnd

Section "Install"
	Call TasyAgent
SectionEnd