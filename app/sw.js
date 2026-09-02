// sw.js — deliberately simple, network-first.
//
// This app's whole point is real-time operational data (who's checked in,
// what's been delivered, live stock counts) — showing someone a cached,
// stale version because a service worker decided to be clever would be
// actively harmful here, not a convenience. So the strategy is: always try
// the network first. Only fall back to a cached copy if the network
// request genuinely fails (e.g. a brief WiFi drop in the stadium), so
// there's still *something* to show instead of a blank error screen.
//
// Bumped after the 2026-09-02 Warehouse delivery-action hotfix so installed
// phones drop any older cached HTML and pick up the corrected production file.
const CACHE_VERSION = 'stadium-ops-v3-warehouse-delivery-hotfix';

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

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const copy = response.clone();
        caches.open(CACHE_VERSION).then((cache) => cache.put(event.request, copy));
        return response;
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
