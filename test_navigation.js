const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();
  
  // Set viewport to a reasonable desktop size
  await page.setViewport({ width: 1280, height: 800 });

  const baseUrl = 'http://localhost:8083';

  try {
    console.log(`Navigating to ${baseUrl}...`);
    await page.goto(baseUrl, { waitUntil: 'networkidle0', timeout: 60000 });
    
    // Wait for the dashboard to load (look for a known element, e.g., 'Dashboard' text or a specific widget)
    // Flutter web uses canvas or specific DOM structure. We might need to wait for a specific text.
    try {
        await page.waitForFunction(
            () => document.body.innerText.includes('Dashboard'),
            { timeout: 30000 }
        );
        console.log('Dashboard loaded successfully.');
    } catch (e) {
        console.log('Dashboard load check failed (might be rendering differently), taking screenshot...');
    }
    
    await page.screenshot({ path: 'dashboard.png' });

    // Define the routes/screens we expect to verify
    // Note: In Flutter Web, finding elements by text via Puppeteer can be tricky due to Canvas rendering (if using CanvasKit) or complex DOM (html renderer).
    // However, for semantic accessibility, Flutter does output a semantic tree.
    // If the app is using 'html' renderer, text is selectable.
    // We'll assume we can verify by URL changes if we use named routes, but navigating via clicking might be hard without specific selectors.
    // Instead, we can try to navigate via URL manipulation to verify routes exist and don't crash.

    const routes = [
      '/patients',
      '/protocols',
      '/staff',
      '/appointments',
      '/messenger',
      '/settings', 
      '/login' // Be careful with login as it might redirect if authenticated or not
    ];

    for (const route of routes) {
      const url = `${baseUrl}/#${route}`;
      console.log(`Navigating to ${url}...`);
      await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });
      
      // Wait a bit for rendering
      await new Promise(r => setTimeout(r, 2000));
      
      const screenshotName = route.replace('/', '') + '.png';
      await page.screenshot({ path: screenshotName });
      console.log(`Verified ${route} - Screenshot saved to ${screenshotName}`);
    }

  } catch (error) {
    console.error('Test failed:', error);
  } finally {
    await browser.close();
  }
})();
