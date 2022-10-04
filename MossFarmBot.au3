
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

Global $runCount = 0
Global $failCount = 0
Global $curGold = 0
GLobal $botRunning = False

#Region GUI
$mainGui = GUICreate("MossFarmBot", 293, 355, 440, 179)
$successfulRunLabel = GUICtrlCreateLabel("Succcesful Runs:" & $runCount, 8, 280, 150, 17)
$failedRunLabel = GUICtrlCreateLabel("Failed Runs: " & $failCount, 168, 280, 150, 17)
$currentGoldLabel = GUICtrlCreateLabel("Current Gold: " & $curGold, 8, 312, 150, 17)
Global $startStopBtn = GUICtrlCreateButton("Start", 46, 245, 200, 25)
GUICtrlSetOnEvent($startStopBtn, "GuiButtonHandler")
Global $editField = GUICtrlCreateEdit("", 40, 56, 209, 145)
Out("DragonMossBot v0.1")
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_Event_Close, "GuiButtonHandler")
#EndRegion ### END Koda GUI section ###


Func GuiButtonHandler()
Switch @GUI_CtrlId
	Case $startStopBtn
		Out("btn pressed")

	Case $GUI_Event_Close
		Exit

	EndSwitch
EndFunc

Out("Dragon Moss Bot, lets goo")

While 1
	Sleep(100)
WEnd


;~ Description: Print to console with timestamp
Func Out($TEXT)
    GUICtrlSetData($editField, GUICtrlRead($editField) & @HOUR & ":" & @MIN & " - " & $TEXT & @CRLF)
EndFunc   ;==>OUT#