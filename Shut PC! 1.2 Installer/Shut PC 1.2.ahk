;
; AutoHotkey Version: 1.2.0.0
; Language:       Portuguese
; Platform:       Win7/8/8.1/10
; Author:         Saulo Alves
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

; Verifica se inicia o aplicativo em modo "menu" ou rodando (ShutPC)
IniRead, Cond, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond
If Cond = 0
{
		Goto, ShutPC
}

Menu, tray, NoStandard

; Se não existir o "shutpc.cfg" será criado um com valores default 
Vazio =
IfNotExist, %A_AppData%\ShutPC\shutpc.cfg
{
	FileCreateDir, %A_AppData%\ShutPC
	IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg, Opções de Ação, opcoes
	IniWrite, %Vazio% ,%A_AppData%\ShutPC\shutpc.cfg, Mensagem, mens	
}


; Início do Aplicativo

; Verifica se há senha para iniciar o aplicativo

	IniWrite, 0, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond	

; Cria a janela de menus e opções
; Create the sub-menus for the menu bar:
Menu, FileMenu2, Add, &Opções, Options
Menu, FileMenu2, Add
Menu, FileMenu2, Add, S&air, Exit
Menu, FileMenu, Add, &Sobre..., HelpAbout
Menu, FileMenu, Add
Menu, FileMenu, Add, Acessar o site, ShutPCSite

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, &Menu, :FileMenu2
Menu, MyMenuBar, Add, &Ajuda, :FileMenu

; Attach the menu bar to the window:
Gui, Menu, MyMenuBar

; Create the main Edit control and display the window:
Gui, Add, Text,, Selecione as opções desejadas: 
	
IniRead, ShutOpt, %A_AppData%\ShutPC\shutpc.cfg, Opções de Ação, opcoes
Gui, Add, DropDownList, AltSubmit Choose%ShutOpt% vShutOpt, Nenhum|Desligar|Reiniciar|Logoff|Hibernar
	
IniRead, TimeIni, %A_AppData%\ShutPC\shutpc.cfg, Horário da Ação, timeini
HourChoose := SubStr(TimeIni, 1, 2)
StringReplace, HourChoose, HourChoose, :, 
Gui, Add, Edit, w35 vHourChoice1x ReadOnly
Gui, Add, UpDown, vHourChoice1 Range00-23, %HourChoose%
Gui, Add, Text, y57 x50, h
MinChoose := SubStr(TimeIni, -1, 2)
StringReplace, MinChoose, MinChoose, :,
Gui, Add, Edit, y52 x70 w35 r1 vMinChoice1x ReadOnly
Gui, Add, UpDown, vMinChoice1 Range00-59, %MinChoose%
Gui, Add, Text, y57 x110, m

IniRead, AtivData, %A_AppData%\ShutPC\shutpc.cfg, Ativar Data, ativdata
If AtivData = 1
{
	Ticado3 = Checked
}
Else
{
	Ticado4 = Disabled
}
Gui, Add, Checkbox, y195 x10 %Ticado3% gData vData, Executar somente no dia:
IniRead, Data, %A_AppData%\ShutPC\shutpc.cfg, Data, data
Gui, Add, DateTime, %Ticado4% w230 vMyDateTime Choose%Data%, LongDate

IniRead, AtivMens, %A_AppData%\ShutPC\shutpc.cfg, Ativar Mensagem, ativmens
If AtivMens = 1
{
	Ticado = Checked
}
Else
{
	Ticado2 = Disabled
}
Gui, Add, Checkbox, y95 x10 %Ticado% gMensagem vMensagem, Ativar mensagem
IniRead, MensChoose, %A_AppData%\ShutPC\shutpc.cfg, Mensagem, mens
Gui, Add, Edit, %Ticado2% w230 r2 Limit100 vMyEdit, %MensChoose%
	
