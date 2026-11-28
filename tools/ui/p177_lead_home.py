"""fix-177: stand lead / supervisor / worker home + Checks + Requests = approved mockups (Lead, Supervisor, Checks, Requests).
Same ids and functions. New: slim runners line, line icons, Report an app problem (table app_problem_reports)."""
import sys, re
path = sys.argv[1]; t = open(path, encoding='utf-8').read()
def rep(old, new, cnt=1):
    global t
    n = t.count(old)
    if n != cnt: raise SystemExit(f'anchor count {n}: {old[:90]!r}')
    t = t.replace(old, new)

SV = lambda d, w=24: f'<svg width="{w}" height="{w}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">{d}</svg>'
IC = {
 'checks': SV('<rect x="5" y="3" width="14" height="18" rx="2"/><path d="M9 3v2h6V3M9 11l2 2 4-4M9 17h6"/>'),
 'req': SV('<path d="M3 8l9-5 9 5v8l-9 5-9-5z"/><path d="M3 8l9 5 9-5M12 13v8"/>'),
 'food': SV('<path d="M10 14V5a2 2 0 1 1 4 0v9"/><circle cx="12" cy="17.5" r="3.5"/><path d="M12 14v3.5"/>'),
 'team': SV('<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.8-3.5 3.4-5.5 6.5-5.5s5.7 2 6.5 5.5"/><circle cx="17" cy="9" r="2.5"/><path d="M16.5 14.6c2.6.3 4.4 2.1 5 5.4"/>'),
 'live': SV('<path d="M4 20V10M10 20V4M16 20v-7M22 20H2"/>', 22),
 'status': SV('<rect x="5" y="3" width="14" height="18" rx="2"/><path d="M9 8h6M9 12h6M9 16h4"/>', 22),
 'xfer': SV('<path d="M4 8h13l-3-3M20 16H7l3 3"/>', 22),
 'play': '<svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M8 5v14l11-7z"/></svg>',
 'pause': SV('<path d="M9 5v14M15 5v14"/>', 22),
 'stop': SV('<rect x="6" y="6" width="12" height="12" rx="2"/>', 22),
 'back': SV('<path d="M5 12l5 5 9-10"/>', 22),
 'bug': SV('<path d="M8 6V4h8v2"/><rect x="5" y="6" width="14" height="14" rx="6"/><path d="M12 10v6M5 12H2M22 12h-3"/>', 22),
 'pin': SV('<path d="M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>', 20),
 'cal': SV('<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4"/>', 22),
 'moon': SV('<path d="M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z"/>', 20),
 'bell': SV('<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10 21h4"/>', 20),
 'truck': SV('<path d="M3 7h11v9H3z"/><path d="M14 10h4l3 3v3h-7z"/><circle cx="7" cy="18" r="2"/><circle cx="17" cy="18" r="2"/>', 14),
 'chef': SV('<path d="M6 13a4 4 0 1 1 2-7.5A4 4 0 0 1 16 5.5 4 4 0 1 1 18 13v6H6z"/>', 14),
}

