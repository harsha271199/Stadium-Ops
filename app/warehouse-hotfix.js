// Warehouse delivery hotfix — 2026-09-02
// Production bug: the delivery screen can open before stock request items
// finish merging into transfer_items. renderTsStatus() sees zero items and
// hides Mark delivered; later renderTsItems() shows the requested items but
// the button state is never recalculated when the transfer is already
// `delivering`.
(function () {
  'use strict';

  function syncDeliveryAction() {
    const screen = document.getElementById('screen-transfer-stand');
    if (!screen || !screen.classList.contains('active')) return;
    try {
      if (typeof renderTsStatus === 'function') renderTsStatus();
    } catch (err) {
      console.warn('[warehouse hotfix] could not sync delivery action', err);
    }
  }

  function clarifyClaimLanguage() {
    const list = document.getElementById('wh-todeliver-list');
    if (!list) return;
    list.querySelectorAll('.delivery-status').forEach((el) => {
      if (el.textContent.includes('Tap to start delivery')) {
        el.textContent = el.textContent.replace('Tap to start delivery', 'Tap to claim + start delivery');
      }
    });
  }

  function install() {
    const items = document.getElementById('ts-items');
    if (items && !items.dataset.deliveryActionHotfix) {
      items.dataset.deliveryActionHotfix = '1';
      new MutationObserver(() => {
        // Let the app finish its own DOM update first, then recompute the
        // button from the current transfer status + current item count.
        queueMicrotask(syncDeliveryAction);
      }).observe(items, { childList: true, subtree: true });
    }

    const list = document.getElementById('wh-todeliver-list');
    if (list && !list.dataset.claimLanguageHotfix) {
      list.dataset.claimLanguageHotfix = '1';
      new MutationObserver(clarifyClaimLanguage).observe(list, { childList: true, subtree: true });
      clarifyClaimLanguage();
    }

    syncDeliveryAction();
    console.info('[warehouse hotfix] delivery action sync installed');
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', install, { once: true });
  } else {
    install();
  }
})();
