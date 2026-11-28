"""fix-176: warehouse manager/supervisor home rebuilt to the approved mockup (Main.dc.html).
New Today view, header with Live + menu, bottom bar (Today / Deliveries / Carts / Team), menu drawer.
Every button calls the SAME existing functions; old tiles stay in the page (hidden) so nothing that
references them breaks. Workers' screen is unchanged."""
import sys, re
path = sys.argv[1]; t = open(path, encoding='utf-8').read()
def rep(old, new, cnt=1):
    global t
    n = t.count(old)
    if n != cnt: raise SystemExit(f'anchor count {n}: {old[:90]!r}')
    t = t.replace(old, new)

CSS = r'''
  /* fix-176: warehouse leader home = approved mockup */
  #screen-warehouse.wx-on .brand-header,#screen-warehouse.wx-on #wh-role-summary,#screen-warehouse.wx-on #wh-rs-give-btn,
  #screen-warehouse.wx-on #wh-first-game-help,#screen-warehouse.wx-on #wh-live-strip,#screen-warehouse.wx-on #wh-mgr-tools-btn{display:none!important}
  #screen-warehouse.wx-on .content{padding:16px 16px calc(104px + env(safe-area-inset-bottom));max-width:1080px;margin:0 auto;width:100%}
  #wx-top{display:none}
  #screen-warehouse.wx-on #wx-top{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:calc(env(safe-area-inset-top) + 14px) max(16px, calc((100% - 1080px) / 2 + 16px)) 12px;background:var(--bg-card);border-bottom:1px solid var(--border);position:sticky;top:0;z-index:50}
  #wx-top .wx-k{font-size:13px;font-weight:600;color:#C8102E}
  #wx-top .wx-t{font-size:20px;font-weight:800;letter-spacing:-.01em;color:var(--text)}
  #wx-top .wx-r{display:flex;align-items:center;gap:8px}
  .wx-live{display:flex;align-items:center;gap:6px;font-size:13px;font-weight:600;color:#166534;background:#E8F5EC;padding:6px 10px;border-radius:999px}
  .wx-live i{width:8px;height:8px;border-radius:50%;background:#16A34A}
  .wx-live.off{color:#8E0E22;background:#FDECEE}.wx-live.off i{background:#B4122B}
  .wx-ib{width:44px;height:44px;border:1px solid var(--border);background:var(--bg-card);color:var(--text);border-radius:12px;display:flex;align-items:center;justify-content:center;cursor:pointer}
  body:has(#screen-warehouse.active.wx-on) #conn-indicator{display:none!important}
  body:has(#screen-warehouse.active.wx-on) .float-contact,body:has(#screen-warehouse.active.wx-on) .float-sos{bottom:calc(92px + env(safe-area-inset-bottom))}
  #wx-today{display:flex;flex-direction:column;gap:16px}
  .wx-line{font-size:14px;color:var(--text-2)}
  .wx-tiles{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:6px}
  .wx-tile{display:flex;flex-direction:column;align-items:flex-start;gap:2px;padding:10px;border-radius:14px;cursor:pointer;text-align:left;background:var(--bg-card);border:1px solid var(--border);font-family:inherit}
  .wx-tile b{font-size:26px;font-weight:800;font-variant-numeric:tabular-nums;line-height:1.15}
  .wx-tile span{font-size:12px;font-weight:700;color:var(--text-2)}
  .wx-tile.late.hot{background:#FDECEE;border-color:#F3C9CF}.wx-tile.late.hot span{color:#8E0E22}
  [data-theme="dark"] .wx-tile.late.hot{background:rgba(220,38,38,.18);border-color:rgba(220,38,38,.4)}[data-theme="dark"] .wx-tile.late.hot span{color:#FFB3BE}
  .wx-stat{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:12px 14px;background:var(--bg-card);border:1px solid var(--border);border-radius:14px}
  .wx-stat small{display:block;font-size:13px;font-weight:600;color:var(--text-2)}
  .wx-stat strong{font-size:20px;font-weight:800;font-variant-numeric:tabular-nums;color:var(--text)}
  .wx-stat em{font-style:normal;font-size:14px;font-weight:600;color:var(--text-2)}
  .wx-sign{display:flex;align-items:center;justify-content:space-between;gap:10px;padding:12px 14px;border-radius:14px;background:#E6EDFB;color:#163E91;font-weight:700;font-size:14px;border:0;cursor:pointer;text-align:left;font-family:inherit}
  [data-theme="dark"] .wx-sign{background:rgba(59,130,246,.18);color:#BFD3FF}
  .wx-h{display:flex;align-items:baseline;justify-content:space-between}
  .wx-h h2{font-size:16px;font-weight:700;color:var(--text)}
  .wx-link{border:0;background:none;color:#1D4FB8;font-size:14px;font-weight:600;cursor:pointer;padding:8px 0;min-height:44px;font-family:inherit}
  [data-theme="dark"] .wx-link{color:#8FB0FF}
  .wx-list{display:grid;grid-template-columns:1fr;gap:8px}
  .wx-card{display:flex;flex-direction:column;gap:8px;padding:12px 14px;background:var(--bg-card);border-radius:14px;border:1px solid var(--border)}
  .wx-card.late{border:2px solid #B4122B}
  .wx-card .r1{display:flex;align-items:center;justify-content:space-between;gap:8px}
  .wx-card .st{font-size:16px;font-weight:700;color:var(--text)}
  .wx-card .tm{font-size:13px;font-weight:700;color:var(--text-2);white-space:nowrap}
  .wx-card.late .tm{color:#B4122B}.wx-card .tm.wait{color:#9A4A06}
  .wx-card .it{font-size:14px;color:var(--text)}
  .wx-card .who{font-size:13px;color:var(--text-2)}
  .wx-send{min-height:44px;padding:0 16px;border:0;border-radius:10px;background:#C8102E;color:#fff;font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;white-space:nowrap}
  .wx-ok{padding:14px;background:#E8F5EC;border-radius:14px;color:#166534;font-size:15px;font-weight:600}
  [data-theme="dark"] .wx-ok{background:rgba(22,163,74,.16);color:#7EE2A0}
  .wx-quick{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:8px}
  .wx-q{display:flex;flex-direction:column;align-items:flex-start;gap:6px;min-height:76px;padding:12px;border-radius:14px;background:var(--bg-card);border:1px solid var(--border);cursor:pointer;color:var(--text);font-size:14px;font-weight:700;text-align:left;font-family:inherit}
  .wx-q svg{color:#C8102E}
  .wx-q small{font-size:12px;font-weight:600;color:var(--text-2)}
  #wx-nav{display:none}
  #screen-warehouse.wx-on.active #wx-nav{display:grid;position:fixed;left:0;right:0;bottom:0;z-index:60;grid-template-columns:repeat(4,minmax(0,1fr));background:var(--bg-card);border-top:1px solid var(--border);padding:6px 4px calc(10px + env(safe-area-inset-bottom))}
  #wx-nav button{position:relative;display:flex;flex-direction:column;align-items:center;gap:4px;min-height:56px;border:0;background:none;cursor:pointer;padding:6px 0;color:var(--text-2);font-size:12px;font-weight:500;font-family:inherit}
  #wx-nav button .pl{display:flex;align-items:center;justify-content:center;width:56px;height:30px;border-radius:999px}
  #wx-nav button.on{color:var(--text);font-weight:700}#wx-nav button.on .pl{background:#FDECEE;color:#C8102E}
  [data-theme="dark"] #wx-nav button.on .pl{background:rgba(200,16,46,.22);color:#FF8A9C}
  #wx-nav .bd{position:absolute;top:2px;left:54%;min-width:18px;height:18px;padding:0 5px;border-radius:9px;background:#B4122B;color:#fff;font-size:11px;font-weight:800;display:flex;align-items:center;justify-content:center}
  #wx-menu{position:fixed;inset:0;z-index:9500;background:rgba(22,24,29,.45);display:flex;justify-content:flex-end}
  #wx-menu nav{width:min(320px,88vw);height:100%;background:var(--bg-card);padding:calc(env(safe-area-inset-top) + 20px) 12px 20px;display:flex;flex-direction:column;gap:2px;overflow-y:auto}
  #wx-menu .mh{padding:14px 8px 4px;font-size:13px;font-weight:700;color:var(--text-2)}
  #wx-menu .mi{min-height:48px;padding:0 8px;border:0;border-radius:10px;background:none;color:var(--text);font-size:15px;font-weight:600;text-align:left;cursor:pointer;font-family:inherit;display:flex;align-items:center;justify-content:space-between}
  #wx-menu .mi:active{background:var(--bg-elevated)}
  #wx-menu .mi b{font-size:12px;background:#B4122B;color:#fff;border-radius:999px;padding:2px 8px}
  @media(min-width:760px){
    .wx-list{grid-template-columns:repeat(2,minmax(0,1fr))}
    .wx-tile b{font-size:32px}.wx-tile{padding:14px 16px}
    #screen-warehouse.wx-on.active #wx-nav{left:50%;right:auto;transform:translateX(-50%);width:min(640px,100%);border:1px solid var(--border);border-bottom:0;border-radius:18px 18px 0 0}
  }
'''
i = t.index('</style>'); t = t[:i] + CSS + t[i:]

