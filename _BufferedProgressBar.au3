#include-once
#include <WindowsConstants.au3>
#include <WinAPIGdi.au3>
#include <WinAPISys.au3>
#include <WinAPIHObj.au3>

; #INDEX# =======================================================================================================================
; Title .........: _BufferedProgressBar
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: Tiny UDF for a smooth, flicker-free 0.0–100.0 progress bar drawn into a GUI label via off-screen buffering. The standard progress bar only accepts values between 0-100 and only accepts ints, not floats so large progress bars felt very choppy
; Author(s) .....: MantraAU@Github
; Created .......: 30/07/2025
; Modified ......: 31/07/2025
; Dll(s) ........: gdi32.dll, user32.dll (via WinAPI wrapper)
; ==============================================================================================================================

; #CURRENT# ======================================================================================================================
; _BufferedProgressBar_Update($hGUI, $hLabel, $fValue, $iMaxWidth, $iColor = 0xCCCCCC, $iBgColor = 0x303030)
; ==============================================================================================================================

; #PARAMETERS# ====================================================================================================================
; $hGUI       - Handle of your GUI (e.g. hGUI returned by GUICreate)
; $hLabel     - Control ID of a label created at full width and desired height
; $fValue     - Float value between 0.0 and 100.0 for percentage filled
; $iMaxWidth  - Full pixel width of the progress bar (the label width)
; $iColor     - [optional] RGB color for the filled portion (default: 0xCCCCCC)
; $iBgColor   - [optional] RGB color for the background (default: 0x303030)
; ==============================================================================================================================

; #USAGE# =========================================================================================================================
; #include <GUIConstantsEx.au3>
; #include "_BufferedProgressBar.au3"
;
; Local $hGUI = GUICreate("Buffered Progress", 400, 150)
; Local $idBar = GUICtrlCreateLabel("", 20, 20, 300, 20)
; GUICtrlSetBkColor($idBar, 0xFFFFFF)
; GUISetState(@SW_SHOW)
;
; ; in your loop or event:
; _BufferedProgressBar_Update($hGUI, $idBar, 42.7, 300, 0x0000FF, 0xDDDDDD)
; ==============================================================================================================================

Func _BufferedProgressBar_Update($hGUI, $hLabel, $fValue, $iMaxWidth, $iColor = 0xCCCCCC, $iBgColor = 0x303030)
    ; --- 1) Clamp value to valid range 0–100
    If $fValue < 0   Then $fValue = 0
    If $fValue > 100 Then $fValue = 100

    ; --- 2) Get label position and size
    Local $aPos = ControlGetPos($hGUI, "", $hLabel)
    If @error Then Return
    Local $iHeight = $aPos[3]
    ; Calculate fill width in pixels (float → percent * max width)
    Local $iFillW = Round($fValue * $iMaxWidth / 100.0)

    ; --- 3) Create a memory DC and bitmap for off-screen drawing
    Local $hWndLabel = ControlGetHandle($hGUI, "", $hLabel)
    Local $hDC       = _WinAPI_GetDC($hWndLabel)
    Local $hMemDC    = _WinAPI_CreateCompatibleDC($hDC)
    Local $hBmp      = _WinAPI_CreateCompatibleBitmap($hDC, $iMaxWidth, $iHeight)
    Local $hOldBmp   = _WinAPI_SelectObject($hMemDC, $hBmp)

    ; --- 4) Clear the background with the bg color
    Local $hBrushBG = _WinAPI_CreateSolidBrush($iBgColor)
    Local $tRect = DllStructCreate("int left;int top;int right;int bottom")
    DllStructSetData($tRect, "left",   0)
    DllStructSetData($tRect, "top",    0)
    DllStructSetData($tRect, "right",  $iMaxWidth)
    DllStructSetData($tRect, "bottom", $iHeight)
    _WinAPI_FillRect($hMemDC, DllStructGetPtr($tRect), $hBrushBG)
    _WinAPI_DeleteObject($hBrushBG)

    ; --- 5) Draw the filled portion
    Local $hBrushFG = _WinAPI_CreateSolidBrush($iColor)
    DllStructSetData($tRect, "right", $iFillW)
    _WinAPI_FillRect($hMemDC, DllStructGetPtr($tRect), $hBrushFG)
    _WinAPI_DeleteObject($hBrushFG)

    ; --- 6) Copy the off-screen bitmap to the label's DC
    _WinAPI_BitBlt($hDC, 0, 0, $iMaxWidth, $iHeight, $hMemDC, 0, 0, $SRCCOPY)

    ; --- 7) Clean up GDI objects and release DCs
    _WinAPI_SelectObject($hMemDC, $hOldBmp)
    _WinAPI_DeleteObject($hBmp)
    _WinAPI_DeleteDC($hMemDC)
    _WinAPI_ReleaseDC($hWndLabel, $hDC)
EndFunc   ;==>_BufferedProgressBar_Update