IniRead, MensTime, %A_AppData%\ShutPC\shutpc.cfg, Horário da Mensagem, menstime
HourChoose := SubStr(MensTime, 1, 2)
StringReplace, HourChoose, HourChoose, :,
Gui, Add, Edit, %Ticado2% y153 x10 w35 r1 vHourChoice2x ReadOnly
Gui, Add, UpDown, vHourChoice2 Range00-23, %HourChoose%
Gui, Add, Text, y158 x50, h
MinChoose:= SubStr(MensTime, -1, 2)
StringReplace, MinChoose, MinChoose, :,
Gui, Add, Edit, %Ticado2% y153 x70 w35 r1 vMinChoice2x ReadOnly
Gui, Add, UpDown, vMinChoice2 Range00-59, %MinChoose%
Gui, Add, Text, y158 x110, m
Gui, Add, Button, y257 x50 w60 Default, Iniciar
Gui, Add, Button, y257 x131 w60, Fechar
Gui, Show,, Shut PC! 1.2
return

GuiClose:
ExitApp

Data:
Gui, Submit, NoHide
If Data
{
	GuiControl, Enable, MyDateTime
}
Else
{
	GuiControl, Disable, MyDateTime
}
return

Mensagem:
Gui, Submit, NoHide
If Mensagem
{
	GuiControl, Enable, MyEdit
	GuiControl, Enable, MinChoice2x
	GuiControl, Enable, HourChoice2x 
}
Else
{
	GuiControl, Disable, MyEdit
	GuiControl, Disable, MinChoice2x
	GuiControl, Disable, HourChoice2x
}
return


ButtonFechar:
ExitApp
return


ButtonIniciar:
Gui, Submit, NoHide

IniWrite, %ShutOpt%, %A_AppData%\ShutPC\shutpc.cfg, Opções de Ação, opcoes
	
IniWrite, %Data%, %A_AppData%\ShutPC\shutpc.cfg, Ativar Data, ativdata

IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg,Anti Shut Exec, antishutexec
	
MyDateTime := SubStr(MyDateTime, 1, 8)
IniWrite, %MyDateTime%, %A_AppData%\ShutPC\shutpc.cfg, Data, data
	
If HourChoice1 < 10
	{
		HourChoice1 = 0%HourChoice1%
	}
If MinChoice1 < 10
	{
		MinChoice1 = 0%MinChoice1%
	}
TimeIni = %HourChoice1%:%MinChoice1%
IniWrite, %TimeIni%, %A_AppData%\ShutPC\shutpc.cfg, Horário da Ação, timeini

IniWrite, %Mensagem%, %A_AppData%\ShutPC\shutpc.cfg, Ativar Mensagem, ativmens

IniWrite, %MyEdit%, %A_AppData%\ShutPC\shutpc.cfg, Mensagem, mens

If HourChoice2 < 10
	{
		HourChoice2 = 0%HourChoice2%
	}
If MinChoice2 < 10
	{
		MinChoice2 = 0%MinChoice2%
	}
MensTime = %HourChoice2%:%MinChoice2%
IniWrite, %MensTime%, %A_AppData%\ShutPC\shutpc.cfg, Horário da Mensagem, menstime

IniWrite, 0, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond	

Reload

ExitApp
return
  

Options:
Gui, 2:Add, GroupBox, w340 h70, Opções
Gui, 2:+owner1
Gui +Disabled
	
IniRead, IniWin, %A_AppData%\ShutPC\shutpc.cfg, Iniciar com o Windows, iniwin
If IniWin = 1
{
	Ticado5 = Checked
}
Else
{
	Ticado5 =
}

; Verifica se o programa está sendo executado como administrador
If A_IsAdmin = 1
{
	IniWindows = 
}
Else
{
	IniWindows = Disabled
}


Gui, 2:Add, Checkbox, %IniWindows% y28 x17  %Ticado5% vIniciar, Iniciar com o Windows (necessário executar como administrador)
	
IniRead, IniWin, %A_AppData%\ShutPC\shutpc.cfg, Aviso Sonoro, sonoro
If IniWin = 1
{
	Ticado6 = Checked
}
Else
{
	Ticado6 =
}
Gui, 2:Add, Checkbox, y48 x17 %Ticado6% vWarnSound, Alerta sonoro quando exibir mensagem
	
