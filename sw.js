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
// Bump CACHE_VERSION any time you want to force every installed device to
// drop its old cache — e.g. after a major update where you want to be
// extra sure nobody's stuck on stale cached assets.
const CACHE_VERSION = 'stadium-ops-v2';

self.addEventListener('install', (event) => {
  self.skipWaiting(); // activate the new service worker immediately, don't wait for old tabs to close
});

// Lets the page force an already-waiting worker to activate immediately,
// instead of waiting for every tab to close first (the normal service
// worker lifecycle). Paired with index.html calling reg.update() and
// posting this message on every load — together these are what make a
// new deploy actually take effect promptly instead of a device silently
// sitting on an old cached worker for a while.
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim(); // take control of any already-open tabs immediately
});

self.addEventListener('fetch', (event) => {
  // Only handle GET requests — never intercept POST/PATCH/DELETE (the
  // actual app writes, like check-ins and transfers) with caching logic.
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Got a real network response — cache a copy for offline fallback,
        // but always return the fresh network response, never the cache,
        // when the network actually works.
        const copy = response.clone();
        caches.open(CACHE_VERSION).then((cache) => cache.put(event.request, copy));
        return response;
      })
      .catch(() => {
        // Network failed — fall back to whatever's cached, if anything.
        return caches.match(event.request);
      })
  );
});

// This was the actual missing piece — the send-push Edge Function
// successfully delivers the push message to the device, but without this
// listener catching it, the service worker has nothing telling it to
// actually show a notification, so it silently arrives and does nothing.
self.addEventListener('push', (event) => {
  let data = { title: 'Stadium Ops', body: 'You have a new update.' };
  try {
    if (event.data) data = event.data.json();
  } catch (e) {
    // If the payload isn't valid JSON for some reason, fall back to the
    // default text above rather than crashing silently.
  }
  event.waitUntil(
    self.registration.showNotification(data.title || 'Stadium Ops', {
      body: data.body || '',
      icon: '/icon-192.png',
      badge: '/icon-192.png',
      vibrate: [100, 50, 100],
    })
  );
});

// Tapping the notification opens the app instead of just dismissing it —
// focuses an already-open tab if there is one, otherwise opens a new one.
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
