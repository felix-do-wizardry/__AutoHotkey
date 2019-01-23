﻿;===Description=========================================================================
/*
RM2module (Radial menu 2 module)
Author:		Boris Mudrinić (Learning one on AHK forum)
Contact:	boris.mudrinic@gmail.com
Thanks:		Chris Mallett, Tic (Tariq Porter), Majkinetor (Miodrag Milić), TomXIII, and others...
Link:		www.autohotkey.com/community/viewtopic.php?f=2&t=50813
Version:	2.22

Requires Gdip.ahk by Tic: www.autohotkey.com/community/viewtopic.php?f=2&t=32238

LICENSE:	
As the author of "RM2module", I'm reserving all my rights but I'm allowing the following:
You may use this module in your personal, non-commercial AutoHotkey scripts, written by you.
Without my written permission, nobody is allowed to have any profit from this module or any script/program that uses it.
You may upload any part of this module only on english AutoHotkey forum or www.autohotkey.net. Description section must
remain at beginning of this module. I'm not responsible for any damages arising from the use of this module. Everyone is
encouraged to improve it, but no matter how much anyone improve it, my share in authorship will always be minimum 91%.
If you notice any sort of license or copyright violation by any person, you agree that you will report that to me
immediately and that you will testify on court in case of litigation. On issues not regulated with this license Croatian
laws apply. In case of litigation, Croatian laws and language apply and Municipal court in Zagreb has jurisdiction.
If you don't agree on all terms in this license, you are not allowed to use this module on any way, you can't even just take
a look at it or study it, and you must delete it from computer and any other device that can store electronic data immediately.
*/



;===Documentation=======================================================================
/*
RM2_On(SkinDir,SkinOverride="",ItemGlowGuiNum=99)
	Call this function before you start creating menus.
	SkinDir			loads skin form specified directory
	SkinOverride	you can override any skin attribute + ItemLayoutPerRing here. Syntax example: "ItemSize.80 RadiusSizeFactor.0.85 TextRendering.4"
	ItemGlowGuiNum	Item glow consumes one GUI per all created menus in script. Here you can specify its GUI number.

	This function checks was GDI+ initialized or not.
	If GDI+ is not initialized, than RM2_On() automatically calls Gdip_Startup(), stores pToken in RM2_Reg("pToken"), and calling RM2_Off() will automatically call Gdip_Shutdown().
	If GDI+ is initialized, than RM2_On() will not call Gdip_Startup() again, and calling RM2_Off() will not call Gdip_Shutdown(), so user will have to call it himself.


RM2_Off()	; Call this function after you created all menus you need. It disposes of loaded skin images and frees memory. If pToken is stored in RM2_Reg("pToken"), it automatically calls Gdip_Shutdown() and shuts down GDI+.


RM2_CreateMenu(GuiNum,ItemAttributes,SpecMenuBack="",SpecMenuFore="",OneRingerAtt="",CentralTextOrImageAtt="")
	Creates radial menu. Returns "GuiNum"
	
	GuiNum:
		Every menu uses one GUI, so here specify menu's GUI number.
	
	ItemAttributes:
		"|" is separator between items
		">" is separator between item's Text>Icon>Tooltip>Submenu>SpecItemBack>SpecItemFore
		Blank item "||" is separator.
		Example: "Item1Text|Item2Text>C:\Item2Icon.png>Item2Tooltip||>C:\Item4Icon.png"
		
		"ntt" in Tooltip means "no Tooltip", if <blank>, Tooltip is automated, if something else - specified Tooltip applies.
		For SpecItemBack SpecItemFore the same logic as for SpecMenuBack and SpecForeBack applies.
		"Submenu" doesn't create real link between main menu and its submenus (for now), it just creates submenu mark in item - two tiny stars.
		
		
	SpecMenuBack can be:
		<blank>		than menu background from skin applies
		<full path of special menu background>
		"nb" 		which means no background
		(Note: specified SpecMenuBack overrides menu background from skin)
	
	SpecMenuFore can be:
		<blank>		than menu foreground from skin applies
		<full path of special menu foreground>
		"nf" 		which means no foreground
		(Note: specified SpecMenuFore is drawn above menu foreground from skin)
	
	OneRingerAtt:
		if blank, menu is multi ringer, if anything else it's one ringer. Supports two optional subparameters:
			FixedRadius.<value>					Menu radius is automated - it depends on number of items unless it's fixed.
			MinRadius.<value>					58 is default.
		examples:
		RM2_CreateMenu(1, "1|2|3|4|5|6|7|8|9", "", "",1 )	; creates one ring menu with auto radius
		RM2_CreateMenu(1, "1|2|3|4|5|6|7|8|9", "", "", "FixedRadius.100")	; creates one ring menu with radius fixed at 100 pixels.
		
	CentralTextOrImageAtt:
		">" is separator between CentralText>CentralImage>CentralImageSizeFactor
		
	To get handle of menu's window (WinodwID), call: RM2_Reg("M" GuiNum "#HWND"). Example: Menu3HWND := RM2_Reg("M3#HWND")
	

RM2_Show(GuiNum, x="", y="")
	x, y parameters. If x is :
		<blank> 			shows menu under mouse
		"c" or "Center"		shows menu on the center of the screen
		<else>				shows menu centered at x,y coordinates relative to screen


RM2_ShowAsSubmenu(ChildGuiNum, ParentGuiNum, ParentItemNumber)
	; for example, RM2_ShowAsSubmenu(2, 1, 3) means: show menu number 2 as submenu that belongs to 3. item in menu number 1.


RM2_Hide(GuiNum)


RM2_GetSelectedItem(GuiNum, SelectMethod="", key="", options="", StartX="", StartY="")
	
	Returns selected item.
	
	SelectMethod:
	"c"					click to select
	<anything else>		release to select
	
	key:				a key that has to be clicked or released to return from this function.
						If key is <blank>, if SelectMethod is:
						- "click to select" key is automatically set to LButton
						- "release to select" key is automatically set to refined A_ThisHotkey.
						If key is <not blank>, specified key applies.
						
	Options (white space separated):
	"gn"				appends "|" and menu's Gui number to return value if item is selected. Think about it as %A_ThisMenuItem%|%A_ThisMenu%
	"pos"				returns item's position instead of it's refined text. Refined text is item's text (precedence) or icon's file name without extension.
	"rc"				after selection, return mouse to the center of menu, but if user doesn't select anything, don't return it. Similar to "ri" in RMmodule.
	"ntt"  				no ToolTips
	"bc.<value>"		blink count if user selected item
	"bs.<value>"		blink sleep (sleep between blinks) if user selected item
	
	"iicr.<value>"		"is in circle return" - returns specified value if user selected "close menu circle" (center of menu). Return value should be some
						forbidden character like: "|" or ">"	
	"foh.<FunctionName>.<parameter1>.<parameter2>"		"function on hoover" Function to call when mouse is over new item. Designed for SoundOnHover in RM app.
						for example "foh.RMApp_PostMessage.RMSoundOnHover.1" option calls "RMApp_PostMessage("RMSoundOnHover",1)"


RM2_Handler(GuiNum, SelectMethod="", key="", options="",ShowPosX="", ShowPosY="")
	This function is a shortcut that combines RM2_Show(), RM2_GetSelectedItem() and RM2_Hide() in one.
	For first 4 parameters see RM2_GetSelectedItem(). For last 2 parameters see RM2_Show()
	Returns selected item. 

RM2_Version()		; returns RM2modules' version

RM2_CreateLayeredWin(GuiNum,pBitmap,DrawControlOutline=0)	; Creates layered window from pBitmap and returns its HWND (WinID)
	
RM2_CreateItemBitmap(ItemAttributes="",ItemSize="")
	Creates Item/Dock bitmap. Returns pBitmap.
	ItemAttributes		">" is separator between item's Text>Icon>Tooltip>Submenu>SpecItemBack>SpecItemFore. (Just one item)
	ItemSize			if blank --> ItemSize from skin applies, else --> specified size applies (not finished yet!)

RM2_SaveButtonToFile(FilePath, ItemAttributes="", Size="")
	For "ItemAttributes" and "Size" see RM2_CreateItemBitmap(). Use ".png" formats!



;====== RM as dock ======
RM2_CreateDock(GuiNum, ItemAttributes="", ChildMenu="", Size="") {
	Creates dock. Returns GuiNum.
	GuiNum				Every dock uses one GUI, so here specify dock's GUI number.
	ItemAttributes		">" is separator between item's Text>Icon>Tooltip>Submenu>SpecItemBack>SpecItemFore. (Just one item).
	ChildMenu 			specify which menu (GuiNum) you want to show when you click on dock. To show nothing, leave it blank.
	Size				if blank --> ItemSize from skin applies, else --> specified size applies (not finished yet!)
	
	To get handle of dock's window (WinodwID), call: RM2_Reg("M" GuiNum "#HWND"). Example: Dock3HWND := RM2_Reg("M3#HWND")


RM2_DockHandler(SelectMethod="", Options = "", EnableMoveKey = "Control") {
	This function is responsible for getting selected item or moving dock if EnableMoveKey + LButton are down. 
	"Dock to handle" is a window on which user clicked, if it is a dock.
	Returns selected item from ChildMenu. If dock hasn't got assigned ChildMenu, function returns "|" A_Gui
	SelectMethod	same as for RM2_GetSelectedItem() (release or click to select)
	Options			same as for RM2_GetSelectedItem() + one aditional;
					"cm" - centers mouse on the dock after click down
	EnableMoveKey	EnableMoveKey + LButton down enables moving dock


RM2_DockHandler2(SelectMethod="", Options = "", EnableMoveKey = "Control") {	; custom version of RM2_DockHandler()
	Same as RM2_DockHandler, but here "dock to handle" is window under mouse (not active, clicked window), if it is a dock. Allows to handle not active dock.

RM2_ShowDocks(DocksToShowList="") {
	Comma delimited list of docks to show. Hides all other. ShowDocks() hides all docks (like RM2_HideAllDocks())

RM2_IsDockUnderMouse() {	; returns 1 if dock is under mouse
RM2_IsDock(GuiNum)		; checks is specified GuiNum dock or not.
RM2_ShowAllDocks()
RM2_HideAllDocks()
To show/hide just one dock, use;
	- RM_Show(GuiNum) and RM_Hide(GuiNum), or
	- "Gui %GuiNum%:Show" and "Gui %GuiNum%:Hide"

RM2_SetDocksToDesktop(GuiNumbers="")
	Comma delimited list of docks to set to desktop. If blank, sets all existing docks to desktop.
	Examples: RM2_SetDocksToDesktop("2,4,6"), RM2_SetDocksToDesktop()


;======RM in standard GUI======
RM2_DrawOnPic(ControlHwnd,ItemAttributes="",Size="") {
	Creates and draws button on a GUI picture (which must have "0xE" style).
	ControlHwnd				hwnd of control on which you want to draw button
	ItemAttributes, Size	same as for RM2_CreateDock().

RM2_PicHandler(MenuToShow, ControlHwnd="",Options="", SelectMethod="") {
	Shows menu above GUI picture and returns selected item.
	MenuToShow		here specify which menu you want to show when you click on GUI picture.
	ControlHwnd		hwnd of control above which you want to show menu. If blank, control under mouse applies.
	Options			same as for RM2_GetSelectedItem()
	SelectMethod	same as for RM2_GetSelectedItem() (release or click to select)


;====== Other functions ======	
RM2_IsGdipStartedUp()	returns 1 if Gdip is started up or blank value otherwise
RM2_IsRM2moduleOn()		returns 1 if RM2module is turned on or blank value otherwise

RM2_DoesExist(GuiNum)	returns 1 if menu or dock (identified by GuiNum) exists or blank value otherwise
RM2_IsDock(GuiNum)		returns 1 if GuiNum is dock or blank value otherwise
RM2_IsMenu(GuiNum)		returns 1 if GuiNum is menu or blank value otherwise

RM2_Reg("MenusList")	returns list of existing menus. Example: "11,12,13"
RM2_Reg("DocksList")	returns list of existing docks. Example: "17,18"

RM2_GetMenusHwndList()	returns comma delimited list of menu window hwnds
RM2_GetDocksHwndList()	returns comma delimited list of dock window hwnds

RM2_IsMenuUnderMouse() 	returns 1 if menu is under mouse
RM2_IsDockUnderMouse()	returns 1 if dock is under mouse

RM2_Delete(GuiNum)		deletes menu or dock, empties/updates registers and destroys GUI
RM2_Redraw()			redraws all radial menus and docks. Useful if you have "layered windows are not visible after resuming from hibernation" problem.



;====== Notes ======	
If you are using:
- AutoHotkey (_L), GuiNum in all RM2 functions can be number or string (named Gui)
- AutoHotkey Basic, GuiNum in all RM2 functions can be only number

*/