Gui, 2:Add, Button, y84 x107 w60 Default, OK
Gui, 2:Add, Button, y84 x188 w60, Cancelar
Gui, 2:Show,, Opções - Shut PC! 1.2
return

Exit:
ExitApp
return
	
HelpAbout:
Gui, 2:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui +Disabled  ; Disable main window.
Gui, 2:Add, GroupBox, w260 h175, Sobre...
Gui, 2:Add, Text, y25 x20, Shut PC! 1.2`n `nEste é um software gratuito, pode ser`ndistribuído e utilizado livremente.`nNenhuma taxa pode ser cobrada por ele.`n`nBom proveito,`n`nSaulo Alves.
Gui, 2:Add, Button, x100 w60 Default, Shut It!
Gui, 2:Show,, Sobre - Shut PC! 1.2
return

ShutPCSite:
Run https://sauloalves10.github.io/SauloAlves/
return

2ButtonOK:
Gui, 2: Submit, NoHide
	
		
	If Iniciar = 1
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, ShutPC, %A_ScriptFullPath%
		IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond
		IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg, Iniciar com o Windows, iniwin
	}
	Else
	{
		RegDelete, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, ShutPC
		IniWrite, 0, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond
		IniWrite, 0, %A_AppData%\ShutPC\shutpc.cfg, Iniciar com o Windows, iniwin
	}
		
	If WarnSound = 1
	{
		IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg, Aviso Sonoro, sonoro
	}
	Else
	{
		IniWrite, 0, %A_AppData%\ShutPC\shutpc.cfg, Aviso Sonoro, sonoro
	}
		
	Gui, 1:-Disabled
	Gui Destroy


2ButtonShutIt!:  ; This section is used by the "about box" above.
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
return

2ButtonCancelar:
2GuiClose:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy
return


;......................................................


; Aplicativo rodando

ShutPC:
Menu, tray, Tip, Shut PC! 1.2
Menu, tray, NoStandard

Menu, tray, add, Abrir o Shut PC!, Open

IniRead, TimeIni, %A_AppData%\ShutPC\shutpc.cfg, Horário da Ação, timeini
IniRead, ShutOpt, %A_AppData%\ShutPC\shutpc.cfg, Opções de Ação, opcoes
IniRead, ContMens, %A_AppData%\ShutPC\shutpc.cfg, Ativar Mensagem, ativmens
IniRead, Mens, %A_AppData%\ShutPC\shutpc.cfg, Mensagem, mens

If ContMens = 1
{
	IniRead, MensTime, %A_AppData%\ShutPC\shutpc.cfg, Horário da Mensagem, menstime
	TrayTipMens = `nUma mensagem será exibida às %MensTime%	
}

IniRead, ContData, %A_AppData%\ShutPC\shutpc.cfg, Ativar Data, ativdata
If ContData = 1
{
	IniRead, DataShut, %A_AppData%\ShutPC\shutpc.cfg, Data, data
	Dia := SubStr(DataShut, 7, 8)
	Mes := SubStr(DataShut, 5, 6)
	Mes := SubStr(Mes, 1, 2)
	Ano := SubStr(DataShut, 1, 4)
	DataShut = %Dia%/%Mes%/%Ano%
	TrayTipData = `nData de execução da tarefa: %DataShut%
}

If ShutOpt = 1
{
	TrayTip, Shut PC!, Não há uma ação definida%TrayTipMens%%TrayTipData%, 5, 1
}
If ShutOpt = 2
{
	TrayTip, Shut PC!, O computador irá Desligar às %TimeIni%%TrayTipMens%%TrayTipData%, 5, 1
}
If ShutOpt = 3
{
	TrayTip, Shut PC!, O computador irá Reiniciar às %TimeIni%%TrayTipMens%%TrayTipData%, 5, 1
}
If ShutOpt = 4
{
	TrayTip, Shut PC!, O computador fará Logoff às %TimeIni%%TrayTipMens%%TrayTipData%, 5, 1
}
If ShutOpt = 5
{
	TrayTip, Shut PC!, O computador irá Hibernar às %TimeIni%%TrayTipMens%%TrayTipData%, 5, 1
}


