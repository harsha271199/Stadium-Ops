// sw.js — network-first, with one narrowly-scoped Warehouse UI hotfix.
//
// This app's whole point is real-time operational data, so network remains
// the source of truth. The HTML injection below only loads a tiny hotfix
// script that keeps the Warehouse Mark delivered action synchronized with
// asynchronously merged request items. Remove this injection after the same
// fix is folded into the next full index.html deployment.
const CACHE_VERSION = 'stadium-ops-v3-warehouse-hotfix';
const WAREHOUSE_HOTFIX_TAG = '<script src="/warehouse-hotfix.js?v=20260902"></script>';

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

function cacheResponse(request, response) {
  const copy = response.clone();
  caches.open(CACHE_VERSION).then((cache) => cache.put(request, copy));
  return response;
}

async function injectWarehouseHotfix(request, response) {
  const type = response.headers.get('content-type') || '';
  if (!response.ok || !type.includes('text/html')) return cacheResponse(request, response);

  let html = await response.text();
  if (!html.includes('/warehouse-hotfix.js')) {
    html = html.includes('</body>')
      ? html.replace('</body>', WAREHOUSE_HOTFIX_TAG + '</body>')
      : html + WAREHOUSE_HOTFIX_TAG;
  }

  const headers = new Headers(response.headers);
  headers.delete('content-length');
  const patched = new Response(html, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
  return cacheResponse(request, patched);
}

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Only navigation/HTML responses receive the hotfix script. API,
        // images, manifests, JS, and all operational writes are unchanged.
        if (event.request.mode === 'navigate') {
          return injectWarehouseHotfix(event.request, response);
        }
        return cacheResponse(event.request, response);
      })
      .catch(() => caches.match(event.request))
  );
});

self.addEventListener('push', (event) => {
  let data = { title: 'Stadium Ops', body: 'You have a new update.' };
  try {
    if (event.data) data = event.data.json();
  } catch (e) {}

  event.waitUntil(
    self.registration.showNotification(data.title || 'Stadium Ops', {
      body: data.body || '',
      icon: '/icon-192.png',
      badge: '/icon-192.png',
      vibrate: [100, 50, 100],
    })
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if ('focus' in client) return client.focus();
      }
      if (self.clients.openWindow) return self.clients.openWindow('/');
    })
  );
});
