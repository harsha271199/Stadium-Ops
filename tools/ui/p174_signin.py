"""fix-174: new sign-in look (Employee / NPO). Same IDs and functions; only markup + CSS change."""
import sys, re
path = sys.argv[1]; t = open(path, encoding='utf-8').read()
def rep(old, new, count=1):
    global t
    n = t.count(old)
    if n != count: raise SystemExit(f'anchor count {n} != {count}: {old[:70]!r}')
    t = t.replace(old, new)

MOON = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z"/></svg>'
HOUSE = '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 20V10l8-6 8 6v10"/><path d="M9 20v-6h6v6"/></svg>'
EMP = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="4" y="3" width="16" height="18" rx="3"/><circle cx="12" cy="10" r="3"/><path d="M8 17c.7-1.8 2.2-2.8 4-2.8s3.3 1 4 2.8"/></svg>'
GRP = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="8" cy="8" r="3"/><circle cx="16" cy="8" r="3"/><path d="M2 20c.6-3 3-5 6-5s5.4 2 6 5M14 15c.7-.3 1.4-.4 2-.4 3 0 5.4 2 6 5"/></svg>'
ARROW = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6"/></svg>'
CLOCK = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" aria-hidden="true" style="flex-shrink:0;margin-top:2px"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>'

CSS = '''
  /* fix-174: new sign-in look */
  #screen-login,#screen-npo-login{background:var(--bg)}
  .si-bar{height:6px;background:#C8102E;flex-shrink:0}
  .si-top{width:100%;max-width:440px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;padding:calc(env(safe-area-inset-top) + 50px) 16px 0}
  .si-mark{display:flex;align-items:center;gap:10px}
  .si-logo{width:40px;height:40px;border-radius:12px;background:#C8102E;color:#fff;display:flex;align-items:center;justify-content:center}
  .si-mark b{display:block;font-size:17px;font-weight:800;letter-spacing:-.01em;color:var(--text)}
  .si-mark small{display:block;font-size:12px;font-weight:600;color:var(--text-2)}
  .si-icon{width:44px;height:44px;border:1px solid var(--border);background:var(--bg-card);color:var(--text);border-radius:12px;display:flex;align-items:center;justify-content:center;cursor:pointer}
  .si-main{flex:1;width:100%;max-width:440px;margin:0 auto;display:flex;flex-direction:column;justify-content:center;gap:16px;padding:24px 16px 28px}
  .si-h1{font-size:30px;font-weight:800;letter-spacing:-.02em;color:var(--text)}
  .si-lead{font-size:16px;color:var(--text-2);margin-top:6px}
  .si-card{display:flex;flex-direction:column;gap:14px;padding:18px;background:var(--bg-card);border:1px solid var(--border);border-radius:22px;box-shadow:0 8px 24px rgba(22,24,29,.06)}
  .si-seg{display:grid;grid-template-columns:1fr 1fr;gap:4px;padding:4px;background:var(--bg-elevated);border:1px solid var(--border);border-radius:14px}
  .si-seg button{display:flex;align-items:center;justify-content:center;gap:8px;min-height:48px;border:0;border-radius:11px;background:transparent;color:var(--text-2);font-size:15px;font-weight:800;cursor:pointer;font-family:inherit}
  .si-seg button.on{background:var(--bg-card);color:#C8102E;box-shadow:0 1px 3px rgba(22,24,29,.14)}
  .si-lbl{display:block;font-size:14px;font-weight:700;color:var(--text-2);margin-bottom:6px}
  .si-in{width:100%;min-height:56px;padding:0 16px;border:1px solid var(--border-strong);border-radius:14px;background:var(--bg-input);color:var(--text);font-size:18px;font-family:inherit}
  .si-in:focus{outline:3px solid rgba(200,16,46,.25);border-color:#C8102E}
  .si-in.si-id{font-size:22px;font-weight:700;letter-spacing:.12em}
  .si-in.si-pin{font-size:22px;font-weight:700;letter-spacing:.3em}
  .si-hint{display:flex;gap:8px;padding:10px 12px;border-radius:12px;font-size:14px;font-weight:600;line-height:1.4;color:#163E91;background:#E6EDFB}
  [data-theme="dark"] .si-hint{color:#BFD3FF;background:#16243F}
  .si-go{display:flex;align-items:center;justify-content:center;gap:8px;width:100%;min-height:58px;border:0;border-radius:14px;background:#C8102E;color:#fff;font-size:18px;font-weight:800;cursor:pointer;font-family:inherit}
  .si-go:active{transform:scale(.99)}
  .si-note{display:flex;gap:10px;padding:0 4px;font-size:13px;color:var(--text-2);line-height:1.45}
  .si-small{font-size:13px;color:var(--text-2);text-align:center;line-height:1.45}
  .si-build{text-align:center;font-size:11px;color:var(--text-3);opacity:.7}
'''
i = t.index('</style>'); t = t[:i] + CSS + t[i:]

