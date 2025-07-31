#include <WinAPITheme.au3> ;Required for Progress Bar 3 Example - Not required for use of the UDF
#include "_BufferedProgressBar.au3"

; === EXAMPLE SCRIPT ===
; Creates a small window and shows how to call_BufferedProgressBar_Update()
; to render a smooth, floating‐point progress bar.
;
;Also renders 2 other styles of progress bars for comparison

; 1. Create the GUI window (width=400, height=80)
Local $hGUI = GUICreate("Buffered Progress Demo", 400, 80)
GUISetBkColor(0x505050, $hGUI)

; 2. Create an empty label that will host the bar.
Local $hProgress1 = GUICtrlCreateLabel("", 5, 5, 390, 20) ;This is the label affected by the UDF

;3. Create standard progress bar for comparison (We can't color this one)
Local $hProgress2 = GUICtrlCreateProgress(5, 30, 390, 20)

;4. Create a styled progress bar for comparison (We can color this one)
$Theme = _WinAPI_GetThemeAppProperties() ;Store Theme
_WinAPI_SetThemeAppProperties($STAP_ALLOW_NONCLIENT) ;Set Theme to XP
Local $hProgress3 = GUICtrlCreateProgress(5, 55, 390, 20)
GUICtrlSetColor(-1, 0xCCCCCC)
GUICtrlSetBkColor(-1, 0x303030)
_WinAPI_SetThemeAppProperties($Theme) ;Reset Theme to Normal

; 5. Show the GUI on screen
GUISetState(@SW_SHOW)

; 6. Animate from 0.0 → 100.0 in tiny steps for a smooth effect & privde
For $i = 0 To 100 Step 0.1
    _BufferedProgressBar_Update($hGUI, $hProgress1, $i, 390, 0xCCCCCC, 0x303030)
	GUICtrlSetData($hProgress2, $i+0.1) ;Looks modern but very choppy with longer bars
	GUICtrlSetData($hProgress3, $i+0.1) ;Looks clean with the right coloring but can be very choppy with longer progress bars
    Sleep(10)
Next

; 7. Hold final state for a moment, then exit
Sleep(3000)
Exit