CSS = '''
  /* fix-177: lead / supervisor / worker home = approved mockup */
  #screen-home .brand-header{display:none}
  #lh-top{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:calc(env(safe-area-inset-top) + 14px) 16px 14px;background:var(--bg-card);border-bottom:1px solid var(--border);position:sticky;top:0;z-index:40}
  #lh-top .lh-brand{font-size:18px;font-weight:800;letter-spacing:-.01em;color:var(--text)}
  #lh-top .lh-brand b{color:#C8102E}#lh-top .lh-brand span{font-size:14px;font-weight:700;color:#C8102E}
  #lh-top .lh-sub{display:block;font-size:12px;font-weight:600;color:var(--text-2);margin-top:2px}
  #lh-top .lh-acts{display:flex;gap:8px}
  #lh-top .lh-brand{white-space:nowrap}
  body:has(#screen-home.active) #conn-indicator{top:auto!important;bottom:calc(env(safe-area-inset-bottom) + 14px)!important;left:12px!important;right:auto!important}
  #lh-top .lh-ib{width:44px;height:44px;border:1px solid var(--border);background:var(--bg-card);color:var(--text);border-radius:12px;display:flex;align-items:center;justify-content:center;cursor:pointer}
  #screen-home .content{max-width:720px;margin:0 auto;width:100%;padding:14px 16px 28px}
  #screen-home .gameday-banner{background:#7A0F22;border:0;border-left:0;border-radius:18px;padding:16px}
  #screen-home .gameday-banner #gameday-banner-collapsed > div:first-child > div:first-child,#screen-home .gameday-banner #gameday-banner-expanded > div:first-child{color:#F6C9D1;opacity:1;letter-spacing:.02em;text-transform:none;font-size:12px}
  #screen-home .gameday-banner #gameday-banner-title,#screen-home .gameday-banner #gameday-expanded-title{font-size:18px}
  #screen-home .gameday-banner button{min-height:46px;border-radius:12px!important;font-size:15px!important;font-weight:800!important}
  #screen-home .gameday-banner button:first-child{background:#FFC72C!important;color:#16181D!important}
  #screen-home .gameday-banner button:last-child{background:transparent!important;border:1px solid rgba(255,255,255,.35)!important}
  #screen-home .stand-card{border-radius:16px;padding:16px;box-shadow:none}
  #screen-home .stand-card::before{display:none}
  #screen-home .stand-card .greeting-line{font-size:15px}
  #screen-home .stand-card .full-name{font-size:20px;font-weight:800;margin-bottom:10px}
  #lh-stand{display:flex;align-items:center;gap:12px;padding:12px;background:var(--bg-elevated);border-radius:12px}
  #lh-stand .lh-pin{width:40px;height:40px;border-radius:10px;background:var(--bg-card);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;flex-shrink:0;color:var(--text)}
  #screen-home .stand-card .label{text-transform:none;letter-spacing:0;font-size:12px;font-weight:700}
  #screen-home .stand-card .stand-name{font-size:18px;font-weight:800}
  #screen-home .stand-card .shift-time{margin-top:2px;font-size:13px}
  #screen-home .role-badge{font-size:12px;font-weight:800;text-transform:none;letter-spacing:0;border-radius:999px;padding:5px 10px}
  #screen-home .role-badge.lead,#screen-home .role-badge.supervisor{background:#FDECEE;color:#8E0E22}
  [data-theme="dark"] #screen-home .role-badge.lead,[data-theme="dark"] #screen-home .role-badge.supervisor{background:rgba(200,16,46,.2);color:#FFB3BE}
  #screen-home .role-scope{border:0;background:none;padding:4px 0 0;font-size:13px;color:var(--text-2)}
  #screen-home .working-stand-control{border-radius:12px}
  #screen-home .working-stand-control select{min-height:48px;font-size:15px;border-radius:12px}
  #screen-home .status-bar{border-radius:12px;font-size:14px;padding:12px 14px}
  #screen-home #worker-actions .big-action{border-radius:16px;min-height:64px;display:flex;align-items:center;gap:14px}
  #screen-home #worker-actions .big-action.primary{background:#C8102E;border-color:#C8102E;min-height:72px}
  #screen-home #worker-actions .big-action .icon{width:44px;height:44px;border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0}
  #screen-home #worker-actions .big-action.primary .icon{background:rgba(255,255,255,.18);color:#fff}
  #screen-home #worker-actions .big-action.warning,#screen-home #worker-actions .big-action.danger{background:var(--bg-card);border:1px solid var(--border-strong);color:var(--text)}
  #screen-home #worker-actions .big-action.warning .sub,#screen-home #worker-actions .big-action.danger .sub{color:var(--text-2)}
  #screen-home #worker-actions .big-action.warning .icon{background:#FDF1E3;color:#8A4205}
  #screen-home #worker-actions .big-action.danger .icon{background:#FDECEE;color:#8E0E22}
  #screen-home #worker-actions .big-action .text>div:first-child{font-size:17px;font-weight:800}
  #home-runners.lh-runners{display:flex!important;align-items:center;gap:8px;flex-wrap:wrap;padding:2px 4px!important;background:none!important;border:0!important;box-shadow:none!important;font-size:13px;color:var(--text-2);margin:0 0 10px}
  .lh-rc{display:inline-flex;align-items:center;gap:6px;padding:5px 10px;border-radius:999px;background:var(--bg-card);border:1px solid var(--border);font-weight:700}
  .lh-rc.wh{color:#163E91}.lh-rc.fd{color:#8A4205}
  [data-theme="dark"] .lh-rc.wh{color:#9DB8FF}[data-theme="dark"] .lh-rc.fd{color:#F7C58A}
  #screen-home .action-tiles{gap:10px}
  #screen-home .action-tile{display:flex;flex-direction:column;align-items:flex-start;gap:8px;padding:14px;min-height:150px;text-align:left;border-radius:16px;box-shadow:none;background:var(--bg-card)!important;border:1px solid var(--border)!important}
  #screen-home .action-tile .tile-label,#screen-home .action-tile .tile-sub{color:inherit}
  #screen-home .action-tile .tile-label{font-size:17px;font-weight:800;color:var(--text)!important}
  #screen-home .action-tile .tile-sub{font-size:13px;line-height:1.35;color:var(--text-2)!important;margin:0}
  #screen-home .action-tile .tile-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:0;margin:0}
  #screen-home .lh-ic-checks{background:#E8F5EC;color:#166534}#screen-home .lh-ic-req{background:#FDECEE;color:#C8102E}
  #screen-home .lh-ic-food{background:#FDF1E3;color:#8A4205}#screen-home .lh-ic-team{background:#E6EDFB;color:#163E91}
  [data-theme="dark"] #screen-home .lh-ic-checks{background:rgba(22,163,74,.18);color:#7EE2A0}[data-theme="dark"] #screen-home .lh-ic-req{background:rgba(200,16,46,.2);color:#FF8A9C}
  [data-theme="dark"] #screen-home .lh-ic-food{background:rgba(217,119,6,.18);color:#F7C58A}[data-theme="dark"] #screen-home .lh-ic-team{background:rgba(59,130,246,.18);color:#9DB8FF}
  #screen-home .tile-badge{position:static;align-self:flex-start;background:#C8102E;border-radius:999px;padding:4px 10px;font-size:12px;font-weight:800}
  #screen-home #supervisor-actions .section-title{font-size:13px;font-weight:800;color:var(--text-2);letter-spacing:.02em;text-transform:none}
  #screen-home #supervisor-actions .big-action{display:flex;align-items:center;gap:12px;border-radius:16px;border-left:1px solid var(--border)!important;min-height:68px;padding:12px 14px}
  #screen-home #supervisor-actions .big-action .icon{width:40px;height:40px;border-radius:12px;background:#E6EDFB;color:#163E91;display:flex;align-items:center;justify-content:center;font-size:0}
  [data-theme="dark"] #screen-home #supervisor-actions .big-action .icon{background:rgba(59,130,246,.18);color:#9DB8FF}
  #screen-home #supervisor-actions .big-action .text>div:first-child{font-size:16px;font-weight:800}
  #lh-bug{display:flex;align-items:center;gap:12px;width:100%;min-height:64px;padding:10px 14px;margin-top:12px;background:var(--bg-card);border:1px dashed var(--border-strong);border-radius:16px;cursor:pointer;text-align:left;font-family:inherit;color:var(--text)}
  #lh-bug .bi{width:40px;height:40px;border-radius:12px;background:#F3EAFB;color:#5B2A86;display:flex;align-items:center;justify-content:center;flex-shrink:0}
  [data-theme="dark"] #lh-bug .bi{background:rgba(124,58,237,.2);color:#D8BFFF}
  #lh-bug b{display:block;font-size:16px;font-weight:800}#lh-bug small{font-size:13px;color:var(--text-2)}
  #lh-bug-sheet{position:fixed;inset:0;z-index:9500;background:rgba(22,24,29,.45);display:flex;flex-direction:column;justify-content:flex-end}
  #lh-bug-sheet section{width:min(560px,100%);margin:0 auto;background:var(--bg-card);color:var(--text);border-radius:22px 22px 0 0;padding:18px 16px calc(24px + env(safe-area-inset-bottom));display:flex;flex-direction:column;gap:12px}
  #lh-bug-sheet .bt{display:flex;gap:8px;flex-wrap:wrap}
  #lh-bug-sheet .bt button{min-height:44px;padding:8px 16px;border-radius:999px;font-size:15px;font-weight:700;cursor:pointer;background:var(--bg-card);color:var(--text);border:1px solid var(--border-strong);font-family:inherit}
  #lh-bug-sheet .bt button.on{background:#16181D;color:#fff;border-color:#16181D}
  #lh-bug-sheet textarea{padding:12px;border:1px solid var(--border-strong);border-radius:12px;font-size:16px;resize:none;background:var(--bg-input);color:var(--text);font-family:inherit}
  #lh-bug-sheet .go{min-height:52px;border:0;border-radius:14px;background:#C8102E;color:#fff;font-size:16px;font-weight:800;cursor:pointer;font-family:inherit}
  /* Checks screen (mockup) */
  #screen-submenu-checks .content{max-width:720px;margin:0 auto;width:100%}
  #screen-submenu-checks .chk-progress{background:var(--bg-card);border-radius:16px;padding:14px;font-size:15px}
  #screen-submenu-checks .chk-step{border-radius:18px;padding:14px}
  #screen-submenu-checks .chk-step-t{font-size:17px;font-weight:800}
  #screen-submenu-checks .chk-task{border-radius:16px;min-height:76px;padding:12px 14px;background:var(--bg-card)}
  #screen-submenu-checks .chk-task.next{border:2px solid #C8102E}
  #screen-submenu-checks .chk-task.ok{border-color:#BFE3CB;background:var(--bg-card)}
  #screen-submenu-checks .chk-task.chk-opt{border-style:dashed}
  #screen-submenu-checks .chk-tl{font-size:16px;font-weight:800}
  #screen-submenu-checks .chk-ic{width:44px;height:44px;border-radius:12px;background:var(--bg-elevated);display:flex;align-items:center;justify-content:center;font-size:20px}
  #screen-submenu-checks .chk-task.ok .chk-ic{background:#16A34A;color:#fff}
  /* Requests hub (mockup) */
  #screen-submenu-requests .content{max-width:720px;margin:0 auto;width:100%}
  #screen-submenu-requests .sub-menu-btn{border-radius:16px;min-height:76px;box-shadow:none;border-left-width:1px!important;border-left-color:var(--border)!important}
  #screen-submenu-requests .sub-menu-btn .smb-icon{width:48px;height:48px;border-radius:14px;background:var(--bg-elevated);display:flex;align-items:center;justify-content:center;font-size:24px}
  #screen-submenu-requests .sub-menu-btn .smb-label{font-size:16px;font-weight:800}
  #screen-submenu-requests .sub-menu-btn .smb-sub{font-size:13px}
  #screen-submenu-requests .sub-menu-btn.req-hub-main{background:#C8102E;border:0!important;color:#fff;padding:16px;min-height:96px}
  #screen-submenu-requests .sub-menu-btn.req-hub-main .smb-label,#screen-submenu-requests .sub-menu-btn.req-hub-main .smb-sub{color:#fff}
  #screen-submenu-requests .sub-menu-btn.req-hub-main .smb-sub{color:#FBE3E7}
  #screen-submenu-requests .sub-menu-btn.req-hub-main .smb-icon{background:rgba(255,255,255,.16)}
  #screen-submenu-requests .req-hub-tag{background:rgba(255,255,255,.2);color:#fff}
  #screen-submenu-requests .request-primary-note{font-size:13px;font-weight:800;color:var(--text-2);text-transform:none;letter-spacing:0}
'''
i = t.index('</style>'); t = t[:i] + CSS + t[i:]