# 1. keep claimed/delivered times on requests (for "Typical delivery" and "Wait to claim")
rep("""    id:r.id, timestamp:r.created_at, stand:r.stand, requestedBy:r.requested_by,""",
    """    id:r.id, timestamp:r.created_at, claimedAt:r.claimed_at||null, deliveredAt:r.delivered_at||null, stand:r.stand, requestedBy:r.requested_by,""")

# 2. leaders get the new home; workers unchanged
rep("""  // Warehouse Supervisor has the Manager's full access, so both use the
  // same home screen below.
  if (!isWhMgr && !isWhSup) return;""",
    """  // Warehouse Supervisor has the Manager's full access, so both use the
  // same home screen below.
  wxSetMode(isWhMgr || isWhSup);   // fix-176
  if (!isWhMgr && !isWhSup) return;""")
rep("""  whUpdateApprovalsTile();
  whUpdateCartTile();

  whBuildInventoryPane();""",
    """  // fix-176: the old tiles stay in the page (hidden) — other code updates them by id
  tilesSlot.innerHTML = '<div id="wx-today"></div><div id="wx-legacy" style="display:none">' + tilesSlot.innerHTML + '</div>';
  whUpdateApprovalsTile();
  whUpdateCartTile();

  whBuildInventoryPane();""")