;===Functions===========================================================================
RM2_Version() {
return 2.22
}
RM2_On(SkinDir,SkinOverride="",ItemGlowGuiNum=99) {
static SkinAttributes := "ItemSize,RadiusSizeFactor,ItemLayoutPerRing,AutoSubmenuMarking,AutoSubmenuMark,TextBoxShrink,ItemGlow,TextFont,TextSize,TextColor,TextTrans,TextRendering,TextShadow,TextShadowColor,TextShadowTrans,TextShadowOffset,IconShrink,IconTrans,ItemBack,ItemBackShrink,ItemBackTrans,ItemFore,ItemForeShrink,ItemForeTrans,ItemShadow,ItemShadowShrink,ItemShadowTrans,MenuBack,MenuBackSize,MenuBackTrans,MenuBackOuterRim,MenuBackOuterRimWidth,MenuBackOuterRimTrans,MenuFore,MenuForeSize,MenuForeTrans,SkinText,SkinAuthor,SkinAbout,MenuShadowWidth,MenuShadowInnerColor,MenuShadowOuterColor,MenuBackHatchStyle,MenuBackHatchFrontColor,MenuBackHatchBackColor,MenuBackHatchShrink,MenuBackOuterRimHatchStyle,MenuBackOuterRimHatchFrontColor,MenuBackOuterRimHatchBackColor,MenuBackOuterRimHatchShrink,ItemBackHatchStyle,ItemBackHatchFrontColor,ItemBackHatchBackColor,ItemBackHatchShrink,MenuBackCenter,MenuBackCenterShrink"
if (RM2_Reg("IsRM2moduleOn") = 1)	
return
if (RM2_IsGdipStartedUp() != 1) {	
pToken := Gdip_Startup()
if !pToken
{
MsgBox, 64, GDI+ error, GDI+ failed to start. Please ensure you have GDI+ on your system.`n`nApplication will exit.
ExitApp
}
RM2_Reg("pToken", pToken)
}
FileRead, Variables, %SkinDir%\Skin definition.txt
if ErrorLevel
{
MsgBox,64, RM2module error, Skin definition not found:`n%SkinDir%\Skin definition.txt`n`nApplication will exit.
ExitApp
}
StringReplace, Variables, Variables, `r, ,all
Loop, parse, Variables, `n
{
Field := A_LoopField
if Field is space						
Continue
while (SubStr(Field,1,1) = A_space or SubStr(Field,1,1) = A_Tab)
StringTrimLeft, Field, Field, 1
if (SubStr(Field, 1, 1) = ";")			
Continue
While (SubStr(Field,0,1) = A_space or SubStr(Field,0,1) = A_Tab or SubStr(Field,0,1) = "`r")
StringTrimRight, Field, Field, 1
EqualPos := InStr(Field, "=")			
if (EqualPos = 0)						
Continue
var := SubStr(Field, 1, EqualPos-1)		
StringReplace, var, var, %A_Space%, ,all
StringReplace, var, var, %A_Tab%, ,all
if var is space
Continue
val := SubStr(Field, EqualPos+1)		
while (SubStr(val,1,1) = A_space or SubStr(val,1,1) = A_Tab)
StringTrimLeft, val, val, 1
if val is space
val =
%var% := val							
}
if (SkinOverride != "")
{
Loop, Parse, SkinOverride, %A_Space%
{
Field := A_LoopField
DotPos := InStr(Field, ".")
if (DotPos = 0)						
Continue
var := SubStr(Field, 1, DotPos-1)		
val := SubStr(Field, DotPos+1)		
%var% := val
}
}
RM2_Default(ItemBackShrink,1), RM2_Default(ItemForeShrink,1), RM2_Default(ItemShadowShrink,1), RM2_Default(MenuBackOuterRimTrans,1)
RM2_Default(AutoSubmenuMark, "**")
ItemLayoutPerRing := RM2_RefineItemLayoutPerRing(ItemLayoutPerRing)
StringSplit, v, ItemLayoutPerRing, .
MaxItemsPerMenu := v1 + v2 + v3 + v4, RM2_Reg("MaxItemsPerMenu",MaxItemsPerMenu)
RefineMatrixList = IconTrans ItemBackTrans ItemForeTrans ItemShadowTrans MenuBackTrans MenuBackOuterRimTrans MenuForeTrans
Loop, parse, RefineMatrixList, %A_space%
RM2_RefineMatrix(%A_LoopField%)	
Loop, parse, SkinAttributes, `,
{
CurValue := %A_LoopField%
RM2_Reg(A_LoopField,CurValue)
}
RM2_Reg("SkinDir", SkinDir), RM2_Reg("SkinOverride", SkinOverride, 1), RM2_Reg("RadiusSizeFactor", RadiusSizeFactor) 
pItemBack := RM2_ResizeBitmap(ItemSize, SkinDir "\" ItemBack)
pItemFore := RM2_ResizeBitmap(ItemSize, SkinDir "\" ItemFore)
pItemShadow := RM2_ResizeBitmap(ItemSize, SkinDir "\" ItemShadow)
RM2_RegBitmaps("pItemBack",pItemBack), RM2_RegBitmaps("pItemFore",pItemFore), RM2_RegBitmaps("pItemShadow",pItemShadow)
if (FileExist(SkinDir "\" MenuBackCenter) != "") {	
MenuBackCenterSize := ItemSize-MenuBackCenterShrink*2
pMenuBackCenter := RM2_ResizeBitmap(MenuBackCenterSize, SkinDir "\" MenuBackCenter)
RM2_RegBitmaps("pMenuBackCenter", pMenuBackCenter), RM2_Reg("MenuBackCenterSize", MenuBackCenterSize)
}
RM2_GetLayout(ItemSize,RadiusSizeFactor,ItemLayoutPerRing,    RadiusRingAll,SizeRingAll,Offsets)
RM2_Reg("RadiusRingAll",RadiusRingAll), RM2_Reg("SizeRingAll",SizeRingAll), RM2_Reg("Offsets",Offsets)
FromSkin := TextBoxShrink "|" TextFont "|" TextSize "|" TextColor "|" TextTrans "|" TextRendering "|" TextShadow "|" TextShadowColor "|" TextShadowTrans "|" TextShadowOffset "|" IconShrink "|" IconTrans "|" ItemBackShrink "|" ItemBackTrans "|" ItemForeShrink "|" ItemForeTrans "|" ItemShadowShrink "|" ItemShadowTrans
RM2_Reg("FromSkin",FromSkin)
pItemGlow := RM2_ResizeBitmap(ItemSize, SkinDir "\" ItemGlow)
ItemGlowHWND := RM2_CreateLayeredWin(ItemGlowGuiNum,pItemGlow)
Gdip_DisposeImage(pItemGlow)
RM2_Reg("ItemGlowHWND", ItemGlowHWND), RM2_Reg("ItemGlowGuiNum", ItemGlowGuiNum)
RM2_Reg("ItemSize", ItemSize), RM2_Reg("ItemGlow", ItemGlow)
RM2_Reg("IsRM2moduleOn", 1)
}
RM2_Off() {
if (RM2_Reg("IsRM2moduleOn") != 1)	
return
Gdip_DisposeImage(RM2_RegBitmaps("pItemBack")), RM2_RegBitmaps("pItemBack", "", 1)
Gdip_DisposeImage(RM2_RegBitmaps("pItemFore")), RM2_RegBitmaps("pItemFore", "", 1)
Gdip_DisposeImage(RM2_RegBitmaps("pItemShadow")), RM2_RegBitmaps("pItemShadow", "", 1)
Gdip_DisposeImage(RM2_RegBitmaps("pMenuBackCenter")), RM2_RegBitmaps("pMenuBackCenter", "", 1)
Loop, 3
{
Gdip_DisposeImage(RM2_RegBitmaps("pMenuBackLayerRing" A_index)), RM2_RegBitmaps("pMenuBackLayerRing" A_index, "", 1)
Gdip_DisposeImage(RM2_RegBitmaps("pMenuForeLayerRing" A_index)), RM2_RegBitmaps("pMenuForeLayerRing" A_index, "", 1)
}
pToken := RM2_Reg("pToken")
if (pToken != "")
Gdip_Shutdown(pToken), RM2_Reg("pToken", "", 1)
RM2_Reg("IsRM2moduleOn", "", 1)
}
RM2_IsGdipStartedUp() {	
pPen := Gdip_CreatePen("0xffffffff", 1)	
if pPen
Gdip_DeletePen(pPen1), ToReturn := 1
return ToReturn
}
RM2_IsRM2moduleOn() {	
return RM2_Reg("IsRM2moduleOn")
}
RM2_DoesExist(GuiNum) {	
if (RM2_Reg("M" GuiNum "#HWND") != "")
return 1
}
RM2_IsMenu(GuiNum) {	
MenusList := RM2_Reg("MenusList")
if GuiNum in %MenusList%
return 1
}
RM2_Delete(GuiNum) {	
if (RM2_DoesExist(GuiNum) = 1) {	
Gui %GuiNum%: Destroy
RM2_Reg("M" GuiNum "#HWND", "", 1)				
RM2_Reg("M" GuiNum "#MenuRadius", "", 1)		
RM2_Reg("M" GuiNum "#LastShowCoords", "", 1)	
if (RM2_IsMenu(GuiNum) = 1) {	
MaxItemsPerMenu := RM2_Reg("MaxItemsPerMenu")
Loop % MaxItemsPerMenu
{
RM2_RegTOI("M" GuiNum "#I" A_Index, "", 1)
RM2_RegTT("M" GuiNum "#I" A_Index, "", 1)
}
if RM2_Reg("M" GuiNum "#IsOneRinger") {
TotalItems := RM2_RegOR("M" GuiNum "#TotalItems")
Loop % TotalItems
RM2_RegOR("M" GuiNum "#I" A_index  "#Offset", "", 1)
RM2_RegOR("M" GuiNum "#RingRadius", "", 1)
RM2_RegOR("M" GuiNum "#TotalItems", "", 1)
RM2_Reg("M" GuiNum "#IsOneRinger", "", 1)
}
RM2_Reg("M" GuiNum "#TotalRings", "", 1)
NewMenusList := RM2_RemoveFromList(RM2_Reg("MenusList"), GuiNum)	
RM2_Reg("MenusList", NewMenusList, 1)
RM2_RegBackup("M" GuiNum "#ItemAttributes", "", 1)
RM2_RegBackup("M" GuiNum "#SpecMenuBack", "", 1)
RM2_RegBackup("M" GuiNum "#SpecMenuFore", "", 1)
RM2_RegBackup("M" GuiNum "#OneRingerAtt", "", 1)
RM2_RegBackup("M" GuiNum "#CentralTextOrImageAtt", "", 1)
}
else if (RM2_IsDock(GuiNum) = 1) {	
RM2_RegD("D" GuiNum "#ChildMenu", "", 1), RM2_RegD("D" GuiNum "#ToolTip", "", 1)
NewDocksList := RM2_RemoveFromList(RM2_Reg("DocksList"), GuiNum)	
RM2_Reg("DocksList", NewDocksList, 1)
RM2_RegBackup("M" GuiNum "#ItemAttributes", "", 1)
RM2_RegBackup("M" GuiNum "#ChildMenu", "", 1)
RM2_RegBackup("M" GuiNum "#Size", "", 1)
}
}
}
RM2_Redraw() { 
if (RM2_Reg("IsRM2moduleOn") != 1) {	
RM2_On(RM2_Reg("SkinDir"), RM2_Reg("SkinOverride"), RM2_Reg("ItemGlowGuiNum"))
TurnItOff := 1
}
else {		
pItemGlow := RM2_ResizeBitmap(RM2_Reg("ItemSize"), RM2_Reg("SkinDir") "\" RM2_Reg("ItemGlow"))
ItemGlowHWND := RM2_CreateLayeredWin(RM2_Reg("ItemGlowGuiNum"), pItemGlow)
Gdip_DisposeImage(pItemGlow)
RM2_Reg("ItemGlowHWND", ItemGlowHWND)
}
MenusList := RM2_Reg("MenusList")	
DocksList := RM2_Reg("DocksList")	
Loop, parse, MenusList, `,
{
GuiNum := A_LoopField
if (DllCall("IsWindowVisible", A_PtrSize ? "Ptr" : "UInt", RM2_Reg("M" GuiNum "#HWND")) = 1)	
ShowMe := 1
LastShowCoords := RM2_Reg("M" GuiNum "#LastShowCoords")	
StringSplit, coord, LastShowCoords, |
ItemAttributes := RM2_RegBackup("M" GuiNum "#ItemAttributes")
SpecMenuBack := RM2_RegBackup("M" GuiNum "#SpecMenuBack")
SpecMenuFore := RM2_RegBackup("M" GuiNum "#SpecMenuFore")
OneRingerAtt := RM2_RegBackup("M" GuiNum "#OneRingerAtt")
CentralTextOrImageAtt := RM2_RegBackup("M" GuiNum "#CentralTextOrImageAtt")
RM2_CreateMenu(GuiNum,ItemAttributes,SpecMenuBack,SpecMenuFore,OneRingerAtt,CentralTextOrImageAtt)	
if (ShowMe = 1)
RM2_Show(GuiNum, coord1, coord2)	
else
RM2_Show(GuiNum, coord1, coord2, 1)	
ShowMe := "", coord1 := "", coord2 := ""
}
Loop, parse, DocksList, `,
{
GuiNum := A_LoopField
if (DllCall("IsWindowVisible", A_PtrSize ? "Ptr" : "UInt", RM2_Reg("M" GuiNum "#HWND")) = 1)	
ShowMe := 1
LastShowCoords := RM2_Reg("M" GuiNum "#LastShowCoords")	
StringSplit, coord, LastShowCoords, |
ItemAttributes := RM2_RegBackup("M" GuiNum "#ItemAttributes")
ChildMenu := RM2_RegBackup("M" GuiNum "#ChildMenu")
Size := RM2_RegBackup("M" GuiNum "#Size")
RM2_CreateDock(GuiNum, ItemAttributes, ChildMenu, Size)	
if (ShowMe = 1)
RM2_Show(GuiNum, coord1, coord2)	
else
RM2_Show(GuiNum, coord1, coord2, 1)	
ShowMe := "", coord1 := "", coord2 := ""
}
if (TurnItOff = 1)
RM2_Off()
}
RM2_CreateMenu(GuiNum,ItemAttributes,SpecMenuBack="",SpecMenuFore="",OneRingerAtt="",CentralTextOrImageAtt=""){
RM2_Delete(GuiNum)	
RM2_RegBackup("M" GuiNum "#ItemAttributes", ItemAttributes, 1)
RM2_RegBackup("M" GuiNum "#SpecMenuBack", SpecMenuBack, 1)
RM2_RegBackup("M" GuiNum "#SpecMenuFore", SpecMenuFore, 1)
RM2_RegBackup("M" GuiNum "#OneRingerAtt", OneRingerAtt, 1)
RM2_RegBackup("M" GuiNum "#CentralTextOrImageAtt", CentralTextOrImageAtt, 1)
MaxItemsPerMenu := RM2_Reg("MaxItemsPerMenu")
Loop, parse, ItemAttributes, |
{
c++
if (c > MaxItemsPerMenu) {
c -= 1
break
}
CurItem := A_LoopField
StringSplit, ia, CurItem, >		
Texts .= ia1 "|"
Icons .= ia2 "|"
Submenus .= ia4 "|"
SpecItemBacks .= ia5 "|"
SpecItemFores .= ia6 "|"
if !(ia1 = "" and ia2 = "")	
{
if !(ia1 = "")	
{
AutoTooltip := ia1
RM2_RegTOI("M" GuiNum "#I" A_Index, ia1)
}
else	
{
SplitPath, ia2,,,,OutNameNoExt
AutoTooltip := OutNameNoExt
RM2_RegTOI("M" GuiNum "#I" A_Index, OutNameNoExt)
}
if ia3	
{
if (ia3 = "ntt")	
CurTooltip := ""
else
{
Transform, ia3, Deref, %ia3%
CurTooltip := ia3
}
}
else	
CurTooltip := AutoTooltip
RM2_RegTT("M" GuiNum "#I" A_Index, CurTooltip, 1)	
}
Loop, 6
ia%A_Index% =
}
TotalItems := c 
ItemLayoutPerRing := RM2_Reg("ItemLayoutPerRing")
Loop, parse, ItemLayoutPerRing, .
{
if (A_Index = 1)
i := A_LoopField
else
i += A_LoopField
if (TotalItems <= i)
{
TotalRings := A_Index
break
}
}		
RM2_Reg("M" GuiNum "#TotalRings", TotalRings)
SizeRingAll := RM2_Reg("SizeRingAll")
StringSplit, v, SizeRingAll, |
LastRingSize := v%TotalRings%
ItemSize := RM2_Reg("ItemSize"), SkinDir := RM2_Reg("SkinDir")
if (OneRingerAtt != "")		
{
pi :=4*Atan(1)
Loop, Parse, OneRingerAtt, %A_Space%
{
Field := A_LoopField
DotPos := InStr(Field, ".")
if (DotPos = 0)	
{
if Field in ntt,gn,rc,pos	
%Field% = 1
}
else				
{
var := SubStr(Field, 1, DotPos-1)
val := SubStr(Field, DotPos+1)
if var in FixedRadius,MinRadius	
%var% := val
}
}	
MinRadius := (MinRadius = "") ? "58" : MinRadius
if FixedRadius =
{
RadiusSizeFactor := RM2_Reg("RadiusSizeFactor")
RingRadius :=  ItemSize/(2*Sin(pi/TotalItems))*RadiusSizeFactor
if (RingRadius < MinRadius)
RingRadius := MinRadius
}
Else
RingRadius := FixedRadius
LastRingSize := Round(RingRadius*2 + ItemSize)
Loop, %TotalItems%	
{		
if A_index = 1	
rad := 90*pi/180
Else
{
deg := deg ? deg+(360/TotalItems): (360/TotalItems)+90
rad := deg*pi/180
}
xOffset := RingRadius*(-1*Cos(rad))-ItemSize/2, yOffset := RingRadius*(-1*Sin(rad))-ItemSize/2
xOffset := Round(xOffset), yOffset := Round(yOffset)
Offsets .= xOffset ":" yOffset "|"
RM2_RegOR("M" GuiNum "#I" A_index  "#Offset", xOffset ":" yOffset)	
}	
RM2_TrimEnd(Offsets)
RM2_RegOR("M" GuiNum "#RingRadius", RingRadius)	
RM2_RegOR("M" GuiNum "#TotalItems", TotalItems)		
RM2_Reg("M" GuiNum "#IsOneRinger", 1)		
}
MenuBack := RM2_Reg("MenuBack"), MenuBackSize := RM2_Reg("MenuBackSize"), MenuBackTrans := RM2_Reg("MenuBackTrans")
MenuBackOuterRim := RM2_Reg("MenuBackOuterRim"), MenuBackOuterRimWidth := RM2_Reg("MenuBackOuterRimWidth")
MenuBackOuterRimTrans := RM2_Reg("MenuBackOuterRimTrans")
IfExist, %SpecMenuBack%	
pMenuBackLayerFinal := RM2_CreateMenuBackLayer(LastRingSize,ItemSize, SkinDir "\" MenuBackOuterRim "|" MenuBackOuterRimTrans "|" MenuBackOuterRimWidth
, SpecMenuBack "|" MenuBackTrans "|" MenuBackSize)
else if (SpecMenuBack = "nb" or SpecMenuBack = "no back")	
pMenuBackLayerFinal =
else if !(OneRingerAtt = "")	
pMenuBackLayerFinal := RM2_CreateMenuBackLayer(LastRingSize,ItemSize, SkinDir "\" MenuBackOuterRim "|" MenuBackOuterRimTrans "|" MenuBackOuterRimWidth
, SkinDir "\" MenuBack "|" MenuBackTrans "|" MenuBackSize)
else	
{
MenuBackForThisRing := RM2_RegBitmaps("pMenuBackLayerRing" TotalRings)
if MenuBackForThisRing	
pMenuBackLayerFinal := RM2_CloneBitmap(MenuBackForThisRing)
else	
{
pMenuBackLayer := RM2_CreateMenuBackLayer(LastRingSize,ItemSize, SkinDir "\" MenuBackOuterRim "|" MenuBackOuterRimTrans "|" MenuBackOuterRimWidth
, SkinDir "\" MenuBack "|" MenuBackTrans "|" MenuBackSize)
RM2_RegBitmaps("pMenuBackLayerRing" TotalRings, pMenuBackLayer)
pMenuBackLayerFinal := RM2_CloneBitmap(pMenuBackLayer)
}
}
pItemBack := RM2_RegBitmaps("pItemBack"), pItemFore := RM2_RegBitmaps("pItemFore"), pItemShadow := RM2_RegBitmaps("pItemShadow")
AutoSubmenuMarking := RM2_Reg("AutoSubmenuMarking"), FromSkin := RM2_Reg("FromSkin")
RM2_TrimEnd(Texts), RM2_TrimEnd(Icons), RM2_TrimEnd(SpecItemBacks), RM2_TrimEnd(SpecItemFores), RM2_TrimEnd(Submenus)
if !(OneRingerAtt = "")	
{
pBackAndItemsLayer := RM2_CreateBackAndItemsLayerOR(pMenuBackLayerFinal, pItemBack,pItemFore,pItemShadow,Offsets,ItemSize,LastRingSize,AutoSubmenuMarking
,FromSkin,Texts,Icons,SpecItemBacks,SpecItemFores,Submenus,CentralTextOrImageAtt)
}
else	
{
Offsets := RM2_Reg("Offsets")
pBackAndItemsLayer := RM2_CreateBackAndItemsLayer(pMenuBackLayerFinal, pItemBack,pItemFore,pItemShadow,Offsets,ItemSize,SizeRingAll,ItemLayoutPerRing,AutoSubmenuMarking
,FromSkin,Texts,Icons,SpecItemBacks,SpecItemFores,Submenus,CentralTextOrImageAtt)
}
MenuFore := RM2_Reg("MenuFore"), MenuForeSize := RM2_Reg("MenuForeSize"), MenuForeTrans := RM2_Reg("MenuForeTrans")
if (SpecMenuFore = "nf" or SpecMenuFore = "no fore")	
pMenuForeLayerFinal =
else if !(OneRingerAtt = "")	
{
MenuForeSize := (MenuForeSize = "") ? "Add+0" : MenuForeSize
pMenuForeLayerFinal := RM2_CreateMenuForeLayer(LastRingSize,ItemSize, SkinDir "\" MenuFore "|" MenuForeTrans "|" MenuForeSize)
}
else	
{
MenuForeForThisRing := RM2_RegBitmaps("pMenuForeLayerRing" TotalRings)
if MenuForeForThisRing	
pMenuForeLayerFinal := RM2_CloneBitmap(MenuForeForThisRing)
else	
{
pMenuForeLayer := RM2_CreateMenuForeLayer(LastRingSize,ItemSize, SkinDir "\" MenuFore "|" MenuForeTrans "|" MenuForeSize)
RM2_RegBitmaps("pMenuForeLayerRing" TotalRings, pMenuForeLayer)
pMenuForeLayerFinal := RM2_CloneBitmap(pMenuForeLayer)			
}
}
if !(SpecMenuFore = "nf" or SpecMenuFore = "no fore")	
{
IfExist, %SpecMenuFore%
{
if pMenuForeLayerFinal	
{
Gspec := Gdip_GraphicsFromImage(pMenuForeLayerFinal)
pSpecMenuFore := Gdip_CreateBitmapFromFile(SpecMenuFore)
Gdip_DrawImage(Gspec, pSpecMenuFore, 1, 1, Gdip_GetImageWidth(pMenuForeLayerFinal)-1, Gdip_GetImageHeight(pMenuForeLayerFinal)-1)
Gdip_DisposeImage(pSpecMenuFore)
Gdip_DeleteGraphics(Gspec)
}
else	
{
MenuForeSize := (MenuForeSize = "") ? "Add+0" : MenuForeSize
pMenuForeLayerFinal := RM2_CreateMenuForeLayer(LastRingSize,ItemSize, SpecMenuFore "|1|" MenuForeSize)
}
}
}
pMenu := RM2_MergeMenuLayers(pBackAndItemsLayer,pMenuForeLayerFinal,    MenuRadius)	
Gdip_DisposeImage(pMenuBackLayerFinal), Gdip_DisposeImage(pBackAndItemsLayer), Gdip_DisposeImage(pMenuForeLayerFinal)		
MenuHWND := RM2_CreateLayeredWin(GuiNum, pMenu)	
Gdip_DisposeImage(pMenu)	
RM2_Reg("M" GuiNum "#" "HWND", MenuHWND)	
RM2_Reg("M" GuiNum "#" "MenuRadius", MenuRadius)	
MenusList := RM2_Reg("MenusList")
MenusList := (MenusList = "") ? GuiNum : MenusList "," GuiNum	
RM2_Reg("MenusList", MenusList)	
Return GuiNum
}
RM2_Show(GuiNum, x="", y="", Hide=0) {
if (RM2_DoesExist(GuiNum) != 1)
return
CoordMode, mouse, screen
if (x = "") 
MouseGetPos, x,y
else if (x = "Center" or x = "c")
x := A_ScreenWidth/2, y := A_ScreenHeight/2
if (RM2_Reg("ItemGlowGuiNum") = GuiNum)
MenuRadius := RM2_Reg("ItemSize")/2
else
MenuRadius := RM2_Reg("M" GuiNum "#" "MenuRadius")
x := Round(x), y := Round(y)
MenuX := Round(x - MenuRadius), MenuY := Round(y - MenuRadius)
if (Hide = 1)
Gui %GuiNum%:Show, x%MenuX% y%MenuY% Hide
else	
Gui %GuiNum%:Show, x%MenuX% y%MenuY% NA
RM2_Reg("M" GuiNum "#LastShowCoords", x "|" y)	
}
RM2_ShowAsSubmenu(ChildGuiNum, ParentGuiNum, ParentItemNumber) {
if (RM2_IsMenu(ChildGuiNum) != 1)
return
if (RM2_IsMenu(ParentGuiNum) != 1)
return
ParentMenuHWND := RM2_Reg("M" ParentGuiNum "#" "HWND")
ParentMenuRadius := RM2_Reg("M" ParentGuiNum "#" "MenuRadius")
ItemSize := RM2_Reg("ItemSize")
oldDHW := A_DetectHiddenWindows 
DetectHiddenWindows, on
WinGetPos, ParentMenuX, ParentMenuY,,, ahk_id %ParentMenuHWND%
IsOneRinger := RM2_Reg("M" ParentGuiNum "#IsOneRinger")
if IsOneRinger
CurOffset := RM2_RegOR("M" ParentGuiNum "#I" ParentItemNumber "#Offset")
else
CurOffset := RM2_Reg("Offset" ParentItemNumber)
StringSplit, co, CurOffset, :
ChildMenuX := ParentMenuX+ParentMenuRadius+co1+ItemSize/2, ChildMenuY := ParentMenuY+ParentMenuRadius+co2+ItemSize/2
RM2_Show(ChildGuiNum, ChildMenuX, ChildMenuY)
DetectHiddenWindows, %oldDHW%
}
RM2_Hide(GuiNum){
Gui %GuiNum%: hide
}
RM2_GetSelectedItem(GuiNum, SelectMethod="", key="", options="", StartX="", StartY="") {
Thread, NoTimers	
if (RM2_DoesExist(GuiNum) != 1)	
return
CoordMode, mouse, screen
if (StartX = "") {
LastShowCoords := RM2_Reg("M" GuiNum "#LastShowCoords")
StringSplit, lsc, LastShowCoords, |
StartX := lsc1, StartY := lsc2
}
else if (StartX = "Center" or StartX = "c")
StartX := A_ScreenWidth/2, StartY := A_ScreenHeight/2
if (options != "") {
Loop, Parse, options, %A_Space%
{
Field := A_LoopField
DotPos := InStr(Field, ".")
if (DotPos = 0) {	
if Field in ntt,gn,rc,pos	
%Field% := 1
}
else {				
var := SubStr(Field, 1, DotPos-1)
val := SubStr(Field, DotPos+1)
if var in bc,bs,iicr,foh	
%var% := val
}
}	
}
ItemGlowGuiNum := RM2_Reg("ItemGlowGuiNum"), ItemGlowHWND := RM2_Reg("ItemGlowHWND")
ItemSize := RM2_Reg("ItemSize"), IsOneRinger := RM2_Reg("M" GuiNum "#IsOneRinger")
if (foh != "") {		
StringSplit, v, foh, .
foh := v1, param1 := v2, param2 := v3
}
if (key = "") {
if (SelectMethod = "c")
key := "LButton"
else
key := RegExReplace(A_ThisHotkey, (A_IsUnicode = 1) ? "(*UCP)^(\w* & |\W*)" : "^(\w* & |\W*)")	
}
if (SelectMethod = "c") {	
KeyWait, %key%
state := 0
}
else 
state := 1
While, (GetKeyState(key,"p") = state) {
Sleep, 20
MouseGetPos, EndX, EndY
if IsOneRinger 
SelectedItemNumber := RM2_GetSelectedItemNumberOR(StartX, StartY, EndX, EndY, GuiNum)
else
SelectedItemNumber := RM2_GetSelectedItemNumber(StartX, StartY, EndX, EndY, GuiNum)
if !(RM2_RegTOI("M" GuiNum "#" "I" SelectedItemNumber))	
{
SelectedItem := "", LastItemUM := ""
RM2_ToolTipFM()
Gui %ItemGlowGuiNum%: hide
}
else 
{
SelectedItem := SelectedItemNumber
if !(ntt = 1)	
{
CurTT := RM2_RegTT("M" GuiNum "#I" SelectedItem)
if (CurTT = "")
RM2_ToolTipFM()
else
RM2_ToolTipFM(CurTT)
}
if (SelectedItem = LastItemUM)	
continue
if IsOneRinger
CurOffset := RM2_RegOR("M" GuiNum "#I" SelectedItem  "#Offset")
else
CurOffset := RM2_Reg("Offset" SelectedItem)
StringSplit, co, CurOffset, :
CurItemGlowX := Round(StartX+co1), CurItemGlowY := Round(StartY+co2)
if foh
%foh%(param1,param2)
Gui %ItemGlowGuiNum%:Show, x%CurItemGlowX% y%CurItemGlowY% NA
LastItemUM := SelectedItem
}
}
RM2_ToolTipFM()
if (SelectedItem = "")	
{
if (iicr != "") {	
RadiusSizeFactor := RM2_Reg("RadiusSizeFactor")
IsInCircle := RM2_IsInCircle(StartX, StartY, EndX, EndY, (ItemSize*RadiusSizeFactor)/2)
if IsInCircle
{
Gui %ItemGlowGuiNum%: hide
return iicr	
}
}
Gui %ItemGlowGuiNum%: hide
return
}
else	
{
if (bc = "" or bs = "")	
Gui %ItemGlowGuiNum%:hide
else
RM2_ItemGlowBlink(ItemGlowGuiNum,bc,bs)
if rc
MouseMove, %StartX%, %StartY%
if !pos	
SelectedItem := RM2_RegTOI("M" GuiNum "#I" SelectedItem)
if gn
SelectedItem .= "|" GuiNum
}
return SelectedItem
}
RM2_Handler(GuiNum, SelectMethod="", key="", options="",ShowPosX="", ShowPosY="") {
if (RM2_DoesExist(GuiNum) != 1)	
return
if (ShowPosX = "" or ShowPosX = "c" or ShowPosX = "Center")
ShowPosY := ""
RM2_Show(GuiNum, ShowPosX, ShowPosY)
SelectedItem := RM2_GetSelectedItem(GuiNum, SelectMethod,key,options), RM2_Hide(GuiNum)
return SelectedItem
}
RM2_ItemGlowBlink(ItemGlowGuiNum, Count=1, Sleep=90) {
Loop, %Count%
{
Gui %ItemGlowGuiNum%: hide
Sleep, %Sleep%
Gui %ItemGlowGuiNum%:Show, NA
Sleep, %Sleep%
}
Gui %ItemGlowGuiNum%:hide
}
RM2_CreateBackAndItemsLayer(pMenuBackLayer, pItemBack,pItemFore,pItemShadow,Offsets,ItemSize,SizeRingAll,ItemLayoutPerRing,AutoSubmenuMarking,  FromSkin,  Texts,Icons,SpecItemBacks,SpecItemFores,Submenus,CentralTextOrImageAtt="")
{
static FromSkinOrder := "TextBoxShrink|TextFont|TextSize|TextColor|TextTrans|TextRendering|TextShadow|TextShadowColor|TextShadowTrans|TextShadowOffset|IconShrink|IconTrans|ItemBackShrink|ItemBackTrans|ItemForeShrink|ItemForeTrans|ItemShadowShrink|ItemShadowTrans"
If (Texts = "" and Icons = "")
return
StringSplit, Offset, Offsets, |					
StringSplit, SizeRing, SizeRingAll, |			
StringSplit, TotalItemsRing, ItemLayoutPerRing, .		
StringSplit, value, FromSkin, |				
Loop, Parse, FromSkinOrder, |
%A_LoopField% :=  value%A_Index%			
StringSplit, Text, Texts, |					
StringSplit, Icon, Icons, |					
StringSplit, SpecItemBack, SpecItemBacks, |
StringSplit, SpecItemFore, SpecItemFores, |
StringSplit, Submenu, Submenus, |
StringSplit, ctoi, CentralTextOrImageAtt, >
CentralText := ctoi1, CentralImage := ctoi2, CentralImageSizeFactor := ctoi3
TotalItemsRingAll := TotalItemsRing1 + TotalItemsRing2 + TotalItemsRing3 + TotalItemsRing4
TotalItems :=  (Text0 >= Icon0) ? Text0 : Icon0		
if (TotalItems > TotalItemsRingAll)
TotalItems := TotalItemsRingAll
if (TotalItems <= TotalItemsRing1)
TotalRings = 1
Else if (TotalItems <= TotalItemsRing1 + TotalItemsRing2)
TotalRings = 2
Else if (TotalItems <= TotalItemsRing1 + TotalItemsRing2 + TotalItemsRing3)
TotalRings = 3
Else if (TotalItems <= TotalItemsRing1 + TotalItemsRing2 + TotalItemsRing3 + TotalItemsRing4)
TotalRings = 4
LayerSize := SizeRing%TotalRings%	
ShadowWidth := Gdip_GetImageWidth(pItemShadow), ShadowHeight := Gdip_GetImageHeight(pItemShadow)
LayerSize += ShadowHeight	
BackLayerSize := Gdip_GetImageWidth(pMenuBackLayer)
if (BackLayerSize > LayerSize)
LayerSize := BackLayerSize, BackLayerX := BackLayerY := 0
else
BackLayerX := BackLayerY := (LayerSize- BackLayerSize)/2
pLayer := Gdip_CreateBitmap(LayerSize, LayerSize), G := Gdip_GraphicsFromImage(pLayer)	
Gdip_DrawImage(G, pMenuBackLayer, BackLayerX, BackLayerX, BackLayerSize, BackLayerSize)	
CenterX := CenterY := Round(LayerSize/2)
ItemShadowShrink := ItemSize-ItemShadowShrink*ItemSize
ItemBackShrink := ItemSize-ItemBackShrink*ItemSize	
ItemForeShrink := ItemSize-ItemForeShrink*ItemSize
TextBoxShrink := ItemSize-TextBoxShrink*ItemSize
TextW := ItemSize-TextBoxShrink*2, TextH := ItemSize-TextBoxShrink*2
IconShrink := ItemSize-IconShrink*ItemSize
if AutoSubmenuMarking
AutoSubmenuMarking := ItemSize-AutoSubmenuMarking*ItemSize
Gdip_FontFamilyCreate(TextFont)
ItemBackHatchStyle := RM2_Reg("ItemBackHatchStyle")
ItemBackHatchFrontColor := RM2_Reg("ItemBackHatchFrontColor")
ItemBackHatchBackColor := RM2_Reg("ItemBackHatchBackColor")
ItemBackHatchShrink := RM2_Reg("ItemBackHatchShrink")
Loop, %TotalItems%
{
StringSplit, off, offset%A_Index%, :
x := CenterX + off1, y := CenterY + off2
if (Text%A_index% = "" and Icon%A_index% = "")	
Continue
Gdip_DrawImage(G, pItemShadow, x+ItemShadowShrink, y+ItemSize-ShadowHeight/2
, ItemSize-ItemShadowShrink*2, ShadowHeight,"","","","",ItemShadowTrans)
CurrentSpecItemBack := SpecItemBack%A_index%
if CurrentSpecItemBack
{
if !(CurrentSpecItemBack = "nb" or CurrentSpecItemBack = "no back") {	
pCurrentSpecItemBack := Gdip_CreateBitmapFromFile(CurrentSpecItemBack)
Gdip_DrawImage(G, pCurrentSpecItemBack, x+ItemBackShrink, y+ItemBackShrink, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2)
Gdip_DisposeImage(pCurrentSpecItemBack)
if (ItemBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" ItemBackHatchFrontColor, "0x" ItemBackHatchBackColor, ItemBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, x+ItemBackShrink+ItemBackHatchShrink, y+ItemBackShrink+ItemBackHatchShrink
, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}
}
}
Else {
Gdip_DrawImage(G, pItemBack, x+ItemBackShrink, y+ItemBackShrink, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2,"","","","",ItemBackTrans)
if (ItemBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" ItemBackHatchFrontColor, "0x" ItemBackHatchBackColor, ItemBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, x+ItemBackShrink+ItemBackHatchShrink, y+ItemBackShrink+ItemBackHatchShrink
, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}
}
CurrentIcon := Icon%A_index%
pCurrentIcon := Gdip_CreateBitmapFromFile(CurrentIcon)
Gdip_DrawImage(G, pCurrentIcon, x+IconShrink, y+IconShrink
, ItemSize-IconShrink*2, ItemSize-IconShrink*2,"","","","",IconTrans)
Gdip_DisposeImage(pCurrentIcon)
TextX := x+TextBoxShrink, TextY := y+TextBoxShrink
if TextShadow
{
ShadowX := TextX + TextShadowOffset, ShadowY := TextY + TextShadowOffset
Options = x%ShadowX% y%ShadowY% Center Vcenter c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, Text%A_index%, Options, TextFont,TextW, TextH )  
}
Options = x%TextX% y%TextY% Center Vcenter c%TextTrans%%TextColor% r%TextRendering% s%TextSize% 
Gdip_TextToGraphics(G, Text%A_index%, Options, TextFont,TextW, TextH )  
CurrentSubmenu := Submenu%A_index%
if CurrentSubmenu
{
if AutoSubmenuMarking
{
SubMarkX := x, SubMarkY := y+AutoSubmenuMarking
if TextShadow
{
SubMarkXShadow := SubMarkX + TextShadowOffset, SubMarkYShadow := SubMarkY + TextShadowOffset
Options = x%SubMarkXShadow% y%SubMarkYShadow% Center c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize, ItemSize-AutoSubmenuMarking*2 )  
}
Options = x%SubMarkX% y%SubMarkY% Center c%TextTrans%%TextColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize,ItemSize-AutoSubmenuMarking*2)
}
}
CurrentSpecItemFore := SpecItemFore%A_index%
if !(CurrentSpecItemFore = "nf" or CurrentSpecItemFore = "no fore")	
{
Gdip_DrawImage(G, pItemFore, x+ItemForeShrink, y+ItemForeShrink	
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2,"","","","",ItemForeTrans)
if CurrentSpecItemFore	
{
pCurrentSpecItemFore := Gdip_CreateBitmapFromFile(CurrentSpecItemFore)
Gdip_DrawImage(G, pCurrentSpecItemFore, x+ItemForeShrink, y+ItemForeShrink
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2)
Gdip_DisposeImage(pCurrentSpecItemFore)
}
}
}
if FileExist(CentralImage)
{
pCentralImage := Gdip_CreateBitmapFromFile(CentralImage)
if CentralImageSizeFactor
{
CentralImageSize := ItemSize*CentralImageSizeFactor
Gdip_DrawImage(G, pCentralImage, CenterX - CentralImageSize/2, CenterY - CentralImageSize/2
, CentralImageSize, CentralImageSize)
}
else
{
Gdip_DrawImage(G, pCentralImage, CenterX - ItemSize/2+IconShrink, CenterY - ItemSize/2+IconShrink
, ItemSize-IconShrink*2, ItemSize-IconShrink*2,"","","","",IconTrans)
}
Gdip_DisposeImage(pCentralImage)
}
if !(CentralText = "")
{
TextX := CenterX - ItemSize/2+TextBoxShrink, TextY := CenterX - ItemSize/2+TextBoxShrink
if TextShadow
{
ShadowX := TextX + TextShadowOffset, ShadowY := TextY + TextShadowOffset
Options = x%ShadowX% y%ShadowY% Center Vcenter c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, CentralText, Options, TextFont,TextW, TextH )  
}
Options = x%TextX% y%TextY% Center Vcenter c%TextTrans%%TextColor% r%TextRendering% s%TextSize% 
Gdip_TextToGraphics(G, CentralText, Options, TextFont,TextW, TextH )  
}
Gdip_DeleteGraphics(G)
Return pLayer
}
RM2_CreateBackAndItemsLayerOR(pMenuBackLayer, pItemBack,pItemFore,pItemShadow,Offsets,ItemSize,LayerSize,AutoSubmenuMarking,  FromSkin,  Texts,Icons,SpecItemBacks,SpecItemFores,Submenus,CentralTextOrImageAtt="") {
static FromSkinOrder := "TextBoxShrink|TextFont|TextSize|TextColor|TextTrans|TextRendering|TextShadow|TextShadowColor|TextShadowTrans|TextShadowOffset|IconShrink|IconTrans|ItemBackShrink|ItemBackTrans|ItemForeShrink|ItemForeTrans|ItemShadowShrink|ItemShadowTrans"
If (Texts = "" and Icons = "")
return
StringSplit, Offset, Offsets, |					
StringSplit, value, FromSkin, |				
Loop, Parse, FromSkinOrder, |
%A_LoopField% :=  value%A_Index%			
StringSplit, Text, Texts, |					
StringSplit, Icon, Icons, |					
StringSplit, SpecItemBack, SpecItemBacks, |
StringSplit, SpecItemFore, SpecItemFores, |
StringSplit, Submenu, Submenus, |
StringSplit, ctoi, CentralTextOrImageAtt, >
CentralText := ctoi1, CentralImage := ctoi2, CentralImageSizeFactor := ctoi3
TotalItems :=  (Text0 >= Icon0) ? Text0 : Icon0		
ShadowWidth := Gdip_GetImageWidth(pItemShadow), ShadowHeight := Gdip_GetImageHeight(pItemShadow)
LayerSize += ShadowHeight	
BackLayerSize := Gdip_GetImageWidth(pMenuBackLayer)
if (BackLayerSize > LayerSize)
LayerSize := BackLayerSize, BackLayerX := BackLayerY := 0
else
BackLayerX := BackLayerY := (LayerSize- BackLayerSize)/2
pLayer := Gdip_CreateBitmap(LayerSize, LayerSize), G := Gdip_GraphicsFromImage(pLayer)	
Gdip_DrawImage(G, pMenuBackLayer, BackLayerX, BackLayerX, BackLayerSize, BackLayerSize)	
CenterX := CenterY := Round(LayerSize/2)
ItemShadowShrink := ItemSize-ItemShadowShrink*ItemSize
ItemBackShrink := ItemSize-ItemBackShrink*ItemSize	
ItemForeShrink := ItemSize-ItemForeShrink*ItemSize
TextBoxShrink := ItemSize-TextBoxShrink*ItemSize
TextW := ItemSize-TextBoxShrink*2, TextH := ItemSize-TextBoxShrink*2
IconShrink := ItemSize-IconShrink*ItemSize
if AutoSubmenuMarking
AutoSubmenuMarking := ItemSize-AutoSubmenuMarking*ItemSize
Gdip_FontFamilyCreate(TextFont)
ItemBackHatchStyle := RM2_Reg("ItemBackHatchStyle")
ItemBackHatchFrontColor := RM2_Reg("ItemBackHatchFrontColor")
ItemBackHatchBackColor := RM2_Reg("ItemBackHatchBackColor")
ItemBackHatchShrink := RM2_Reg("ItemBackHatchShrink")
Loop, %TotalItems%
{
StringSplit, off, offset%A_Index%, :
x := CenterX + off1, y := CenterY + off2
if (Text%A_index% = "" and Icon%A_index% = "")	
Continue
Gdip_DrawImage(G, pItemShadow, x+ItemShadowShrink, y+ItemSize-ShadowHeight/2
, ItemSize-ItemShadowShrink*2, ShadowHeight,"","","","",ItemShadowTrans)
CurrentSpecItemBack := SpecItemBack%A_index%
if CurrentSpecItemBack
{
if !(CurrentSpecItemBack = "nb" or CurrentSpecItemBack = "no back") {	
pCurrentSpecItemBack := Gdip_CreateBitmapFromFile(CurrentSpecItemBack)
Gdip_DrawImage(G, pCurrentSpecItemBack, x+ItemBackShrink, y+ItemBackShrink, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2)
Gdip_DisposeImage(pCurrentSpecItemBack)
if (ItemBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" ItemBackHatchFrontColor, "0x" ItemBackHatchBackColor, ItemBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, x+ItemBackShrink+ItemBackHatchShrink, y+ItemBackShrink+ItemBackHatchShrink
, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}
}
}
Else {
Gdip_DrawImage(G, pItemBack, x+ItemBackShrink, y+ItemBackShrink, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2,"","","","",ItemBackTrans)
if (ItemBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" ItemBackHatchFrontColor, "0x" ItemBackHatchBackColor, ItemBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, x+ItemBackShrink+ItemBackHatchShrink, y+ItemBackShrink+ItemBackHatchShrink
, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2, ItemSize-ItemBackShrink*2-ItemBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}
}
CurrentIcon := Icon%A_index%
pCurrentIcon := Gdip_CreateBitmapFromFile(CurrentIcon)
Gdip_DrawImage(G, pCurrentIcon, x+IconShrink, y+IconShrink
, ItemSize-IconShrink*2, ItemSize-IconShrink*2,"","","","",IconTrans)
Gdip_DisposeImage(pCurrentIcon)
TextX := x+TextBoxShrink, TextY := y+TextBoxShrink
if TextShadow
{
ShadowX := TextX + TextShadowOffset, ShadowY := TextY + TextShadowOffset
Options = x%ShadowX% y%ShadowY% Center Vcenter c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, Text%A_index%, Options, TextFont,TextW, TextH )  
}
Options = x%TextX% y%TextY% Center Vcenter c%TextTrans%%TextColor% r%TextRendering% s%TextSize% 
Gdip_TextToGraphics(G, Text%A_index%, Options, TextFont,TextW, TextH )  
CurrentSubmenu := Submenu%A_index%
if CurrentSubmenu
{
if AutoSubmenuMarking
{
SubMarkX := x, SubMarkY := y+AutoSubmenuMarking
if TextShadow
{
SubMarkXShadow := SubMarkX + TextShadowOffset, SubMarkYShadow := SubMarkY + TextShadowOffset
Options = x%SubMarkXShadow% y%SubMarkYShadow% Center c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize, ItemSize-AutoSubmenuMarking*2 )  
}
Options = x%SubMarkX% y%SubMarkY% Center c%TextTrans%%TextColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize,ItemSize-AutoSubmenuMarking*2)
}
}
CurrentSpecItemFore := SpecItemFore%A_index%
if !(CurrentSpecItemFore = "nf" or CurrentSpecItemFore = "no fore")	
{
Gdip_DrawImage(G, pItemFore, x+ItemForeShrink, y+ItemForeShrink	
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2,"","","","",ItemForeTrans)
if CurrentSpecItemFore	
{
pCurrentSpecItemFore := Gdip_CreateBitmapFromFile(CurrentSpecItemFore)
Gdip_DrawImage(G, pCurrentSpecItemFore, x+ItemForeShrink, y+ItemForeShrink
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2)
Gdip_DisposeImage(pCurrentSpecItemFore)
}
}
}
if FileExist(CentralImage)
{
pCentralImage := Gdip_CreateBitmapFromFile(CentralImage)
if CentralImageSizeFactor
{
CentralImageSize := ItemSize*CentralImageSizeFactor
Gdip_DrawImage(G, pCentralImage, CenterX - CentralImageSize/2, CenterY - CentralImageSize/2
, CentralImageSize, CentralImageSize)
}
else
{
Gdip_DrawImage(G, pCentralImage, CenterX - ItemSize/2+IconShrink, CenterY - ItemSize/2+IconShrink
, ItemSize-IconShrink*2, ItemSize-IconShrink*2,"","","","",IconTrans)
}
Gdip_DisposeImage(pCentralImage)
}
if !(CentralText = "")
{
TextX := CenterX - ItemSize/2+TextBoxShrink, TextY := CenterX - ItemSize/2+TextBoxShrink
if TextShadow
{
ShadowX := TextX + TextShadowOffset, ShadowY := TextY + TextShadowOffset
Options = x%ShadowX% y%ShadowY% Center Vcenter c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%	
Gdip_TextToGraphics(G, CentralText, Options, TextFont,TextW, TextH )  
}
Options = x%TextX% y%TextY% Center Vcenter c%TextTrans%%TextColor% r%TextRendering% s%TextSize% 
Gdip_TextToGraphics(G, CentralText, Options, TextFont,TextW, TextH )  
}
Gdip_DeleteGraphics(G)
Return pLayer
}
RM2_CreateMenuForeLayer(LayerBaseSize,ItemSize,ForegroundAtt) {		
static ForegroundOrder := "ForeFile|ForeTrans|ForeSize"
if ForegroundAtt =
return
StringSplit, value, ForegroundAtt, |
Loop, Parse, ForegroundOrder, |
%A_LoopField% :=  value%A_Index%
if (SubStr(ForeSize,1,3) = "Add")	
{
StringTrimLeft, ForeSize, ForeSize,3
Operator := (SubStr(ForeSize,1,1) = "-") ? "minus" : "plus"
StringTrimLeft, ForeSize, ForeSize,1
if Operator = minus
Size := LayerBaseSize-ForeSize
Else if Operator = plus
Size := LayerBaseSize+ForeSize
}
else if (SubStr(ForeSize,1,3) = "Fac")	
{
StringTrimLeft, ForeSize, ForeSize,3
Operator := (SubStr(ForeSize,1,1) = "-") ? "minus" : "plus"
StringTrimLeft, ForeSize, ForeSize,1
if Operator = minus
Size := LayerBaseSize-ItemSize*ForeSize*2
Else if Operator = plus
Size := LayerBaseSize+ItemSize*ForeSize*2
}
Else
Return	
pLayer := Gdip_CreateBitmap(Size, Size), G := Gdip_GraphicsFromImage(pLayer)
pFore := Gdip_CreateBitmapFromFile(ForeFile)
Gdip_DrawImage(G, pFore, 0, 0, Size, Size, "", "", "", "",ForeTrans)
Gdip_DisposeImage(pFore)
Gdip_DeleteGraphics(G)
Return pLayer
}
RM2_CreateMenuBackLayer(LayerBaseSize,ItemSize, OuterRimAtt, BackgroundAtt) {		
static OuterRimOrder := "OuterRimFile|OuterRimTrans|OuterRimWidth"
static BackgroundOrder := "BackFile|BackTrans|BackSize"
if (BackgroundAtt = "" and OuterRimAtt = "")
return
StringSplit, value, BackgroundAtt, |
Loop, Parse, BackgroundOrder, |
%A_LoopField% :=  value%A_Index%
StringSplit, value, OuterRimAtt, |
Loop, Parse, OuterRimOrder, |
%A_LoopField% :=  value%A_Index%
if (SubStr(BackSize,1,3) = "Add")	
{
StringTrimLeft, BackSize, BackSize,3
Operator := (SubStr(BackSize,1,1) = "-") ? "minus" : "plus"
StringTrimLeft, BackSize, BackSize,1
if Operator = minus
Size := LayerBaseSize-BackSize
Else if Operator = plus
Size := LayerBaseSize+BackSize
}
else if (SubStr(BackSize,1,3) = "Fac")	
{
StringTrimLeft, BackSize, BackSize,3
Operator := (SubStr(BackSize,1,1) = "-") ? "minus" : "plus"
StringTrimLeft, BackSize, BackSize,1
if Operator = minus
Size := LayerBaseSize-ItemSize*BackSize*2
Else if Operator = plus
Size := LayerBaseSize+ItemSize*BackSize*2
}
Else
Return	
pLayer := Gdip_CreateBitmap(Size, Size), G := Gdip_GraphicsFromImage(pLayer)
pBack := Gdip_CreateBitmapFromFile(BackFile)
MenuBackHatchStyle := RM2_Reg("MenuBackHatchStyle")
MenuBackHatchFrontColor := RM2_Reg("MenuBackHatchFrontColor")
MenuBackHatchBackColor := RM2_Reg("MenuBackHatchBackColor")
MenuBackHatchShrink := RM2_Reg("MenuBackHatchShrink")
MenuBackOuterRimHatchStyle := RM2_Reg("MenuBackOuterRimHatchStyle")
MenuBackOuterRimHatchFrontColor := RM2_Reg("MenuBackOuterRimHatchFrontColor")
MenuBackOuterRimHatchBackColor := RM2_Reg("MenuBackOuterRimHatchBackColor")
MenuBackOuterRimHatchShrink := RM2_Reg("MenuBackOuterRimHatchShrink")
if (OuterRimWidth > 0) {	
pRim := Gdip_CreateBitmapFromFile(OuterRimFile)
Gdip_DrawImage(G, pRim, 0, 0, Size, Size, "", "", "", "",OuterRimTrans)
Gdip_DisposeImage(pRim)
if (MenuBackOuterRimHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" MenuBackOuterRimHatchFrontColor, "0x" MenuBackOuterRimHatchBackColor, MenuBackOuterRimHatchStyle)	
Gdip_FillEllipse(G, pBrush, MenuBackOuterRimHatchShrink, MenuBackOuterRimHatchShrink
, Size-MenuBackOuterRimHatchShrink*2, Size-MenuBackOuterRimHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}	
Gdip_DrawImage(G, pBack, OuterRimWidth, OuterRimWidth, Size-OuterRimWidth*2 , Size-OuterRimWidth*2, "", "", "", "",BackTrans)
if (MenuBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" MenuBackHatchFrontColor, "0x" MenuBackHatchBackColor, MenuBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, OuterRimWidth+MenuBackHatchShrink, OuterRimWidth+MenuBackHatchShrink
, Size-OuterRimWidth*2-MenuBackHatchShrink*2, Size-OuterRimWidth*2-MenuBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}
}
Else {			
Gdip_DrawImage(G, pBack, 0, 0, Size, Size, "", "", "", "",BackTrans)
if (MenuBackHatchStyle != "") {
pBrush := Gdip_BrushCreateHatch("0x" MenuBackHatchFrontColor, "0x" MenuBackHatchBackColor, MenuBackHatchStyle)	
Gdip_FillEllipse(G, pBrush, MenuBackHatchShrink, MenuBackHatchShrink, Size-MenuBackHatchShrink*2, Size-MenuBackHatchShrink*2)	
Gdip_DeleteBrush(pBrush)
}	
}
pMenuBackCenter :=  RM2_RegBitmaps("pMenuBackCenter"), MenuBackCenterSize :=  RM2_Reg("MenuBackCenterSize")
Gdip_DrawImage(G, pMenuBackCenter, Size/2-MenuBackCenterSize/2, Size/2-MenuBackCenterSize/2, MenuBackCenterSize, MenuBackCenterSize)
Gdip_DisposeImage(pBack)
Gdip_DeleteGraphics(G)
Return pLayer
}
RM2_MergeMenuLayers(pBackAndItemsLayer="",pMenuForeLayer="", 	ByRef MenuRadius="") {
MenuShadowWidth := RM2_Reg("MenuShadowWidth")
BackAndItemsLayerSize  := Gdip_GetImageWidth(pBackAndItemsLayer)
ForeLayerSize  := Gdip_GetImageWidth(pMenuForeLayer)
if (BackAndItemsLayerSize > ForeLayerSize)
MenuSize := BackAndItemsLayerSize
else
MenuSize := ForeLayerSize
if (MenuShadowWidth>0)
MenuSize += MenuShadowWidth*2
MenuRadius := Round(MenuSize/2)	
pMenu := Gdip_CreateBitmap(MenuSize, MenuSize), G := Gdip_GraphicsFromImage(pMenu)
BackAndItemsLayerX := BackAndItemsLayerY := Round((MenuSize-BackAndItemsLayerSize)/2)
ForeLayerX := ForeLayerY := Round((MenuSize-ForeLayerSize)/2)
if (MenuShadowWidth>0) {	
MenuShadowWidthFactor := 1-(MenuShadowWidth*2/MenuSize)
pMenuShadowLayer := RM2_CreateRadialGradientBitmap(MenuSize-1, MenuSize-1, "0x" RM2_Reg("MenuShadowInnerColor"), "0x" RM2_Reg("MenuShadowOuterColor"), MenuShadowWidthFactor, MenuShadowWidthFactor)
Gdip_DrawImage(G, pMenuShadowLayer, 0, 0, MenuSize-1, MenuSize-1)
Gdip_DisposeImage(pMenuShadowLayer)
}
Gdip_DrawImage(G, pBackAndItemsLayer, BackAndItemsLayerX, BackAndItemsLayerY, BackAndItemsLayerSize, BackAndItemsLayerSize)
Gdip_DrawImage(G, pMenuForeLayer, ForeLayerX, ForeLayerY, ForeLayerSize, ForeLayerSize)
Gdip_DeleteGraphics(G)
Return pMenu
}
RM2_ResizeBitmap(ItemSize, ImageFile) {
if (ImageFile = "" or ItemSize = "")
Return
Att := FileExist(ImageFile)
if (Att="" or InStr(Att, "D") > 0)	
Return
pBitmap := Gdip_CreateBitmapFromFile(ImageFile)
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
if (Width > ItemSize) {
Percent := (ItemSize)/Width	
LayerWidth := ItemSize	
LayerHeight := Height*(Percent)
}
else if (Height > ItemSize) {
Percent := (ItemSize)/Height	
LayerWidth := Width*(Percent)	
LayerHeight := ItemSize
}	
Else
LayerWidth := ItemSize, LayerHeight := ItemSize
pLayer := Gdip_CreateBitmap(LayerWidth, LayerHeight)
G := Gdip_GraphicsFromImage(pLayer)
Gdip_SetInterpolationMode(G, 7)
Gdip_DrawImage(G, pBitmap, 0, 0, LayerWidth, LayerHeight)		
Gdip_DisposeImage(pBitmap)
Gdip_DeleteGraphics(G)
Return pLayer
}
RM2_CreateRadialGradientBitmap(w,h,InnerColor=0xffffffff,OuterColor=0xff000000,ScaleX=0,ScaleY=0) {	
Ptr := A_PtrSize ? "UPtr" : "UInt"
pBitmap := Gdip_CreateBitmap(W, H)
pGraphics := Gdip_GraphicsFromImage(pBitmap)
Gdip_SetSmoothingMode(pGraphics, 4)
DllCall("gdiplus\GdipCreatePath", "int", BrushMode, A_PtrSize ? "UPtr*" : "UInt*", pPath)
DllCall("gdiplus\GdipAddPathEllipse", "uint", pPath, "float", 0, "float", 0, "float", w, "float", h)
DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", Ptr, pPath, "PtrP", pBrush)
VarSetCapacity(Point, 8), NumPut(W/2, Point, 0, "Float"), NumPut(H/2, Point, 4, "Float")
DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", Ptr, pBrush, Ptr, &Point)
DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", Ptr, pBrush, "UInt", InnerColor)
VarSetCapacity(Color, 4, 0), NumPut(OuterColor, Color, 0, "UInt")
DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", Ptr, pBrush, Ptr, &Color, "IntP", 1)
DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", Ptr, pBrush, "Float", ScaleX, "Float", ScaleY)
DllCall("gdiplus\GdipFillPath", Ptr, pGraphics, Ptr, pBrush, Ptr, pPath)
Gdip_DeleteBrush(pBrush)
Gdip_DeletePath(pPath)
Gdip_DeleteGraphics(pGraphics)
return pBitmap
}
RM2_GetSelectedItemNumber(StartX, StartY, EndX, EndY, GuiNum) {
ItemSize := RM2_Reg("ItemSize")
RadiusRingAll := RM2_Reg("RadiusRingAll"), ItemLayoutPerRing := RM2_Reg("ItemLayoutPerRing")
TotalRings := RM2_Reg("M" GuiNum "#TotalRings")
StringSplit, RadiusRing, RadiusRingAll, |
StringSplit, ItemsPerRing, ItemLayoutPerRing, .
CloseRingRadius := RadiusRing1 - (ItemSize/2)
Loop, %TotalRings%
{
if A_index = %TotalRings%
RadiusRing%TotalRings% += ItemSize/2
else
{
i2 := A_index + 1
RadiusRing%A_index% := (RadiusRing%A_index% + RadiusRing%i2%)/2
}	
}	
Radius := RM2_GetRadius(StartX, StartY, EndX, EndY)
if (Radius <= CloseRingRadius)
Return
Loop, %TotalRings%	
{
if (Radius <= RadiusRing%A_Index%)
{
SelectedRing = %A_Index%
Break
}
}
if SelectedRing = 
Return
ItemsPerRing := ItemsPerRing%SelectedRing%
Angle := RM2_GetAngle(StartX, StartY, EndX, EndY)
AnglePerItem := 360/ItemsPerRing
Loop, %ItemsPerRing%
{
if A_index = 1
AreaMax := AnglePerItem/2
Else
AreaMax += AnglePerItem
if (Angle <= AreaMax)
{
SelectedNumber := A_index
Break
}
}
SelectedNumber := (SelectedNumber = "") ? 1 : SelectedNumber
if SelectedRing = 1
ItemsFromPreviousRings := 0
else if SelectedRing = 2
ItemsFromPreviousRings := ItemsPerRing1
else if SelectedRing = 3
ItemsFromPreviousRings := ItemsPerRing1 + ItemsPerRing2
else if SelectedRing = 4
ItemsFromPreviousRings := ItemsPerRing1 + ItemsPerRing2 + ItemsPerRing3
Return SelectedNumber + ItemsFromPreviousRings
}
RM2_GetSelectedItemNumberOR(StartX, StartY, EndX, EndY, GuiNum) {
ItemSize := RM2_Reg("ItemSize")
RadiusRing1 := RM2_RegOR("M" GuiNum "#RingRadius", RingRadius)
TotalItems := RM2_RegOR("M" GuiNum "#TotalItems", TotalItems)		
CloseRingRadius := RadiusRing1 - (ItemSize/2)
OutOfRingRadius := RadiusRing1 + (ItemSize/2)
Radius := RM2_GetRadius(StartX, StartY, EndX, EndY)
if (Radius <= CloseRingRadius)
Return
if (Radius > OutOfRingRadius)
Return
Angle := RM2_GetAngle(StartX, StartY, EndX, EndY)
AnglePerItem := 360/TotalItems
Loop, %TotalItems%
{
if A_index = 1
AreaMax := AnglePerItem/2
Else
AreaMax += AnglePerItem
if (Angle <= AreaMax)
{
SelectedNumber := A_index
Break
}
}
SelectedNumber := (SelectedNumber = "") ? 1 : SelectedNumber
Return SelectedNumber
}
RM2_GetLayout(ItemSize,RadiusSizeFactor,ItemLayoutPerRing, ByRef RadiusRingAll="", ByRef SizeRingAll="", ByRef Offsets="") {
Static pi := 3.141593
StringSplit, ItemsInRing, ItemLayoutPerRing, .	
RadiusRing1 :=  ItemSize/(2*Sin(pi/ItemsInRing1))*RadiusSizeFactor
RadiusRing2 :=  ItemSize/(2*Sin(pi/ItemsInRing2))*RadiusSizeFactor
RadiusRing3 :=  ItemSize/(2*Sin(pi/ItemsInRing3))*RadiusSizeFactor
RadiusRing4 :=  ItemSize/(2*Sin(pi/ItemsInRing4))*RadiusSizeFactor
TotalITems := ItemsInRing1 + ItemsInRing2 + ItemsInRing3 + ItemsInRing4
Loop, %TotalITems%
{
CurItemsInRing := ItemsInRing%A_Index%
CurRingRadius := RadiusRing%A_Index%
Loop, %CurItemsInRing%
{
if A_index = 1
rad := 90*pi/180
Else
{
deg := deg ? deg+(360/CurItemsInRing): (360/CurItemsInRing)+90
rad := deg*pi/180
}
xOffset := CurRingRadius*(-1*Cos(rad))-ItemSize/2, yOffset := CurRingRadius*(-1*Sin(rad))-ItemSize/2
xOffset := Round(xOffset), yOffset := Round(yOffset)
Offsets .= xOffset ":" yOffset "|"
CurOffsetNum++
RM2_Reg("Offset" CurOffsetNum, xOffset ":" yOffset)
}
deg =
}
RM2_TrimEnd(Offsets)	
Loop, 4
RadiusRing%A_Index% := Round(RadiusRing%A_Index%)
Loop, 4
RadiusRingAll .= RadiusRing%A_Index% "|"
RM2_TrimEnd(RadiusRingAll) 
SizeRing1 := Round((RadiusRing1 + ItemSize/2)*2)
SizeRing2 := Round((RadiusRing2 + ItemSize/2)*2)
SizeRing3 := Round((RadiusRing3 + ItemSize/2)*2)
SizeRing4 := Round((RadiusRing4 + ItemSize/2)*2)
SizeRingAll := SizeRing1 "|" SizeRing2 "|" SizeRing3 "|" SizeRing4 
}
RM2_RefineMatrix(ByRef Matrix) {		
if (SubStr(Matrix,1,5) = "ARGB|")	
{
StringTrimLeft, Matrix, Matrix, 5
StringSplit, it, Matrix, |
Matrix = 1,0,0,0,0`n0,1,0,0,0`n0,0,1,0,0`n0,0,0,%it1%,0`n%it2%,%it3%,%it4%,0,1
}
}
RM2_GetAngle(StartX, StartY, EndX, EndY) {
x := EndX-StartX, y := EndY-StartY
if (x = 0) {
if y > 0
Return 180
Else if y < 0
Return 360
Else
Return
}
Angle := ATan(y/x)*57.295779513
if x > 0
return Angle + 90
Else
return Angle + 270	
}
RM2_GetRadius(StartX, StartY, EndX, EndY) {
a := Abs(endX-startX), b := Abs(endY-startY), Radius := Sqrt(a*a+b*b)
Return Radius    
}
RM2_IsInCircle(Xstart, Ystart, Xend, Yend, radius) {
a := Abs(Xend-Xstart), b := Abs(Yend-Ystart), c := Sqrt(a*a+b*b)
Return c<radius ? 1:0   
}
RM2_TrimEnd(ByRef Value,EndCharacter="|") {
While (SubStr(Value,0) = EndCharacter)
StringTrimRight, Value, Value, 1
}
RM2_CloneBitmap(pBitmap) {
Gdip_GetDimensions(pBitmap, w, h)
pCloneBitmap := Gdip_CloneBitmapArea(pBitmap, 0, 0, w, h)
return pCloneBitmap
}
RM2_Default(ByRef Variable,DefaultValue) {
if (Variable="")
Variable := DefaultValue 
}
RM2_RemoveFromList(List, ToRemove, Delimiter=",") {	
Loop, parse, List, % Delimiter
{
if (A_LoopField != ToRemove)
NewList .= Delimiter A_LoopField
}
return SubStr(NewList, 1+StrLen(Delimiter))
}
RM2_RefineItemLayoutPerRing(ItemLayoutPerRing) {
if (ItemLayoutPerRing = "")
return "6.12.18.24"			
StringSplit, a, ItemLayoutPerRing, .
RM2_Default(a1,0), RM2_Default(a2,0), RM2_Default(a3,0), RM2_Default(a4,0)	
return a1 "." a2 "." a3 "." a4
}
RM2_CreateLayeredWin(GuiNum,pBitmap,DrawControlOutline=0) {
Gui %GuiNum%: Destroy	
Gui %GuiNum%: -Caption +E0x80000 +LastFound +ToolWindow +AlwaysOnTop +OwnDialogs
Gui %GuiNum%: Show, hide
hwnd := WinExist()
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)
Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height)
if (DrawControlOutline = 1) {
pPen := Gdip_CreatePen("0xffff0000", 1)
Gdip_DrawEllipse(G, pPen, 0, 0, Width-1, Height-1)
Gdip_DrawRectangle(G, pPen, 0, 0, Width-1, Height-1)
Gdip_DeletePen(pPen)
}
UpdateLayeredWindow(hwnd, hdc, (A_ScreenWidth-Width)/2, (A_ScreenHeight-Height)/2, Width, Height)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
Return hwnd
}
RM2_ToolTipFM(Text="", WhichToolTip=16, xOffset=16, yOffset=16) {		
static LastText, hwnd, VirtualScreenWidth, VirtualScreenHeight		
if (VirtualScreenWidth = "" or VirtualScreenHeight = "") {
SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79
}
if (Text = "")	
{
ToolTip,,,, % WhichToolTip
LastText := "", hwnd := ""
return
}
else	
{
CoordMode, Mouse, Screen
MouseGetPos, x,y
x += xOffset, y += yOffset
WinGetPos,,,w,h, ahk_id %hwnd%
if ((x+w) > VirtualScreenWidth)
AdjustX := 1
if ((y+h) > VirtualScreenHeight)
AdjustY := 1
if (AdjustX and AdjustY)
x := x - xOffset*2 - w, y := y - yOffset*2 - h
else if AdjustX
x := VirtualScreenWidth - w
else if AdjustY
y := VirtualScreenHeight - h
if (Text = LastText)	
DllCall("MoveWindow", A_PtrSize ? "Ptr" : "UInt",hwnd,"Int",x,"Int",y,"Int",w,"Int",h,"Int",0)
else	
{
CoordMode, ToolTip, Screen
ToolTip,,,, % WhichToolTip	
ToolTip, % Text, x, y, % WhichToolTip	
hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " DllCall("GetCurrentProcessId")), LastText := Text
%A_ThisFunc%(Text, WhichToolTip, xOffset, yOffset)	
}
Winset, AlwaysOnTop, on, ahk_id %hwnd%
}
}
RM2_CreateItemBitmap(ItemAttributes="",ItemSize="") {
static FromSkinOrder := "TextBoxShrink|TextFont|TextSize|TextColor|TextTrans|TextRendering|TextShadow|TextShadowColor|TextShadowTrans|TextShadowOffset|IconShrink|IconTrans|ItemBackShrink|ItemBackTrans|ItemForeShrink|ItemForeTrans|ItemShadowShrink|ItemShadowTrans"
static OneItemAttributesOrder := "Text>Icon>Tooltip>Submenu>SpecItemBack>SpecItemFore"
if (ItemSize = "") 
ItemSize := RM2_Reg("ItemSize")
pItemBack := RM2_RegBitmaps("pItemBack"), pItemFore := RM2_RegBitmaps("pItemFore"), pItemShadow := RM2_RegBitmaps("pItemShadow")
AutoSubmenuMarking := RM2_Reg("AutoSubmenuMarking"), FromSkin := RM2_Reg("FromSkin")
StringSplit, value, FromSkin, |				
Loop, Parse, FromSkinOrder, |
%A_LoopField% :=  value%A_Index%			
StringSplit, ItemAtt, ItemAttributes, >
Loop, Parse, OneItemAttributesOrder, >
%A_LoopField% :=  ItemAtt%A_Index%			
ItemBackShrink := ItemSize-ItemBackShrink*ItemSize	
ItemForeShrink := ItemSize-ItemForeShrink*ItemSize
TextBoxShrink := ItemSize-TextBoxShrink*ItemSize
TextW := ItemSize-TextBoxShrink*2, TextH := ItemSize-TextBoxShrink*2
IconShrink := ItemSize-IconShrink*ItemSize
if AutoSubmenuMarking
AutoSubmenuMarking := ItemSize-AutoSubmenuMarking*ItemSize
BitmapSize := ItemSize
pBitmap := Gdip_CreateBitmap(BitmapSize, BitmapSize), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_FontFamilyCreate(TextFont)
x := 0, y := 0 	
if SpecItemBack
{
if !(SpecItemBack = "nb" or SpecItemBack = "no back")	
{
pSpecItemBack := Gdip_CreateBitmapFromFile(SpecItemBack)
Gdip_DrawImage(G, pSpecItemBack, x+ItemBackShrink, y+ItemBackShrink
, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2)
Gdip_DisposeImage(pSpecItemBack)
}
}
Else
Gdip_DrawImage(G, pItemBack, x+ItemBackShrink, y+ItemBackShrink
, ItemSize-ItemBackShrink*2, ItemSize-ItemBackShrink*2,"","","","",ItemBackTrans)
pIcon := Gdip_CreateBitmapFromFile(Icon)
Gdip_DrawImage(G, pIcon, x+IconShrink, y+IconShrink
, ItemSize-IconShrink*2, ItemSize-IconShrink*2,"","","","",IconTrans)
Gdip_DisposeImage(pIcon)
TextX := x+TextBoxShrink, TextY := y+TextBoxShrink
if TextShadow
{
ShadowX := TextX + TextShadowOffset, ShadowY := TextY + TextShadowOffset
Options = x%ShadowX% y%ShadowY% Center Vcenter c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, Text, Options, TextFont,TextW, TextH )  
}
Options = x%TextX% y%TextY% Center Vcenter c%TextTrans%%TextColor% r%TextRendering% s%TextSize% 
Gdip_TextToGraphics(G, Text, Options, TextFont,TextW, TextH )  
if Submenu
{
if AutoSubmenuMarking
{
SubMarkX := x, SubMarkY := y+AutoSubmenuMarking
if TextShadow
{
SubMarkXShadow := SubMarkX + TextShadowOffset, SubMarkYShadow := SubMarkY + TextShadowOffset
Options = x%SubMarkXShadow% y%SubMarkYShadow% Center c%TextShadowTrans%%TextShadowColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize, ItemSize-AutoSubmenuMarking*2 )  
}
Options = x%SubMarkX% y%SubMarkY% Center c%TextTrans%%TextColor% r%TextRendering% s%TextSize%
Gdip_TextToGraphics(G, RM2_Reg("AutoSubmenuMark"), Options, TextFont,ItemSize,ItemSize-AutoSubmenuMarking*2)
}
}
if !(SpecItemFore = "nf" or SpecItemFore = "no fore")	
{
Gdip_DrawImage(G, pItemFore, x+ItemForeShrink, y+ItemForeShrink	
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2,"","","","",ItemForeTrans)
if SpecItemFore	
{
pSpecItemFore := Gdip_CreateBitmapFromFile(SpecItemFore)
Gdip_DrawImage(G, pSpecItemFore, x+ItemForeShrink, y+ItemForeShrink
, ItemSize-ItemForeShrink*2, ItemSize-ItemForeShrink*2)
Gdip_DisposeImage(pSpecItemFore)
}
}	
Gdip_DeleteGraphics(G)
Return pBitmap
}
RM2_SaveButtonToFile(FilePath, ItemAttributes="", Size="") {
pBitmap := RM2_CreateItemBitmap(ItemAttributes,Size)
Gdip_SaveBitmapToFile(pBitmap, FilePath, 95)
Gdip_DisposeImage(pBitmap)
}
RM2_IsMenuUnderMouse() {	
MouseGetPos,,, hWinUnderMouse
hWinItemGlow := RM2_Reg("ItemGlowHWND")	
if (hWinUnderMouse = hWinItemGlow)
return 1
else {
MenusHwndList := RM2_GetMenusHwndList()
if hWinUnderMouse in %MenusHwndList%
return 1
}
}
RM2_GetMenusHwndList() {	
MenusList := RM2_Reg("MenusList")
Loop, parse, MenusList, `,
List .= RM2_Reg("M" A_LoopField "#HWND") ","
If (SubStr(List,0) = ",")
StringTrimRight, List, List, 1
return List
}
RM2_DockHandler(SelectMethod="", Options = "", EnableMoveKey = "Control") {
MouseGetPos,,, WinUMID
Loop, parse, options, %A_Space%
{
if (A_loopField = "cm") {
cm := 1
break
}
}
If GetKeyState(EnableMoveKey,"p") {
PostMessage, 0xA1, 2
KeyWait, Lbutton
WinGetPos,x,y,h,w, ahk_id %WinUMID%
xCen := x+w/2, yCen := y+h/2
if (mod(w, 2) = 1)
xCen += 1
if (mod(h, 2) = 1)
yCen += 1
RM2_Reg("M" A_Gui "#LastShowCoords", Round(xCen) "|" Round(yCen))
Return
}
ChildMenuToShow := RM2_RegD("D" A_Gui "#ChildMenu")
if ChildMenuToShow = 
return "|" A_Gui
WinGetPos,x,y,h,w, ahk_id %WinUMID%
xPos := x+w/2, yPos := y+h/2
if (cm = 1) {	
CoordMode, Mouse, screen
MouseMove, %xPos%, %yPos%, 0
}
SelectedItem := RM2_Handler(ChildMenuToShow,SelectMethod,"LButton",options, xPos, yPos)
Return SelectedItem
}
RM2_DockHandler2(SelectMethod="", Options = "", EnableMoveKey = "Control") {	
static DocksList
MouseGetPos,,, WinUMID
if (DocksList = "")
DocksList := RM2_Reg("DocksList")
Loop, parse, DocksList, `,
{
if ((RM2_Reg("M" A_LoopField "#HWND")) = WinUMID)
{
GuiNum := A_LoopField
break
}
}
if !GuiNum
return
Loop, parse, options, %A_Space%
{
if (A_loopField = "cm")
{
cm := 1
break
}
}
If GetKeyState(EnableMoveKey,"p")
{
RM2_DragNotActivate(WinUMID)
WinGetPos,x,y,h,w, ahk_id %WinUMID%
xCen := x+w/2, yCen := y+h/2
if (mod(w, 2) = 1)
xCen += 1
if (mod(h, 2) = 1)
yCen += 1
RM2_Reg("M" GuiNum "#LastShowCoords", Round(xCen) "|" Round(yCen))
Return
}
ChildMenuToShow := RM2_RegD("D" GuiNum "#ChildMenu")
if ChildMenuToShow = 
return "|" GuiNum
WinGetPos,x,y,h,w, ahk_id %WinUMID%
xPos := x+w/2, yPos := y+h/2
if cm
{
CoordMode, Mouse, screen
MouseMove, %xPos%, %yPos%, 0
}
SelectedItem := RM2_Handler(ChildMenuToShow,SelectMethod,"LButton",options, xPos, yPos)
Return SelectedItem
}
RM2_ShowDocks(DocksToShowList="") {		
DocksList := RM2_Reg("DocksList")
Loop, parse, DocksList, `,
{
if A_LoopField not in %DocksToShowList%
Gui %A_LoopField%:Hide
}
Loop, parse, DocksToShowList, `,
{
if (DllCall("IsWindowVisible", A_PtrSize ? "Ptr" : "UInt", RM2_Reg("M" A_LoopField "#HWND")) != 1)
Gui %A_LoopField%:Show, NA
}
}
RM2_GetDocksHwndList() {	
DocksList := RM2_Reg("DocksList")
Loop, parse, DocksList, `,
List .= RM2_Reg("M" A_LoopField "#HWND") ","
If (SubStr(List,0) = ",")
StringTrimRight, List, List, 1
return List
}
RM2_IsDockUnderMouse() {	
MouseGetPos,,, WinUMID
DocksHwndList := RM2_GetDocksHwndList()
if WinUMID in %DocksHwndList%
return 1
}
RM2_IsDock(GuiNum) {	
DocksList := RM2_Reg("DocksList")
if GuiNum in %DocksList%
return 1
}
RM2_DragNotActivate(hwnd,WhileKeyDown="LButton") {
CoordMode, mouse, screen
MouseGetPos, mx,my
WinGetPos, wx,wy,,, ahk_id %hwnd%
offsetX := mx-wx, offsetY := my-wy
owd := A_WinDelay
SetWinDelay, -1
While (GetKeyState(WhileKeyDown,"p")) {
Sleep, 20
MouseGetPos, x,y
WinMove, ahk_id %hwnd%,, x-offsetX,y-offsetY
}
SetWinDelay, %owd%
}
RM2_HideAllDocks() {
DocksList := RM2_Reg("DocksList")
Loop, parse, DocksList, `,
Gui %A_LoopField%: Hide
}
RM2_ShowAllDocks() {
DocksList := RM2_Reg("DocksList")
Loop, parse, DocksList, `,
Gui %A_LoopField%: Show, NA
}
RM2_CreateDock(GuiNum, ItemAttributes="", ChildMenu="", Size="") {
static OneItemAttributesOrder := "Text>Icon>Tooltip>Submenu>SpecItemBack>SpecItemFore"
RM2_Delete(GuiNum)	
RM2_RegBackup("M" GuiNum "#ItemAttributes", ItemAttributes, 1)
RM2_RegBackup("M" GuiNum "#ChildMenu", ChildMenu, 1)
RM2_RegBackup("M" GuiNum "#Size", Size, 1)
StringSplit, ItemAtt, ItemAttributes, >
Loop, Parse, OneItemAttributesOrder, >
%A_LoopField% :=  ItemAtt%A_Index%			
pDockBitmap := RM2_CreateItemBitmap(ItemAttributes, Size)
DockHWND := RM2_CreateLayeredWin(GuiNum,pDockBitmap)	
DockRadius := Round(Gdip_GetImageWidth(pDockBitmap)/2)	
Gdip_DisposeImage(pDockBitmap)	
if !(Tooltip = "")	
{
if (Tooltip = "ntt")	
Tooltip =
else
Transform, Tooltip, Deref, %Tooltip%
}
else	
{
if !(Text = "")	
Tooltip := Text
else if (FileExist(Icon))	
{
SplitPath, ia2,,,,OutNameNoExt
Tooltip := OutNameNoExt
}
else	
Tooltip := "" 
}
RM2_Reg("M" GuiNum "#MenuRadius", DockRadius)	
RM2_Reg("M" GuiNum "#HWND", DockHWND)	
RM2_RegD("D" GuiNum "#ToolTip", Tooltip, 1)
DocksList := RM2_Reg("DocksList")
DocksList := (DocksList = "") ? GuiNum : DocksList "," GuiNum	
RM2_Reg("DocksList", DocksList)	
RM2_RegD("D" GuiNum "#ChildMenu", ChildMenu, 1)
return GuiNum
}
RM2_SetDocksToDesktop(GuiNumbers="") {
DesktopWinID := DllCall("GetShellWindow")	
if (GuiNumbers = "")
GuiNumbers := RM2_Reg("DocksList")
Loop, parse, GuiNumbers, `,
DllCall("SetParent","UInt", RM2_Reg("M" A_LoopField "#HWND"),"UInt", DesktopWinID)
}
RM2_DrawOnPic(ControlHwnd,ItemAttributes="",Size="") {
pBitmap := RM2_CreateItemBitmap(ItemAttributes,Size)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(ControlHwnd, hBitmap)
DeleteObject(hBitmap), Gdip_DisposeImage(pBitmap)
}
RM2_PicHandler(MenuToShow, ControlHwnd="",Options="", SelectMethod="") {
CoordMode, Mouse, screen
MouseGetPos,x,y,WinID,ControlUMHwnd,2
if ControlHwnd =
ControlHwnd := ControlUMHwnd
ControlGetPos, ControlX, ControlY, ControlW, ControlH, ,ahk_id %ControlHwnd%
WinGetPos, wx, wy, wW, wh, ahk_id %WinID%
PicCenterX := wX+ControlX+(ControlW/2), PicCenterY := wY+ControlY+(ControlH/2)
ButtonRadius := (ControlW+ControlH)/4
a := Abs(X-PicCenterX), b := Abs(Y-PicCenterY), c := Sqrt(a*a+b*b)
if (c > ButtonRadius)
return
SelectedItem := RM2_Handler(MenuToShow, SelectMethod, "LButton", Options, PicCenterX, PicCenterY)
return SelectedItem
}
RM2_Reg(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegBitmaps(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegTT(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegTOI(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegOR(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegD(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}
RM2_RegBackup(variable, value="", ForceSetValue = 0) { 	
static
if (value = "") {
if ForceSetValue	
RM2_kxucfp%variable%pqzmdk := ""
else	   
{
yaqxswcdevfr := RM2_kxucfp%variable%pqzmdk
Return yaqxswcdevfr
}
}
Else         
RM2_kxucfp%variable%pqzmdk = %value%
}