# --- home markup: new header, stand block, tile icons, supervisor row icons, report-problem button
rep('''<div class="screen" id="screen-home">
  <div class="brand-header">''', f'''<div class="screen" id="screen-home">
  <div id="lh-top"><span><span class="lh-brand">aramark <b>·</b> <span id="lh-role">Stand</span></span><span class="lh-sub" id="lh-date"></span></span>
    <div class="lh-acts"><button class="lh-ib" onclick="toggleTheme()" aria-label="Toggle light/dark theme">{IC['moon']}</button><button class="lh-ib" onclick="requestPushPermission()" aria-label="Turn on alerts">{IC['bell']}</button></div></div>
  <div class="brand-header">''')
rep('''      <div class="label" id="home-stand-label">Your stand today</div>
      <div class="stand-name" id="home-stand">—</div>
      <div class="shift-time" id="home-time">—</div>''', f'''      <div id="lh-stand"><span class="lh-pin">{IC['pin']}</span><span>
      <div class="label" id="home-stand-label">Your stand today</div>
      <div class="stand-name" id="home-stand">—</div>
      <div class="shift-time" id="home-time">—</div></span></div>''')
for emoji, key, cls, lbl in [('📋', 'checks', 'checks', '<div class="tile-label">Checks</div>'), ('📦', 'req', 'req', '<div class="tile-label">Requests</div>'), ('🌡️', 'food', 'food', '<div class="tile-label">Food Safety</div>'), ('👥', 'team', 'team', '<div class="tile-label" id="myteam-tile-label">My Team</div>')]:
    rep(f'<span class="tile-icon">{emoji}</span>\n          {lbl}', f'<span class="tile-icon lh-ic-{cls}">{IC[key]}</span>\n          {lbl}')
