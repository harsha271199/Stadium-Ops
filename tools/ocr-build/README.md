# Bottle Tracker number reader (/ocr/)

`ocr/` holds the 🔢 Read number engine, shipped with the app and loaded only
when a manager taps Read number (then kept by the service worker, cache
`stadium-ops-ocr-v1`).

| File | From |
|---|---|
| `paddle.mjs` | `entry.js` bundled with esbuild (ppu-paddle-ocr 6.6.1 web build + onnxruntime-web 1.x wasm-only) |
| `ort-wasm-simd-threaded.mjs/.wasm` | `onnxruntime-web/dist/` |
| `det.onnx`, `rec.onnx`, `keys.txt` | `@gutenye/ocr-models@1.4.2/assets/` (PP-OCRv4 det/rec + dictionary) |

Rebuild:

```bash
npm i ppu-paddle-ocr@6.6.1 onnxruntime-web @gutenye/ocr-models@1.4.2 esbuild@0.24.2
npx esbuild entry.js --bundle --format=esm --minify --platform=browser --outfile=paddle.mjs \
  --alias:onnxruntime-web=./node_modules/onnxruntime-web/dist/ort.wasm.min.mjs
```

If any file in `ocr/` changes, bump `OCR_CACHE` in `sw.js` so phones fetch the new copy.
