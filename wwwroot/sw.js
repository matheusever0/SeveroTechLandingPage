const CACHE_NAME = 'severotech-v1';
const urlsToCache = [
  '/',
  '/assets/css/main.css',
  '/assets/js/ux-advanced.js',
  '/assets/images/logos/logo.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        return response || fetch(event.request);
      })
  );
});