Loop
{
	IniRead, Cond, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond

	If Cond <> 0
	{
		Goto, Exit2
	} 

	FormatTime, TimeString, T12, HH:mmtt

	IniRead, AtivData, %A_AppData%\ShutPC\shutpc.cfg, Ativar Data, ativdata
	
	IniRead, antishutexec, %A_AppData%\ShutPC\shutpc.cfg,Anti Shut Exec, antishutexec
	FormatTime, TimeStringData3, , yyyyMMdd
	If antishutexec <> %TimeStringData3%
	{
		If AtivData = 1
		{
			IniRead, Data, %A_AppData%\ShutPC\shutpc.cfg, Data, data
			FormatTime, TimeStringData, , yyyyMMdd
			
			If Data = %TimeStringData%
			{
				If TimeString = %TimeIni%
				{
					FormatTime, TimeStringData2, , yyyyMMdd
					IniWrite, %TimeStringData2%, %A_AppData%\ShutPC\shutpc.cfg,Anti Shut Exec, antishutexec
					
					If ShutOpt = 1
					{
						Goto, Pula
					}
					If ShutOpt = 2
					{
						ShutOptAct = 5
					}
					If ShutOpt = 3
					{
						ShutOptAct = 6
					}
					If ShutOpt = 4
					{
						ShutOptAct = 4
					}
					If ShutOpt = 5
					{
						DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
						Goto, Exit2
					}
					
					Shutdown, %ShutOptAct%
					Goto, Exit2
					
					Pula:
					{
					}
							
				}
				
			}	
		}
		Else
		{
			If TimeString = %TimeIni%
			{
				FormatTime, TimeStringData2, , yyyyMMdd
				IniWrite, %TimeStringData2%, %A_AppData%\ShutPC\shutpc.cfg,Anti Shut Exec, antishutexec
					
				If ShutOpt = 1
				{
					Goto, Pula2
				}
				If ShutOpt = 2
				{
					ShutOptAct = 5
				}
				If ShutOpt = 3
				{
					ShutOptAct = 6
				}
				If ShutOpt = 4
				{
					ShutOptAct = 4
				}
				If ShutOpt = 5
				{
					DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
					Goto, Exit2
				}
				
				Shutdown, %ShutOptAct%
				Goto, Exit2
					Pula2:
				{
				}

			}

		}

	}
	
	If ContMens = 1
	{
		
		If AtivData = 1
		{
			IniRead, Data,  %A_AppData%\ShutPC\shutpc.cfg, Data, data
			FormatTime, TimeStringData, , yyyyMMdd
			
			If Data = %TimeStringData%
			{	

				If TimeString = %MensTime%
				{
					IniRead, Avsonoro, %A_AppData%\ShutPC\shutpc.cfg, Aviso Sonoro, sonoro
					
					If AvSonoro = 1 
					{
						SoundBeep, 352, 250
						SoundBeep, 396, 250
						SoundBeep, 264, 500
					} 
					ContMens = 0
					MsgBox, 0, Mensagem - Shut PC!, %Mens%, 55
				}
			}
		}
		Else
		{
			If Data = %TimeStringData%
			{	

				If TimeString = %MensTime%
				{
					IniRead, Avsonoro, %A_AppData%\ShutPC\shutpc.cfg, Aviso Sonoro, sonoro
					
					If AvSonoro = 1 
					{
						SoundBeep, 352, 250
						SoundBeep, 396, 250
						SoundBeep, 264, 500
					} 
					ContMens = 0
					MsgBox, 0, Mensagem - Shut PC!, %Mens%, 55
				}
			}
		}
			
	}
	
	Sleep, 1000

}


Exit2:
ExitApp
return

Open:
IniWrite, 1, %A_AppData%\ShutPC\shutpc.cfg, Condição, cond 
Reload