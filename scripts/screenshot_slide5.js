const pw = require('/tmp/pw-temp/node_modules/playwright');
const path = require('path');

(async () => {
  const browser = await pw.chromium.launch({
    executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    headless: true,
  });
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 }, deviceScaleFactor: 2 });
  const page = await ctx.newPage();
  const filePath = path.resolve('plans/mockups/search-mobile.mockup.html').replace(/\\/g, '/');
  await page.goto('file:///' + filePath);
  await page.waitForTimeout(1500);
  const els = await page.$$('.phone');
  if (els[0]) {
    await els[0].screenshot({ path: 'assets/images/intro/slide_5_search.png' });
    console.log('done: slide_5_search.png');
  } else {
    console.log('no .phone element found');
  }
  await browser.close();
})().catch(console.error);