rep('''        <span class="icon">📊</span>
        <span class="text"><div>All Stands Live</div>''', f'''        <span class="icon">{IC['live']}</span>
        <span class="text"><div>All Stands Live</div>''')
rep('''        <span class="icon">📋</span>
        <span class="text"><div>Stand Status</div>''', f'''        <span class="icon">{IC['status']}</span>
        <span class="text"><div>Stand Status</div>''')
rep('''        <span class="icon">🔄</span>
        <span class="text"><div>Stand Transfer Record</div>''', f'''        <span class="icon">{IC['xfer']}</span>
        <span class="text"><div>Stand Transfer Record</div>''')
rep('''    <div style="margin-top:24px;text-align:center">
      <button onclick="logout()" style="background:none;border:none;color:var(--text-3);font-size:13px;cursor:pointer;text-decoration:underline">Sign out</button>''',
 f'''    <button id="lh-bug" type="button" onclick="lhBugOpen()"><span class="bi">{IC['bug']}</span><span style="flex:1"><b>Report an app problem</b><small>Something broken, slow or confusing? Tell us.</small></span></button>
    <div style="margin-top:24px;text-align:center">
      <button onclick="logout()" style="background:none;border:none;color:var(--text-3);font-size:13px;cursor:pointer;text-decoration:underline">Sign out</button>''')

