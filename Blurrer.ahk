#NoEnv
#SingleInstance,Force
#persistent
#include, Gdip_All.ahk
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, mouse,screen
gui, add, button, ,  Stop(F9)
gui, add, button, , Start(F8)
Gui, Add, Slider, vSlider1 Range1-700, 100
Gui, Add, Slider, vSlider2 Range1-700, 100
Gui, Color, EEAA99
gui, show, w250 h200, Blurrer
Gui, 2: Show, NoActivate w200 h200, MagWindow
Gui, 2: +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
WinShow MagWindow
start = false
pToken := Gdip_Startup()
z := 2, w := %Slider1%, h := %Slider2%, b := 5
wx := w+2*b, hx := h+2*b
WinSet, Style, -0xC00000, MagWindow
hwnd1 := WinExist()
hbm := CreateDIBSection(wx, hx), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_DrawRectangle(G, pPen, b//2, b//2, wx-b, hx-b)
loop
{
	
	WinMove, MagWindow,,,, %Slider1%, %Slider2%
	Gui, Submit, NoHide
	while (%start%)
		{
			MouseGetPos, x,y
			WinGetPos,,, Width, Height, MagWindow
			WinMove, MagWindow,, x, y,			
			pBitmap := Gdip_BitmapFromScreen(x-(w//(2*z)) "|" y-(h//(2*z)) "|" w//z "|" h//z)
			Gdip_DrawImage(G, pBitmap, b, b, w, h, 0, 0, w//z, h//z)
			Gdip_DisposeImage(pBitmap)
			UpdateLayeredWindow(hwnd1, hdc, x-wx//2, y-hx//2, wx, hx)
			continue
		}

}
ButtonStart(F8):
	start = true
	WinHide Blurrer
	WinShow MagWindow
	return
F8::
	start = true
	WinHide Blurrer
	WinShow MagWindow
	return
ButtonStop(F9):
	start = false
	WinShow Blurrer
	return
F9::
	start = false
	WinShow Blurrer
	return
esc:: ExitApp