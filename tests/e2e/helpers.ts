import { Page } from '@playwright/test';

/** Dismiss the ZeroHunger.ai cookie consent banner if present. */
export async function dismissCookies(page: Page): Promise<void> {
  const approveBtn = page.locator('button.zh-cookie__accept');
  try {
    await approveBtn.click({ timeout: 3000 });
  } catch {
    // Banner not shown (already accepted or not yet loaded) — continue
  }
}

/** Navigate to a URL and wait for the page to be fully idle. */
export async function goto(page: Page, path: string): Promise<void> {
  await page.goto(path, { waitUntil: 'networkidle' });
  await page.waitForTimeout(500);
  await dismissCookies(page);
  await page.waitForTimeout(300);
}
