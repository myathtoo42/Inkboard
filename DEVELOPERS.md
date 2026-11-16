# Developer guide

Inkboard is MIT-licensed, so you can read it, change it, ship it, or fork it. It is a plain folder: no accounts, no GitHub, no build step. Use whatever version control or hosting you like (or none).

## What it's built with

| Piece | What | Why |
| --- | --- | --- |
| **Electron** | Wraps the web page in a Windows desktop window (`main.js`) | One codebase for desktop and browser |
| **HTML5 Canvas 2D** | Draws the whole board (`index.html`) | Fast, and works with thousands of items |
| **Vanilla JavaScript** | No framework, no bundler, no TypeScript | You can read the whole app top to bottom in one sitting |
| **electron-builder** | Makes the Windows installer and portable `.exe` (`npm run dist`) | Standard tool, config lives in `package.json` |
| **localStorage** | Autosave inside the app | No server, works offline |

Everything app-specific is in **one file**, `index.html` (about 600 lines of JS in a `<script>` block). `main.js` is only the window.

## Run and package

```
npm install
npm start        # run in a window
npm run dist     # build installer + portable exe into dist/
```

You can also double-click `index.html` to run it in any browser, which is the fastest way to hack on it (edit, refresh).

## How the code is organised

The script goes top to bottom in these sections:

1. **State**: `objs` (every item on the board), `sel` (selected ids), `view` (`{x, y, z}` pan and zoom), `tool`, undo/redo stacks.
2. **Tools and toolbar**: the `TOOLS` array drives both the buttons and the keyboard shortcuts.
3. **Helpers**: coordinate conversion (`w2s` / `s2w`), `bbox`, `hit` (hit testing), `topAt`.
4. **Persistence**: autosave, `.inkboard` save/open, PNG export.
5. **Drawing**: `draw()` repaints everything every frame; `drawObj()` draws one item.
6. **Pointer and keyboard input**: one `drag` object describes what the mouse is doing (`pan`, `move`, `marquee`, `create`, `handle`, `pen`).
7. **Photos**: import, drag-and-drop, paste.

### The data model

The board is a flat list of objects. Every object has an `id` and a `type`:

| type | extra fields |
| --- | --- |
| `sticky`, `text`, `rect`, `ellipse`, `diamond` | `x, y, w, h, color, text`, optional `ff` (font), `fs` (size), `bd` (bold), `it` (italic), `al` (align) |
| `image` | `x, y, w, h, img` (key into the image store), `iar` (height / width of the photo) |
| `line`, `arrow` | `x, y` (start), `w, h` (signed offset to the end), `color` |
| `pen` | `points: [[x, y], …]`, `size`, `color` |
| `string` | `a`, `b` (the two ends), `color` |

Array order is draw order (later = on top). Strings are always drawn above everything else.

### Strings (connectors)

A string end is either **free** `{x, y}` or **glued** `{id, x, y}`. Glued ends are not stored as coordinates; `resolveString()` recomputes them on every frame:

1. Aim from each glued item's centre toward the other end.
2. `edgePoint()` finds where that line leaves the item's outline (rectangle, ellipse and diamond each have their own formula).
3. The string is drawn as a quadratic curve with a small downward sag.

That is why strings follow an item when you move or resize it: nothing has to be updated, the geometry is derived. Releasing a string end over any `BOX_TYPES` item glues it. Deleting an item frees any strings that were glued to it instead of deleting them.

### Photos

Photos are stored **once**, outside the object list, in `imgStore` (`key → data URL`). Objects only hold the key. That keeps undo snapshots small, because undo works by `JSON.stringify`-ing `objs`. Large photos are downscaled to 1600 px on import. `usedImages()` makes sure only photos still on the board are written into autosave and `.inkboard` files.

### File format

A `.inkboard` file is plain JSON:

```json
{ "app": "inkboard", "title": "…", "objs": [ … ], "nextId": 42, "images": { "<key>": "data:image/…" } }
```

### Undo

`commitUndo()` pushes a JSON snapshot of `objs` before any change. Undo/redo swap snapshots. Simple, and fast enough for boards of a few thousand items. A diff-based approach would be the upgrade if boards get huge.

## Theme, fonts and colour wheel

- **Theme**: colours are CSS variables (`:root` and `[data-theme=dark]`). The canvas reads one global, `dark`, for the grid and for neutral ink colours (`lineCol`, `inkNow`). PNG export temporarily forces light mode.
- **Fonts**: the `FONTS` table maps a name to a CSS font stack, which is Windows system fonts with fallbacks. Add a line there and it shows up in the font menu.
- **Colour wheel**: a canvas drawn pixel by pixel from HSV (angle = hue, distance from centre = saturation) plus a brightness slider. `hsv2rgb` and `hex2hsv` convert.

## Ideas for contributions

- Real-time collaboration (needs a small WebSocket server; the flat object list makes syncing straightforward)
- Labels on strings, arrowheads on strings
- Frames / groups
- Rotate items
- Lock items
- Zoom-dependent level of detail for very large boards

## Adding a new tool (example)

1. Add a row to `TOOLS` in `index.html`: `['star','★','Star (X)','x']`.
2. In the `pointerdown` handler, create your object and set `drag = {kind:'create', …}`.
3. Handle its shape in `drawObj()`, `hit()` and `bbox()`.

That's all: selection, move, undo, copy/paste, save and export work from `objs`.