OLD_LOGIN_START = '<div class="screen active" id="screen-login">'
OLD_LOGIN_END = '<!-- ============ NPO GROUP LOGIN ============ -->'
a = t.index(OLD_LOGIN_START); b = t.index(OLD_LOGIN_END)
old = t[a:b]
for must in ['id="login-empid"', 'id="login-lastname"', 'id="login-secret-label"', 'id="smart-login-role"', 'id="login-submit-btn"', 'id="build-tag"']:
    assert must in old, must
NEW_LOGIN = f'''<div class="screen active" id="screen-login">
  <div class="si-bar"></div>
  <div class="si-top">
    <span class="si-mark"><span class="si-logo">{HOUSE}</span><span><b>Stadium Ops</b><small>aramark · game day</small></span></span>
    <button class="si-icon theme-toggle" onclick="toggleTheme()" title="Toggle theme" aria-label="Toggle light/dark theme">{MOON}</button>
  </div>
  <div class="si-main">
    <div><h1 class="si-h1">Sign in</h1><p class="si-lead">Start your shift with your ID and last name.</p></div>
    <div class="si-card">
      <div class="si-seg" role="tablist" aria-label="Who is signing in">
        <button role="tab" aria-selected="true" class="on" type="button">{EMP}<span>Employee</span></button>
        <button role="tab" aria-selected="false" type="button" onclick="goNpoLogin()">{GRP}<span>NPO group</span></button>
      </div>
      <div><label class="si-lbl" for="login-empid">Employee ID · last 5 digits</label>
      <input class="si-in si-id" type="tel" inputmode="numeric" pattern="[0-9]*" id="login-empid" placeholder="65764" maxlength="5" autocomplete="off" oninput="scLoginLabel()"></div>
      <div><label class="si-lbl" id="login-secret-label" for="login-lastname">Last Name or Personal PIN</label>
      <input class="si-in" type="text" id="login-lastname" placeholder="e.g. Smith" autocomplete="off"></div>
      <div class="si-hint" id="si-login-hint" style="display:none"></div>
      <div class="smart-login-role" id="smart-login-role"></div>
      <button class="si-go" id="login-submit-btn" onclick="doLogin()">Sign in {ARROW}</button>
    </div>
    <div class="si-note">{CLOCK}<span>This app tracks your stand. Use the stadium clock-in machine for paid hours.</span></div>
    <div class="si-build" id="build-tag"></div>
  </div>
</div>

'''
t = t[:a] + NEW_LOGIN + t[b:]

NPO_START = '<div class="screen" id="screen-npo-login">'
NPO_END = '<!-- ============ NPO STAND PICKER'
a = t.index(NPO_START); b = t.index(NPO_END)
old = t[a:b]
for must in ['id="npo-group-select"', 'id="npo-group-name"', 'id="npo-pin"', 'id="npo-member-name"', 'id="npo-name-choices"', 'onclick="doNpoLogin()"']:
    assert must in old, must
