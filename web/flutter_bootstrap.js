{{flutter_js}}
{{flutter_build_config}}

const serviceWorkerVersion = {{flutter_service_worker_version}};

async function startApp() {
  if (serviceWorkerVersion && 'serviceWorker' in navigator) {
    try {
      const url = new URL('medimanager_offline.js', document.baseURI);
      url.searchParams.set('v', serviceWorkerVersion);
      const registration = await navigator.serviceWorker.register(url);
      const worker = registration.installing || registration.waiting;
      if (worker?.scriptURL === url.href) {
        await new Promise((resolve) => {
          const done = () => {
            clearTimeout(timeout);
            worker.removeEventListener('statechange', check);
            resolve();
          };
          const check = () => {
            if (worker.state === 'activated' || worker.state === 'redundant') done();
          };
          const timeout = setTimeout(done, 10000);
          worker.addEventListener('statechange', check);
          check();
        });
      }
    } catch (error) {
      console.warn('MediManager offline cache is unavailable:', error);
    }
  }

  await _flutter.loader.load({
    config: { canvasKitBaseUrl: 'canvaskit/', fontFallbackBaseUrl: 'fonts/' },
  });
}

startApp();