# --- Start / Break / Leave buttons: line icons instead of emoji (same buttons, same onclick)
for old, new in [('<span class="icon">🟢</span>', '<span class="icon">' + IC['play'] + '</span>'), ('<span class="icon">☕</span>', '<span class="icon">' + IC['pause'] + '</span>'),
                 ('<span class="icon">🔴</span>', '<span class="icon">' + IC['stop'] + '</span>'), ('<span class="icon">✅</span>\n      <span class="text"><div>Back from break</div>', '<span class="icon">' + IC['back'] + '</span>\n      <span class="text"><div>Back from break</div>')]:
    n = t.count(old)
    if n == 0: raise SystemExit('missing ' + old)
    t = t.replace(old, new)

# --- header text follows the role
rep('''  renderRoleHomeUX(u);
  { const sc=!!u.isSubcontractor''', '''  renderRoleHomeUX(u);
  lhHeader(u);   // fix-177
  { const sc=!!u.isSubcontractor''')

# --- slim runners line (you asked to drop the big card)
rep('''  el.style.display='';
  el.innerHTML='<div style="font-weight:850;font-size:13px;margin-bottom:4px">👥 Your runners today · '+escapeHtml(stand)+'</div>'+''',
    '''  el.style.display='';
  { // fix-177: one slim line instead of the big card
    const nm=a=>a&&a.length?a.map(p=>String(p.name||'').split(',').reverse().join(' ').trim().split(' ')[0]).filter(Boolean).join(', '):'any';
    el.className='lh-runners';
    el.innerHTML='<span style="font-weight:700">Runners</span><span class="lh-rc wh">'+%TRUCK%+' Warehouse · '+escapeHtml(nm(m.warehouse))+'</span><span class="lh-rc fd">'+%CHEF%+' Food · '+escapeHtml(nm(m.food))+'</span>';
    return; }
  el.innerHTML='<div style="font-weight:850;font-size:13px;margin-bottom:4px">👥 Your runners today · '+escapeHtml(stand)+'</div>'+'''.replace('%TRUCK%', repr(IC['truck'])).replace('%CHEF%', repr(IC['chef'])))

