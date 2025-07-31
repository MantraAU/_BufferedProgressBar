# \_BufferedProgressBar.au3

**Tiny UDF for smooth, flicker-free floating-point progress bars in AutoIt**

This project provides a single-file AutoIt UDF (`_BufferedProgressBar.au3`) that draws a high-resolution, 0.0–100.0 progress bar directly into a GUI Label control using an off-screen (double-buffered) technique. It eliminates the choppy, integer-only updates of standard progress controls when animating long or high-width bars.

---

## Features

- **Floating-point values**: Accepts any value from 0.0 to 100.0, rather than only integers.
- **Double buffering**: All drawing is done off-screen in a memory DC and blitted in one operation, removing flicker.
- **Custom colours**: Easily set both the filled portion and the background colours via RGB hex values.
- **Lightweight**: Single UDF file with no external dependencies beyond standard AutoIt and WinAPI UDFs.
- **Easy integration**: Simply include the file, create a Label control, and call `_BufferedProgressBar_Update` in your loop or event handler.

---

## Installation

1. Download or clone this repository.
2. Copy `_BufferedProgressBar.au3` into your AutoIt script folder (e.g. `Include\`).
3. In your script, add:
   ```autoit
   #include "_BufferedProgressBar.au3"
   ```

---

## Usage Example

```autoit
#include "_BufferedProgressBar.au3"

; Create a GUI and a label for the bar
Local $hGUI = GUICreate("Buffered Progress", 400, 150)
Local $idBar = GUICtrlCreateLabel("", 20, 20, 360, 20)
GUICtrlSetBkColor($idBar, 0xFFFFFF) ; match GUI background
GUISetState(@SW_SHOW)

; Animate from 0.0 to 100.0
For $f = 0 To 100 Step 0.1
    _BufferedProgressBar_Update($hGUI, $idBar, $f, 360, 0x00AACC, 0x202020)
    Sleep(10)
Next

Sleep(2000)
```

### Function Prototype

```autoit
Func _BufferedProgressBar_Update(
    $hGUI       ; Handle to GUI window (e.g. @GUI_HWND)
,   $hLabel     ; Control ID of a Label sized to full width and height
,   $fValue     ; Float 0.0–100.0 indicating percent filled
,   $iMaxWidth  ; Pixel width of the bar (label width)
,   $iColor     ; [opt] RGB hex for the filled portion (default 0xCCCCCC)
,   $iBgColor   ; [opt] RGB hex for background (default 0x303030)
)
```

---

## Parameters Detail

| Parameter    | Type      | Description                                    |
| ------------ | --------- | ---------------------------------------------- |
| `$hGUI`      | HWND      | GUI handle returned by `GUICreate`.            |
| `$hLabel`    | ControlID | Label control ID created at full desired size. |
| `$fValue`    | Float     | Percentage to fill (0.0–100.0).                |
| `$iMaxWidth` | Integer   | Full pixel width of the bar (label width).     |
| `$iColor`    | Integer   | RGB hex for fill colour (default `0xCCCCCC`).  |
| `$iBgColor`  | Integer   | RGB hex for background (default `0x303030`).   |

---

## License

This code is dedicated to the public domain under **The Unlicense**.

---

## Roadmap

- **Vertical progress bar support** – coming soon.

---

> *Created by MantraAU on GitHub, July 2025*

