# Inkboard

A Miro-style infinite whiteboard for Windows. Runs fully offline, no account needed.

## Run it

Easiest: install Node.js, then double-click **Start Inkboard.bat**.

Note: `main.js`, `package.json` and the other source files are not meant to be double-clicked. To read them, right-click and choose **Open with > Notepad** (or VS Code).

1. Install Node.js (LTS) from https://nodejs.org
2. Open a terminal in this folder and run:

```
npm install
npm start
```

## Build a Windows installer / portable .exe

```
npm run dist
```

The installer and portable exe appear in the `dist` folder.

Tip: you can also just double-click `index.html` to try it in any browser.

For how the code works, see [DEVELOPERS.md](DEVELOPERS.md). MIT licensed.

## Features

- Infinite canvas with zoom and pan
- Sticky notes, text, rectangles, ellipses, diamonds, lines, arrows, freehand pen
- **Photos**: drag & drop image files onto the board, paste from the clipboard, or use the photo button
- **Strings**: connect photo ↔ photo, note ↔ photo, photo ↔ note (or any shape). Strings stay glued and follow items when you move them
- **Text formatting**: 8 fonts, size, bold, italic and alignment for notes, text and shapes
- **Colour wheel** for any colour, plus quick swatches
- **Dark and light mode** (follows Windows by default, toggle top-right)
- Resize, multi-select (drag a box or Shift+click), duplicate, copy/paste, bring to front / send to back
- Undo / redo
- Autosaves in the app; Save/Open boards as `.inkboard` files; export to PNG

## Shortcuts

| Key | Action |
| --- | --- |
| V / H | Select / Pan |
| N, T, I, R, O, D, L, A, S, P | Sticky, Text, Photo, Rect, Ellipse, Diamond, Line, Arrow, String, Pen |
| Space + drag, middle mouse | Pan |
| Scroll / Ctrl+scroll | Zoom |
| Double-click | Edit text (or create text on empty space) |
| Enter | Edit selected shape's text |
| Del | Delete |
| Ctrl+Z / Ctrl+Y | Undo / redo |
| Ctrl+D, Ctrl+C, Ctrl+V | Duplicate, copy, paste |
| Ctrl+S / Ctrl+O | Save / open |
| Ctrl+0 | Zoom to fit |
| Arrow keys | Nudge selection (Shift = 10px) |
