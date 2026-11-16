'use strict';

const scope = new URL(self.registration.scope);
const version = new URL(self.location.href).searchParams.get('v');
const prefix = 'medimanager-web:' + scope.href + ':';
const cacheName = prefix + version;
const shell = [
  './',
  'flutter_bootstrap.js',
  'main.dart.js',
  'drift_worker.js',
  'sqlite3.wasm',
];
const bundledFiles = new Set([...shell, 'manifest.json', 'favicon.png', 'version.json']);

self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(cacheName);
    await cache.addAll(shell.map((path) => new Request(new URL(path, scope), {cache: 'reload'})));
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys
      .filter((key) => key.startsWith(prefix) && key !== cacheName)
      .map((key) => caches.delete(key)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || !url.href.startsWith(scope.href)) return;
  const path = url.pathname.slice(scope.pathname.length);
  const entry = path === '' || path === 'index.html';

  if (entry || path === 'flutter_bootstrap.js') {
    // Online entry points can discover a new build. Offline they use this build's shell.
    event.respondWith(fetch(request).catch(async () => {
      const cache = await caches.open(cacheName);
      return await cache.match(new URL(entry ? './' : path, scope)) || Response.error();
    }));
    return;
  }
  if (!bundledFiles.has(path) &&
      !['assets/', 'canvaskit/', 'fonts/', 'icons/'].some((folder) => path.startsWith(folder))) {
    return;
  }

  event.respondWith((async () => {
    const cache = await caches.open(cacheName);
    const cached = await cache.match(request);
    if (cached) return cached;
    const response = await fetch(request);
    if (response.ok) {
      try {
        await cache.put(request, response.clone());
      } catch (error) {
        console.warn('Could not cache a MediManager asset:', error);
      }
    }
    return response;
  })());
});