NEW_NPO = f'''<div class="screen" id="screen-npo-login">
  <div class="si-bar"></div>
  <div class="si-top">
    <span class="si-mark"><span class="si-logo">{HOUSE}</span><span><b>Stadium Ops</b><small>aramark · game day</small></span></span>
    <button class="si-icon theme-toggle" onclick="toggleTheme()" title="Toggle theme" aria-label="Toggle light/dark theme">{MOON}</button>
  </div>
  <div class="si-main">
    <div><h1 class="si-h1">Sign in</h1><p class="si-lead">Volunteer groups sign in with the group PIN.</p></div>
    <div class="si-card">
      <div class="si-seg" role="tablist" aria-label="Who is signing in">
        <button role="tab" aria-selected="false" type="button" onclick="showScreen('screen-login')">{EMP}<span>Employee</span></button>
        <button role="tab" aria-selected="true" class="on" type="button">{GRP}<span>NPO group</span></button>
      </div>
      <div><label class="si-lbl" for="npo-group-name">Your group</label>
      <select class="si-in" id="npo-group-select" style="display:none">
        <option value="">— Tap to pick your group —</option>
      </select>
      <input class="si-in" type="text" id="npo-group-name" placeholder="Loading groups…" autocomplete="off"></div>
      <div><label class="si-lbl" for="npo-pin">Group PIN · 4 digits</label>
      <input class="si-in si-pin" type="tel" inputmode="numeric" pattern="[0-9]*" id="npo-pin" placeholder="••••" maxlength="4" autocomplete="off"></div>
      <div><label class="si-lbl" for="npo-member-name">Your name</label>
      <input class="si-in" type="text" id="npo-member-name" placeholder="First or last name is fine" autocomplete="off">
      <div id="npo-name-choices" style="display:none"></div></div>
      <button class="si-go" onclick="doNpoLogin()">Sign in with group {ARROW}</button>
      <p class="si-small">Your group leader has the PIN.</p>
    </div>
    <p class="si-small">At a main stand, the NPO Lead signs in and runs attendance. At a portable stand, members can sign in themselves only when Admin has turned that stand on.</p>
  </div>
</div>

'''
t = t[:a] + NEW_NPO + t[b:]

OLD_LBL = """function scLoginLabel(){
  const v=(document.getElementById('login-empid')||{}).value||'';
  const l=document.getElementById('login-secret-label'),i=document.getElementById('login-lastname');
  if(!l||!i)return;
  if(v==='50000'){l.textContent='Your stand number or login word';i.placeholder='e.g. 205 or 219 chick';}
  else{l.textContent='Last Name or Personal PIN';i.placeholder='Last name or personal PIN';}
}"""
NEW_LBL = """function scLoginLabel(){
  const v=(document.getElementById('login-empid')||{}).value||'';
  const l=document.getElementById('login-secret-label'),i=document.getElementById('login-lastname');
  if(!l||!i)return;
  if(v==='50000'){l.textContent='Your stand number or login word';i.placeholder='e.g. 205 or 219 chick';}
  else{l.textContent='Last Name or Personal PIN';i.placeholder='e.g. Smith';}
  // fix-174: small hint for the shared sign-in IDs
  const h=document.getElementById('si-login-hint');
  if(h){const H={'50000':'Subcontractor stand: type your stand number or login word.','60000':'Warehouse: type your last name.','70000':'Premium: type your last name.'}[v]||'';
    h.textContent=H;h.style.display=H?'':'none';}
}"""
rep(OLD_LBL, NEW_LBL)
t = re.sub(r"BUILD_TAG = '2026-11-2\d-fix-17\d'", "BUILD_TAG = '2026-11-28-fix-174'", t, count=1)
assert "BUILD_TAG = '2026-11-28-fix-174'" in t
open(path, 'w', encoding='utf-8').write(t)
print('ok', path)