JS = r'''
// ── fix-177: lead / supervisor home header + Report an app problem ──
function lhHeader(u) {
  const r = document.getElementById('lh-role'), d = document.getElementById('lh-date'); if (!r || !u) return;
  r.textContent = u.isSubcontractor ? 'Subcontractor stand' : u.isNpo ? (u.npoCanManageTeam ? 'NPO lead' : 'NPO') : u.role === 'supervisor' ? 'Supervisor' : u.role === 'lead' ? 'Stand lead' : 'Stand worker';
  const g = document.getElementById('home-game-date'); if (d) d.textContent = g ? g.textContent : '';
}
let _lhBugKind = 'Something broke';
function lhBugOpen() {
  lhBugClose();
  const ov = document.createElement('div'); ov.id = 'lh-bug-sheet'; ov.onclick = e => { if (e.target === ov) lhBugClose(); };
  const kinds = ['Something broke', 'Too slow', 'Confusing', 'Idea'];
  ov.innerHTML = '<section role="dialog" aria-label="Report an app problem"><span style="font-size:18px;font-weight:800">Report an app problem</span>' +
    '<div class="bt">' + kinds.map(k => '<button type="button" class="' + (k === _lhBugKind ? 'on' : '') + '" onclick="_lhBugKind=this.textContent;this.parentNode.querySelectorAll(\'button\').forEach(b=>b.classList.toggle(\'on\',b===this))">' + k + '</button>').join('') + '</div>' +
    '<label for="lh-bug-text" style="font-size:14px;font-weight:700">What happened?</label><textarea id="lh-bug-text" rows="3" maxlength="1000" placeholder="e.g. Count Out froze after I tapped Save"></textarea>' +
    '<button type="button" class="go" id="lh-bug-send" onclick="lhBugSend()">Send to Admin</button></section>';
  document.body.appendChild(ov);
}
function lhBugClose() { const s = document.getElementById('lh-bug-sheet'); if (s) s.remove(); }
async function lhBugSend() {
  const note = String((document.getElementById('lh-bug-text') || {}).value || '').trim();
  if (!note) return toast('Type what happened first', 'error');
  const u = state.user || {}, s = state.staffAccount || {};
  const btn = document.getElementById('lh-bug-send'); if (btn) { btn.disabled = true; btn.textContent = 'Sending…'; }
  const r = await sb('app_problem_reports', { method: 'POST', headers: { Prefer: 'return=minimal' }, body: JSON.stringify({
    employee_id: u.empId || s.empId || '', name: u.name || s.name || '', role: u.role || s.role || '', stand: u.stand || '', kind: _lhBugKind, note,
    screen: state.currentScreen || '', build_tag: (typeof BUILD_TAG !== 'undefined' ? BUILD_TAG : ''), user_agent: String(navigator.userAgent || '').slice(0, 300) }) }).catch(() => ({ _err: true }));
  if (r && r._err) { if (btn) { btn.disabled = false; btn.textContent = 'Send to Admin'; } return toast('Could not send — check signal and try again', 'error'); }
  lhBugClose(); toast('Thanks, we got it. Admin sees your report.');
}
'''
rep("function renderGameDayInfo(){", JS + "\nfunction renderGameDayInfo(){")
t2 = re.sub(r"BUILD_TAG = '2026-11-2\d-fix-17\d'", "BUILD_TAG = '2026-11-28-fix-177'", t, count=1)
assert t2 != t; t = t2
open(path, 'w', encoding='utf-8').write(t); print('ok', path)
