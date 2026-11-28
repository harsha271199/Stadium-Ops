import * as ort from "onnxruntime-web";
import { PaddleOcrService } from "ppu-paddle-ocr/web";
// Same-origin files (shipped in the Netlify zip under /ocr/).
const base = new URL('/ocr/', location.href).href;
ort.env.wasm.wasmPaths = base;
ort.env.wasm.numThreads = 1;
let svc = null, loading = null, svcSide = 0;
async function get(side) {
  side = side || 480;
  if (svc && svcSide !== side) { try { await svc.destroy(); } catch (e) {} svc = null; loading = null; }
  if (svc) return svc;
  if (loading) return loading;
  loading = (async () => {
    const f = async p => { const r = await fetch(base + p); if (!r.ok) throw new Error('load ' + p + ' ' + r.status); return r.arrayBuffer(); };
    const [det, rec, dict] = await Promise.all([f('det.onnx'), f('rec.onnx'), f('keys.txt')]);
    const s = new PaddleOcrService({ model: { detection: det, recognition: rec, charactersDictionary: dict }, session: { executionProviders: ['wasm'] }, detection: { maxSideLength: side } });
    await s.initialize(); svc = s; svcSide = side; return s;
  })();
  try { return await loading; } catch (e) { loading = null; throw e; }
}
window.BtPaddle = {
  ready: () => !!svc,
  load: get,
  // -> [{text, conf}] lines
  read: async (canvas, side) => {
    const s = await get(side);
    const r = await s.recognize(canvas, { flatten: true, noCache: true });
    const items = (r && (r.results || r.items || r.lines || [])) || [];
    const flat = Array.isArray(items) ? items.flat() : [];
    return { text: String((r && r.text) || ''), items: flat.map(i => ({ text: String(i.text || ''), conf: Number(i.confidence || 0) })) };
  }
};