rep("""  if (state._whLeaderPane !== 'menu') whMgrOpenPane(state._whLeaderPane || 'todeliver');
}""",
    """  // fix-176: leaders land on Today (the new home); a pane they had open stays open
  if (state._whLeaderPane && state._whLeaderPane !== 'menu') whMgrOpenPane(state._whLeaderPane); else whMgrBackToMenu();
  wxRender();
}""")
# 3. keep header/nav in step with panes
rep("""  state._whLeaderPane = mode;
  // Always switch the pane,""", """  state._whLeaderPane = mode;
  wxSyncNav();
  // Always switch the pane,""")
rep("""  state._whLeaderPane = 'menu';
  whRenderLiveStrip();
  loadWhTransfers();
}""", """  state._whLeaderPane = 'menu';
  whRenderLiveStrip();
  loadWhTransfers();
  wxSyncNav();
}""")
rep("""function whRenderLiveStrip() {
  const el = document.getElementById('wh-live-strip'); if (!el) return;""",
    """function whRenderLiveStrip() {
  try { wxRender(); } catch (e) { console.warn('wxRender', e); }   // fix-176
  const el = document.getElementById('wh-live-strip'); if (!el) return;""")

JS = r'''
// ── fix-176: warehouse leader home (approved mockup, Main.dc.html) ──
// Only draws; every button calls an existing function.
const WX_IC = {
  today: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/></svg>',
  deliv: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 7h11v9H3z"/><path d="M14 10h4l3 3v3h-7z"/><circle cx="7" cy="18" r="2"/><circle cx="17" cy="18" r="2"/></svg>',
  carts: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 5h10l2 7H4z"/><path d="M4 12h15v4H4z"/><circle cx="7" cy="18" r="2"/><circle cx="16" cy="18" r="2"/><path d="M15 5l3-2"/></svg>',
  team: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.8-3.5 3.4-5.5 6.5-5.5s5.7 2 6.5 5.5"/><circle cx="17" cy="9" r="2.5"/><path d="M16.5 14.6c2.6.3 4.4 2.1 5 5.4"/></svg>',
  menu: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 7h16M4 12h16M4 17h16"/></svg>',
  box: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 8l9-5 9 5v8l-9 5-9-5z"/><path d="M3 8l9 5 9-5M12 13v8"/></svg>',
  plus: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>',
  scan: '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7V4h3M17 4h3v3M20 17v3h-3M7 20H4v-3M7 12h10"/></svg>'
};
const WX_TITLES = { menu: 'Today', requests: 'Deliveries', cart: 'Golf carts', roster: 'Team', todeliver: 'My jobs', transfers: 'All transfers', inventory: 'Stand transfer report' };
function wxIsLeader() { const r = (state.staffAccount && state.staffAccount.role) || ''; return r === 'warehouse_manager' || r === 'warehouse_supervisor'; }
function wxSetMode(on) {
  const scr = document.getElementById('screen-warehouse'); if (!scr) return;
  scr.classList.toggle('wx-on', !!on);
  if (!on) return;
  if (!document.getElementById('wx-top')) {
    const h = document.createElement('div'); h.id = 'wx-top';
    h.innerHTML = '<div style="display:flex;flex-direction:column;gap:2px;min-width:0"><span class="wx-k" id="wx-kicker">Warehouse</span><span class="wx-t" id="wx-title">Today</span></div>' +
      '<div class="wx-r"><span class="wx-live" id="wx-live"><i></i><span>Live</span></span><button class="wx-ib" aria-label="Menu" onclick="wxMenuOpen()">' + WX_IC.menu + '</button></div>';
    scr.insertBefore(h, scr.firstChild);
  }
  if (!document.getElementById('wx-nav')) {
    const n = document.createElement('nav'); n.id = 'wx-nav'; n.setAttribute('aria-label', 'Warehouse');
    const b = (k, label, go) => '<button type="button" data-wx="' + k + '" onclick="' + go + '"><span class="pl">' + WX_IC[k] + '</span><span class="bd" id="wx-bd-' + k + '" style="display:none"></span>' + label + '</button>';
    n.innerHTML = b('today', 'Today', 'whMgrBackToMenu()') + b('deliv', 'Deliveries', "whOpenRequests('open')") + b('carts', 'Carts', "whMgrOpenPane('cart')") + b('team', 'Team', "whMgrOpenPane('roster')");
    scr.appendChild(n);
  }
  const k = document.getElementById('wx-kicker'); if (k) k.textContent = (state.staffAccount && state.staffAccount.role === 'warehouse_supervisor') ? 'Warehouse supervisor' : 'Warehouse';
  wxSyncNav();
}
function wxSyncNav() {
  if (!wxIsLeader()) return;
  const pane = state._whLeaderPane || 'menu';
  const map = { menu: 'today', requests: 'deliv', cart: 'carts', roster: 'team' };
  document.querySelectorAll('#wx-nav button').forEach(x => x.classList.toggle('on', x.dataset.wx === map[pane]));
  const tt = document.getElementById('wx-title'); if (tt) tt.textContent = WX_TITLES[pane] || 'Warehouse';
  // bottom-bar panes don't need the old back bar; tool panes keep it (← back to Today)
  const bb = document.getElementById('wh-mgr-backbar'); if (bb && pane !== 'menu') bb.style.display = map[pane] ? 'none' : 'flex';
  const live = document.getElementById('wx-live');
  if (live) { const off = navigator.onLine === false; live.classList.toggle('off', off); live.lastChild.textContent = off ? 'Offline' : 'Live'; }
}
function wxMins(a, b) { return (new Date(b).getTime() - new Date(a).getTime()) / 60000; }
function wxMedian(a) { if (!a.length) return null; const s = a.slice().sort((x, y) => x - y), m = Math.floor(s.length / 2); return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2; }
function wxItems(r) {
  const it = r.itemsJson && Array.isArray(r.itemsJson.items) ? r.itemsJson.items : [];
  if (it.length) return it.map(x => (x.itemName || x.name || '') + (x.cases || x.qty ? ' ×' + (x.cases || x.qty) : '')).filter(Boolean).join(', ');
  return String(r.items || '');
}
function wxRender() {
  if (!wxIsLeader()) return;
  const box = document.getElementById('wx-today'); if (!box) return;
  const reqs = state.wRequests || [], now = Date.now();
  const c = state._whTfCache, tfs = (c && Array.isArray(c.rows)) ? c.rows : [];
  const open = r => r.status === 'Pending' || r.status === 'On the way';
  const isLate = r => open(r) && r.etaDeadline && new Date(r.etaDeadline).getTime() < now;
  const late = reqs.filter(isLate), waiting = reqs.filter(r => r.status === 'Pending' && !isLate(r));
  const moving = reqs.filter(r => r.status === 'On the way' && !isLate(r)).length + tfs.filter(x => x.status === 'delivering').length;
  const done = reqs.filter(r => r.status === 'Fulfilled');
  const toSign = tfs.filter(x => x.status === 'delivered').length, toApprove = tfs.filter(x => x.status === 'verified').length;
  const typical = wxMedian(done.filter(r => r.deliveredAt).map(r => wxMins(r.timestamp, r.deliveredAt)).filter(m => m >= 0 && m < 600));
  const claimWait = wxMedian(reqs.filter(r => r.claimedAt).map(r => wxMins(r.timestamp, r.claimedAt)).filter(m => m >= 0 && m < 600));
  const oldestWait = waiting.concat(late.filter(r => r.status === 'Pending')).reduce((m, r) => Math.max(m, wxMins(r.timestamp, now)), 0);
  const tile = (cls, n, label, go) => '<button type="button" class="wx-tile ' + cls + (cls === 'late' && n ? ' hot' : '') + '" onclick="' + go + '"><b style="color:' + ({ late: '#B4122B', waiting: '#9A4A06', moving: '#163E91', done: '#166534' })[cls] + '">' + n + '</b><span>' + label + '</span></button>';
  const d = new Date();
  const line = d.toLocaleDateString('en-US', { weekday: 'short', month: 'numeric', day: 'numeric' }) + ' · ' + d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' }) + ' · ' + reqs.length + ' request' + (reqs.length === 1 ? '' : 's') + ' today';
  const attn = reqs.filter(r => r.status === 'Pending' || isLate(r)).sort((a, b) => (isLate(b) - isLate(a)) || (new Date(a.timestamp) - new Date(b.timestamp))).slice(0, 6);
  const card = r => {
    const lt = isLate(r), mins = Math.round(lt ? wxMins(r.etaDeadline, now) : wxMins(r.timestamp, now));
    const who = r.claimedBy ? 'On the way: ' + r.claimedBy : (r.assignedToNames && r.assignedToNames.length ? 'Sent to ' + r.assignedToNames.join(', ') : 'No one yet');
    return '<div class="wx-card' + (lt ? ' late' : '') + '"><div class="r1"><span class="st">' + escapeHtml(r.stand) + '</span><span class="tm' + (lt ? '' : ' wait') + '">' + (lt ? fmtMins(mins) + ' late' : 'waiting ' + fmtMins(mins)) + '</span></div>' +
      '<span class="it">' + escapeHtml(wxItems(r)) + '</span>' +
      '<div class="r1"><span class="who">' + escapeHtml(who) + '</span><button type="button" class="wx-send" onclick="whReassignOpen(\'' + String(r.id).replace(/'/g, '') + '\')">' + (r.status === 'On the way' ? 'Change runner' : 'Send runner') + '</button></div></div>';
  };
  box.innerHTML =
    '<div class="wx-line">' + escapeHtml(line) + '</div>' +
    '<div class="wx-tiles">' + tile('late', late.length, 'Late', "whOpenRequests('open')") + tile('waiting', waiting.length, 'Waiting', "whOpenRequests('open')") + tile('moving', moving, 'Moving', "whOpenRequests('claimed')") + tile('done', done.length, 'Done', "whOpenRequests('done')") + '</div>' +
    '<div class="wx-stat"><div><small>Typical delivery today</small><strong>' + (typical == null ? '—' : fmtMins(typical)) + ' <em>goal 20</em></strong></div><div style="text-align:right"><small>' + (claimWait == null ? 'Oldest waiting' : 'Wait to claim') + '</small><strong style="color:#9A4A06">' + fmtMins(claimWait == null ? oldestWait : claimWait) + '</strong></div></div>' +
    ((toSign + toApprove) ? '<button type="button" class="wx-sign" onclick="wxGoApprovals()"><span>' + (toSign ? toSign + ' deliver' + (toSign === 1 ? 'y' : 'ies') + ' to sign' : '') + (toSign && toApprove ? ' · ' : '') + (toApprove ? toApprove + ' to approve' : '') + '</span><span>Open ›</span></button>' : '') +
    '<section style="display:flex;flex-direction:column;gap:8px"><div class="wx-h"><h2>Get someone on these</h2><button type="button" class="wx-link" onclick="whOpenRequests(\'open\')">See all</button></div>' +
      (attn.length ? '<div class="wx-list">' + attn.map(card).join('') + '</div>' : '<div class="wx-ok">Everything is claimed and on time.</div>') + '</section>' +
    '<div class="wx-quick">' +
      '<button type="button" class="wx-q" onclick="whMgrOpenPane(\'todeliver\')">' + WX_IC.box + '<span>My jobs<br><small>Deliver yourself</small></span></button>' +
      '<button type="button" class="wx-q" onclick="whNewRequest()">' + WX_IC.plus + '<span>Request stock<br><small>For any stand</small></span></button>' +
      '<button type="button" class="wx-q" onclick="whScanToOpen()">' + WX_IC.scan + '<span>Quick Drop<br><small>Scan stand QR</small></span></button>' +
    '</div>';
  const bd = document.getElementById('wx-bd-deliv'); if (bd) { bd.textContent = late.length; bd.style.display = late.length ? '' : 'none'; }
  const ct = document.getElementById('wh-tile-cart'), bc = document.getElementById('wx-bd-carts'); if (bc) { const red = !!(ct && ct.classList.contains('tile-red')); bc.textContent = '!'; bc.style.display = red ? '' : 'none'; }
  wxSyncNav();
}
function wxGoApprovals() { const t = document.getElementById('wh-tile-approvals'); if (t && t.onclick) t.onclick(); else if (t) t.click(); else showScreen('screen-wh-approvals'); }
function wxMenuOpen() {
  wxMenuClose();
  const reqOnly = typeof whRequestsOnlyToday === 'function' && whRequestsOnlyToday();
  const c = state._whTfCache, tfs = (c && Array.isArray(c.rows)) ? c.rows : [];
  const sign = tfs.filter(x => x.status === 'delivered' || x.status === 'verified').length;
  const it = (label, go, badge) => '<button type="button" class="mi" onclick="wxMenuClose();' + go + '"><span>' + label + '</span>' + (badge ? '<b>' + badge + '</b>' : '') + '</button>';
  const ov = document.createElement('div'); ov.id = 'wx-menu'; ov.onclick = e => { if (e.target === ov) wxMenuClose(); };
  ov.innerHTML = '<nav aria-label="Warehouse menu">' +
    '<div class="mh">Game day</div>' + it('Give restock access', 'openRestockAccess()') + it('Quick Drop (scan stand QR)', 'whScanToOpen()') + it('Request stock for a stand', 'whNewRequest()') + it('My jobs', "whMgrOpenPane('todeliver')") +
    (reqOnly ? it('Stand requests', "whOpenRequests('open')") : '<div class="mh">Transfers</div>' + it('Create transfer', "showScreen('screen-wh-create-transfer')") + it('All transfers', "whMgrOpenPane('transfers')") + it('Approvals', 'wxGoApprovals()', sign || '')) +
    '<div class="mh">Plan</div>' + it('Assign areas &amp; stands', "showScreen('screen-wh-team')") + it('Stand transfer report', "whMgrOpenPane('inventory')") + it('Golf carts', "whMgrOpenPane('cart')") + it('My team (check-in)', "whMgrOpenPane('roster')") +
    '<div class="mh">This phone</div>' + it('Alerts', 'requestPushPermission()') + it('Dark mode', 'toggleTheme()') + it('Sign out', 'staffLogout()') +
    '</nav>';
  document.body.appendChild(ov);
}
function wxMenuClose() { const m = document.getElementById('wx-menu'); if (m) m.remove(); }
'''
rep("""function whRenderLiveStrip() {""", JS + "\nfunction whRenderLiveStrip() {")
# 4. Today is the leaders' home: first load + phone back gesture
rep("""  if (!isEmployee && !state._whLeadDefaulted) {
    state._whLeadDefaulted = true;
    whMgrOpenPane('todeliver');
  }""", """  if (!isEmployee && !state._whLeadDefaulted) {
    state._whLeadDefaulted = true;
    whMgrBackToMenu();   // fix-176: leaders start on Today
  }""")
rep("""    if (leader && state._whLeaderPane === 'todeliver') return; // My Jobs is home
    if (backbar && backbar.style.display !== 'none') { whMgrBackToMenu(); return; }
    if (leader && state._whLeaderPane === 'menu') { whMgrOpenPane('todeliver'); return; }""",
    """    if (leader && (state._whLeaderPane || 'menu') === 'menu') return; // fix-176: Today is home
    if (leader) { whMgrBackToMenu(); return; }
    if (backbar && backbar.style.display !== 'none') { whMgrBackToMenu(); return; }""")

t2 = re.sub(r"BUILD_TAG = '2026-11-2\d-fix-17\d'", "BUILD_TAG = '2026-11-28-fix-176'", t, count=1)
assert t2 != t; t = t2
open(path, 'w', encoding='utf-8').write(t); print('ok', path)
