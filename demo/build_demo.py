"""Build the Stadium Ops DEMO site from the real app.

Output: demo/dist/ (upload that folder, zipped, as a separate Netlify site).
The demo is the same app, but:
  * the real database address and key are replaced with dummy values, so the
    demo page contains nothing that can reach the real data;
  * demo-shim.js answers every database call in the browser from fake data;
  * no service worker, no OCR files, and the title/app name say DEMO.
Run: python3 demo/build_demo.py
"""
import os, re, shutil, json, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'demo', 'dist')

src = open(os.path.join(ROOT, 'index.html'), encoding='utf-8').read()
real_url = re.search(r"const SUPA_URL = '([^']+)';", src).group(1)
real_key = re.search(r"const SUPA_KEY = '([^']+)';", src).group(1)

html = src.replace("const SUPA_URL = '%s';" % real_url, "const SUPA_URL = 'https://demo.supabase.co';")
html = html.replace("const SUPA_KEY = '%s';" % real_key, "const SUPA_KEY = 'demo-key';")
html = re.sub(r"const BUILD_TAG = '([^']+)';", lambda m: "const BUILD_TAG = '%s-DEMO';" % m.group(1), html, count=1)
html = re.sub(r'<title>[^<]*</title>', '<title>DEMO · Stadium Ops</title>', html, count=1)
html = html.replace('<head>', '<head>\n<script src="/demo-shim.js"></script>\n<meta name="robots" content="noindex,nofollow">', 1)

for bad in (real_url, real_key, real_url.split('//')[1].split('.')[0]):
    if bad in html:
        sys.exit('STOP: real database detail still in demo page: ' + bad[:12] + '…')

if os.path.isdir(OUT):
    shutil.rmtree(OUT)
os.makedirs(OUT)
open(os.path.join(OUT, 'index.html'), 'w', encoding='utf-8').write(html)
shutil.copy(os.path.join(ROOT, 'demo', 'demo-shim.js'), OUT)
for f in ('icon-192.png', 'icon-512.png', '_redirects'):
    shutil.copy(os.path.join(ROOT, f), OUT)
shutil.copytree(os.path.join(ROOT, 'vendor'), os.path.join(OUT, 'vendor'))
man = json.load(open(os.path.join(ROOT, 'manifest.json')))
man['name'] = 'Stadium Ops DEMO'; man['short_name'] = 'Ops DEMO'
json.dump(man, open(os.path.join(OUT, 'manifest.json'), 'w'), indent=2)
open(os.path.join(OUT, '_headers'), 'w').write('/*\n  X-Content-Type-Options: nosniff\n  X-Robots-Tag: noindex, nofollow\n/index.html\n  Cache-Control: no-cache, no-store, must-revalidate\n')
# sw.js stub: unregisters any old worker from a browser that visited before.
open(os.path.join(OUT, 'sw.js'), 'w').write("self.addEventListener('install',e=>self.skipWaiting());self.addEventListener('activate',e=>e.waitUntil(self.registration.unregister()));\n")
print('demo built:', OUT, len(html), 'bytes')
