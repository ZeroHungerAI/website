import { test, expect } from '@playwright/test';
import { goto } from './helpers';

test.describe('Projects', () => {
  test('/projects/ loads with project listings', async ({ page }) => {
    await goto(page, '/projects/');
    await expect(page).toHaveTitle(/Projects.*ZeroHunger\.ai|ZeroHunger\.ai.*Projects/i);
    await expect(page.locator('main')).toBeVisible();
  });

  test('golden snapshot — projects index', async ({ page }) => {
    await goto(page, '/projects/');
    await expect(page).toHaveScreenshot('projects-index.png', { fullPage: true });
  });

  test('/projects/honduras/ loads', async ({ page }) => {
    await goto(page, '/projects/honduras/');
    await expect(page).toHaveTitle(/Honduras|ZeroHunger\.ai/i);
    await expect(page.locator('main')).toBeVisible();
  });

  test('golden snapshot — projects/honduras', async ({ page }) => {
    await goto(page, '/projects/honduras/');
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(400);
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(200);
    await expect(page).toHaveScreenshot('projects-honduras.png', { fullPage: true });
  });

  test('/projects/ethiopia/ loads', async ({ page }) => {
    await goto(page, '/projects/ethiopia/');
    await expect(page).toHaveTitle(/Ethiopia|ZeroHunger\.ai/i);
    await expect(page.locator('main')).toBeVisible();
  });

  test('golden snapshot — projects/ethiopia', async ({ page }) => {
    await goto(page, '/projects/ethiopia/');
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(400);
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(200);
    await expect(page).toHaveScreenshot('projects-ethiopia.png', { fullPage: true });
  });
});
