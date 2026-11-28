"""fix-175 part B: warehouse + golf cart new look (CSS only, scoped). No markup or logic change."""
import sys, re
path = sys.argv[1]; t = open(path, encoding='utf-8').read()
CSS = '''
  /* fix-175: warehouse + golf cart new look (scoped; CSS only) */
  #screen-warehouse,#screen-golfcart,#screen-wh-create-transfer,#screen-wh-approvals,#screen-wh-team,#screen-transfer-stand,#screen-qr-codes{
    --wx-red:#C8102E;--wx-ink:var(--text);--wx-muted:var(--text-2);--wx-line:var(--border);
    --wx-ok:#166534;--wx-ok-bg:#E8F5EC;--wx-warn:#8A4205;--wx-warn-bg:#FDF1E3;--wx-bad:#8E0E22;--wx-bad-bg:#FDECEE;--wx-info:#163E91;--wx-info-bg:#E6EDFB}
  [data-theme="dark"] #screen-warehouse,[data-theme="dark"] #screen-golfcart,[data-theme="dark"] #screen-wh-create-transfer,[data-theme="dark"] #screen-wh-approvals,[data-theme="dark"] #screen-wh-team,[data-theme="dark"] #screen-transfer-stand,[data-theme="dark"] #screen-qr-codes{
    --wx-ok:#7EE2A0;--wx-ok-bg:rgba(22,163,74,.16);--wx-warn:#F7C58A;--wx-warn-bg:rgba(217,119,6,.16);--wx-bad:#FFB3BE;--wx-bad-bg:rgba(220,38,38,.18);--wx-info:#BFD3FF;--wx-info-bg:rgba(59,130,246,.18)}
  #screen-warehouse .brand-sub,#screen-golfcart .brand-sub{color:var(--wx-red)!important;font-weight:800;letter-spacing:.04em}
  #screen-warehouse .wh-hello{margin:4px 2px 12px}
  #screen-warehouse .wh-hello .hi{font-size:24px;font-weight:800;letter-spacing:-.01em}
  #screen-warehouse .wh-hello .sub{font-size:13px;font-weight:700;color:var(--wx-muted)}
  /* Right now counts: big tiles like the design (Late / Waiting / Moving / Done) */
  #screen-warehouse .wh-stat-row{grid-template-columns:repeat(4,minmax(0,1fr));gap:8px}
  #screen-warehouse .wh-stat-chip{align-items:flex-start;padding:12px 10px;border-radius:14px;background:var(--bg-card);border:1px solid var(--wx-line);min-height:74px}
  #screen-warehouse .wh-stat-chip b{font-size:26px;line-height:1.1;font-variant-numeric:tabular-nums}
  #screen-warehouse .wh-stat-chip span{font-size:12px;font-weight:700;text-transform:none;letter-spacing:0;text-align:left}
  #screen-warehouse .wh-stat-chip.warn{background:var(--wx-warn-bg);border-color:transparent}#screen-warehouse .wh-stat-chip.warn b,#screen-warehouse .wh-stat-chip.warn span{color:var(--wx-warn)}
  #screen-warehouse .wh-stat-chip.info{background:var(--wx-info-bg);border-color:transparent}#screen-warehouse .wh-stat-chip.info b,#screen-warehouse .wh-stat-chip.info span{color:var(--wx-info)}
  #screen-warehouse .wh-stat-chip.urgent{background:var(--wx-bad-bg);border:2px solid #B4122B}#screen-warehouse .wh-stat-chip.urgent b,#screen-warehouse .wh-stat-chip.urgent span{color:var(--wx-bad)}
  #screen-warehouse .wh-stat-chip.ok{background:var(--wx-ok-bg);border-color:transparent}#screen-warehouse .wh-stat-chip.ok b,#screen-warehouse .wh-stat-chip.ok span{color:var(--wx-ok)}
  /* Manager big cards + tools */
  #screen-warehouse .wh-big-card{border-radius:18px;box-shadow:none;border:1px solid var(--wx-line);min-height:112px}
  #screen-warehouse .wh-big-card .lbl{font-weight:800;font-size:17px}
  #screen-warehouse .wh-big-card.hot{background:#7A0F22;border-color:#7A0F22}
  #screen-warehouse .wh-tools-title{font-size:13px;letter-spacing:.02em;color:var(--wx-muted);margin:10px 2px 8px}
  #screen-warehouse .wh-tool{border-radius:16px;box-shadow:none;min-height:92px;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:12px 6px}
  #screen-warehouse .wh-tool .lbl{font-size:13px;font-weight:800}
  /* Job cards */
  #screen-warehouse .delivery-card{border-radius:16px;padding:14px 16px;min-height:84px;margin-bottom:10px;border:1px solid var(--wx-line);background:var(--bg-card)}
  #screen-warehouse .delivery-card.urgent{border:2px solid #B4122B;border-left:6px solid #B4122B;background:var(--bg-card)}
  #screen-warehouse .delivery-card.mine{border-left:6px solid #163E91}
  #screen-warehouse .delivery-urgent-badge{background:var(--wx-red);border-radius:999px;padding:3px 10px;font-size:11px}
  #screen-warehouse .delivery-status{font-size:13px;color:var(--wx-muted);line-height:1.4}
  #screen-warehouse .wh-fix-btn{min-height:48px;border-radius:12px;font-size:14px;font-weight:800}
  #screen-warehouse .wh-emp-actions button{min-height:52px;border-radius:14px;font-size:15px;font-weight:800}
  /* Tabs = segmented control */
  #screen-warehouse .tab-bar,#screen-golfcart .tab-bar{border-radius:12px;padding:4px;gap:4px;background:var(--bg-elevated)}
  #screen-warehouse .tab-item,#screen-golfcart .tab-item{border-radius:9px;min-height:42px;display:flex;align-items:center;justify-content:center;gap:6px;font-size:13px;font-weight:800}
  #screen-warehouse .big-action{border-radius:16px;min-height:72px}
  #screen-warehouse .chip-row .chip{min-height:40px;border-radius:999px;font-weight:800}
  /* Golf cart key board */
  #screen-golfcart #gc-keys-grid > div{border-radius:16px!important;min-height:118px;display:flex;flex-direction:column;justify-content:center}
  #screen-golfcart .btn{border-radius:14px;min-height:52px;font-weight:800}
'''
i = t.index('</style>'); t = t[:i] + CSS + t[i:]
t2 = re.sub(r"BUILD_TAG = '2026-11-2\d-fix-17\d'", "BUILD_TAG = '2026-11-28-fix-175'", t, count=1)
assert t2 != t; t = t2
open(path, 'w', encoding='utf-8').write(t); print('ok', path)
