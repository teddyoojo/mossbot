
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
Global Const $ITEM_ID_Dyes = 146
Global Const $ITEM_ExtraID_BlackDye = 10
Global Const $ITEM_ID_Lockpicks = 22751
Global Const $PickUpAll = False
Global Const $ITEM_ID_Plant_Fibres = 28
Global Const $ITEM_ID_Spiritwood = 41

#Region Global Items
Global Const $RARITY_Gold = 2624
Global Const $RARITY_Purple = 2626
Global Const $RARITY_Blue = 2623
Global Const $RARITY_White = 2621

Global $Array_pscon[39]=[910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, 21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]
Global $Rare_Materials_Array[25] = [922, 923, 926, 927, 928, 930, 931, 932, 935, 936, 937, 938, 939, 941, 942, 943, 944, 945, 949, 950, 951, 952, 956, 6532, 6533]
Global $All_Materials_Array[36] = [921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

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
	UseSkillEx($dash)
	Out("done moving")
	MoveTo(-9248, 19113)
	TargetNearestAlly()
	RndSleep(GetPing()+50)
	UseSkill($ee, GetCurrentTargetID())
	MoveTo(-7805, 18186)
	UseSkillEx($sf)
	UseSkillEx($shroud)
	MoveTo(-6453, 16850)
	UseSkillEx($dash)
	MoveTo(-5237, 15654)
	MoveTo(-6225, 17411)
	Sleep(GetPing() + 50)
	UseSkillEx($soh)
	MoveTo(-6816, 18779)
	UseSkillEx($winno)
	While IsRecharged($sf) == False 
		Sleep(200)
	WEnd	
	UseSkillEx($sf)
	Sleep(GetPing()+ 100)
	UseSkillEx($whirling)
	Sleep(10000)
	CustomPickUpLoot()
	If GetIsDead(-2) Then
		$failCount += 1
		GUICtrlSetData($failedRunLabel, "Failed Runs: " & $failCount)
	Else 
		$runCount += 1
		GUICtrlSetData($successfulRunLabel, "Successful Runs: " & $runCount)
	EndIf
	Resign()
	Sleep(3500+GetPing())
	ReturnToOutpost()
	WaitMapLoading($Map_ID_Saint_Anjeka)


EndFunc

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func CustomPickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If CountSlots() < 1 Then Return ;full inventory dont try to pick up
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CustomCanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CustomCanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelId')
	Local $aExtraID = DllStructGetData($aItem, 'ExtraId')
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If ($lModelID == 2511) Then
		If (GetGoldCharacter() < 99000) Then
			Return True	; gold coins (only pick if character has less than 99k in inventory)
		Else
			Return False
		EndIf
	ElseIf ($lModelID == $ITEM_ID_Dyes) Then	; if dye
		If ($aExtraID == $ITEM_ExtraID_BlackDye) Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_Gold) Then ; gold items
		Return True

	ElseIf($lModelID == $ITEM_ID_Plant_Fibres) Then
		Return True
	ElseIf($lModelID == $ITEM_ID_Spiritwood) Then
		Return True
	ElseIf($lModelID == $ITEM_ID_Lockpicks) Then
		Return True ; Lockpicks
	ElseIf CheckArrayPscon($lModelID) Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf ($lRarity == $RARITY_White) And $PickUpAll Then ; White items
		Return False
	ElseIf CheckArrayRareMats($lModelID) Then
		Return True
	ElseIf CheckArrayNormalMats($lModelID) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CustomCanPickUp

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in your Imventory

;~ Description: Print to console with timestamp
Func Out($TEXT)
    GUICtrlSetData($editField, GUICtrlRead($editField) & @HOUR & ":" & @MIN & " - " & $TEXT & @CRLF)
EndFunc   ;==>OUT#

#Region Arrays
Func CheckArrayPscon($lModelID)
	For $p = 0 To (UBound($Array_pscon) -1)
		If ($lModelID == $Array_pscon[$p]) Then Return True
	Next
EndFunc

Func CheckArrayRareMats($lModelID)
	For $p = 0 To (UBound($Rare_Materials_Array) -1)
		If($lModelID == $Rare_Materials_Array[$p]) THen Return True
	Next
EndFunc

Func CheckArrayNormalMats($lModelID)
	For $p = 0 To (UBound($All_Materials_Array) -1)
		If($lModelID == $All_Materials_Array[$p]) THen Return True
	Next
EndFunc