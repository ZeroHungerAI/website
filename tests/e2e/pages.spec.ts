import { test, expect } from '@playwright/test';
import { goto } from './helpers';

const staticPages = [
  { path: '/about/', titlePattern: /About|ZeroHunger\.ai/i, snapshot: 'about.png' },
  { path: '/contribute/', titlePattern: /Contribute|ZeroHunger\.ai/i, snapshot: 'contribute.png' },
  { path: '/workshops/', titlePattern: /Workshop|ZeroHunger\.ai/i, snapshot: 'workshops.png' },
  { path: '/impressum/', titlePattern: /Imprint|Impressum|ZeroHunger\.ai/i, snapshot: 'impressum.png' },
  { path: '/privacy/', titlePattern: /Privacy|ZeroHunger\.ai/i, snapshot: 'privacy.png' },
];

for (const { path, titlePattern, snapshot } of staticPages) {
  test.describe(`Page: ${path}`, () => {
    test('loads with correct title', async ({ page }) => {
      await goto(page, path);
      await expect(page).toHaveTitle(titlePattern);
      await expect(page.locator('main')).toBeVisible();
    });

    test(`golden snapshot — ${path}`, async ({ page }) => {
      await goto(page, path);
      await expect(page).toHaveScreenshot(snapshot, { fullPage: true });
    });
  });
}
