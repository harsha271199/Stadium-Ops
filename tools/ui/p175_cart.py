"""fix-175 part A: one golf cart per person (app side). Server side: sql/31_one_cart_per_person.sql"""
import sys
path = sys.argv[1]; t = open(path, encoding='utf-8').read()
def rep(old, new):
    global t
    n = t.count(old)
    if n != 1: raise SystemExit(f'anchor count {n}: {old[:80]!r}')
    t = t.replace(old, new)

# 1. key board: while you hold a key, the free keys are locked for you
rep("""    const label = avail ? '✅ Available' : flagged ? '🚫 Out of service' : mine ? '🟡 You have this — tap to return' : '🔴 In use';""",
    """    const lockedForMe = avail && !!myKey;   // fix-175: one cart per person
    const label = lockedForMe ? '🔒 Return Key ' + myKey.key_number + ' first' : avail ? '✅ Available' : flagged ? '🚫 Out of service' : mine ? '🟡 You have this — tap to return' : '🔴 In use';""")
rep("""    const tap = avail ? 'gcSelectKey('+r.key_number+')' : (mine ? 'gcTapMyKey()' : '');
    const clickable = avail || mine;""",
    """    const tap = (avail && !myKey) ? 'gcSelectKey('+r.key_number+')' : (mine ? 'gcTapMyKey()' : '');
    const clickable = (avail && !myKey) || mine;""")

rep("""    const bg = avail ? '#DCFCE7' : flagged ? '#FEE2E2' : mine ? '#FEF3C7' : '#FEE2E2';
    const border = avail ? '#00A651' : flagged ? '#DC2626' : mine ? '#D97706' : '#DC2626';""",
    """    const bg = (avail && myKey) ? '#F1F2F4' : avail ? '#DCFCE7' : flagged ? '#FEE2E2' : mine ? '#FEF3C7' : '#FEE2E2';
    const border = (avail && myKey) ? '#9AA0AA' : avail ? '#00A651' : flagged ? '#DC2626' : mine ? '#D97706' : '#DC2626';""")

# 2. guard when a key is picked and again right before it is taken
GUARD = """
// fix-175: one golf cart per person. Returns the key number this person already holds, or 0.
async function gcHeldKey() {
  if (!_gcUser || !_gcUser.empId) return 0;
  const r = await sb('cart_keys?status=eq.checked_out&checked_out_by_id=eq.' + encodeURIComponent(_gcUser.empId) + '&select=key_number').catch(() => ({ _err: true }));
  return (Array.isArray(r) && r.length) ? r[0].key_number : 0;
}
async function gcSelectKey(keyNum) {
  const held = await gcHeldKey();
  if (held && held !== keyNum) { toast('You already have Key ' + held + '. Return it before you take another cart.', 'error', 6000); gcShowKeys(); return; }"""
rep("""
async function gcSelectKey(keyNum) {""", GUARD)
rep("""async function gcSubmitCheckout() {
  gcHideAll();""", """async function gcSubmitCheckout() {
  const heldNow = await gcHeldKey();
  if (heldNow && heldNow !== _gcSelectedKey) { toast('You already have Key ' + heldNow + '. Return it before you take another cart.', 'error', 6000); gcShowKeys(); return; }
  gcHideAll();""")
rep("""  if (r._err || !Array.isArray(r) || !r.length) { toast('That key was just taken by someone else — pick another', 'error'); gcShowKeys(); return; }""",
    """  if (r._err || !Array.isArray(r) || !r.length) {
    // fix-175: the server refuses a second key for the same person (unique rule) — say so plainly
    const held = await gcHeldKey();
    toast(held ? 'You already have Key ' + held + '. Return it before you take another cart.' : 'That key was just taken by someone else — pick another', 'error', 6000);
    gcShowKeys(); return; }""")
open(path, 'w', encoding='utf-8').write(t); print('ok', path)
