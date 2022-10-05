
#################################
#								#
#		 Moss Farm Bot			#
#		 by teddyoojo			#	
#								#
#################################


#RequireAdmin
#NoTrayIcon
#include "GWA2_Headers.au3"
#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", True)

Global Const $Map_ID_Saint_Anjeka = 349
Global Const $Map_ID_Drazack = 195
Global $runCount = 0
Global $failCount = 0
Global $curGold = 0
Global $botRunning = False
Global $charName = ""
Global $botInitialized = False
Global Const $doLoadLoggedChars = True

; ==== Build ====
Global Const $shroud = 2
Global Const $sf = 1
Global Const $winno = 3
Global Const $whirling = 4
Global Const $ee = 5
Global Const $dash = 6
Global Const $hos = 7
Global Const $soh = 8



#Region GUI
$mainGui = GUICreate("MossFarmBot", 293, 355, 440, 179)
$successfulRunLabel = GUICtrlCreateLabel("Succcesful Runs:" & $runCount, 8, 280, 150, 17)
$failedRunLabel = GUICtrlCreateLabel("Failed Runs: " & $failCount, 168, 280, 150, 17)
$currentGoldLabel = GUICtrlCreateLabel("Current Gold: " & $curGold, 8, 312, 150, 17)
Global $startStopBtn = GUICtrlCreateButton("Start", 46, 245, 200, 25)
GUICtrlSetOnEvent($startStopBtn, "GuiButtonHandler")
Global $editField = GUICtrlCreateEdit("", 40, 56, 209, 145)
Global $Input
If $doLoadLoggedChars Then
	$Input 				  = GUICtrlCreateCombo($charName, 8, 8, 217, 25)
						    GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input 				  = GUICtrlCreateInput("Character name", 8, 8, 217, 25)
EndIf
Out("DragonMossBot v0.1")
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_Event_Close, "GuiButtonHandler")
#EndRegion ### END Koda GUI section ###


Func GuiButtonHandler()
	If $botRunning == False Then
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe")) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		WinSetTitle($mainGui, "", "VBot-" & GetCharname())
		$botInitialized = True
		Out("Bot started")
		GUICtrlSetData($startStopBtn, "Pause")
		$botRunning = True
	Else
		Out("Bot paused")
		GUICtrlSetData($startStopBtn, "Start")
		$botRunning = False
	EndIf
	If  @GUI_CtrlId == $GUI_Event_Close Then
		Exit
	EndIf
EndFunc

Out("Dragon Moss Bot, lets goo")

While 1
	If $botRunning == True Then
		Out("Mapid:" & GetMapID())
		If GetMapID() == $Map_ID_Saint_Anjeka Then MainFarm()
	Else
		Out("Bot not running")
		Sleep(2000)
	EndIf
WEnd


Func Mainfarm()
	$curGold = GetGoldCharacter()
	Out("Gold: " & $curGold)
	GUICtrlSetData($currentGoldLabel, "Current Gold: " & $curGold)
	SwitchMode(1)
	Out("moving outside")
	MoveTo(-11000, -23000)
	WaitMapLoading($Map_ID_Drazack)
	Out("done moving")
	MoveTo(-9371, 18839)
	TargetNearestAlly()
	RndSleep(GetPing()+50)
	UseSkill($ee, GetCurrentTargetID())
	MoveTo(-6453, 16850)
	UseSkillEx($sf)
	UseSkillEx($shroud)
	MoveTo(-5237, 15654)
	MoveTo(-6232, 17333)
	UseSkillEx($soh)
	MoveTo(-6837, 18750)
	UseSkillEx($winno)
	While IsRecharged($sf) == False 
		Sleep(200)
	WEnd	
	UseSkillEx($sf)
	Sleep(1500 + GetPing())
	UseSkillEx($whirling)

EndFunc


;~ Description: Print to console with timestamp
Func Out($TEXT)
    GUICtrlSetData($editField, GUICtrlRead($editField) & @HOUR & ":" & @MIN & " - " & $TEXT & @CRLF)
EndFunc   ;==>OUT#
