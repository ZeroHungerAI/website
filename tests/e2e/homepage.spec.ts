import { test, expect } from '@playwright/test';
import { goto } from './helpers';

test.describe('Homepage', () => {
  test('loads and shows hero section', async ({ page }) => {
    await goto(page, '/');
    await expect(page).toHaveTitle(/ZeroHunger\.ai/);
    await expect(page.locator('.zh-hero')).toBeVisible();
    await expect(page.locator('.zh-hero h1')).toBeVisible();
  });

  test('shows navigation links', async ({ page }) => {
    await goto(page, '/');
    const nav = page.locator('.zh-nav');
    await expect(nav).toBeVisible();
    await expect(nav.getByRole('link', { name: /Projects/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /Workshops/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /Contribute/i })).toBeVisible();
    await expect(nav.getByRole('link', { name: /About/i })).toBeVisible();
  });

  test('shows Our Projects section with two cards', async ({ page }) => {
    await goto(page, '/');
    await expect(page.getByRole('heading', { name: 'Our Projects' })).toBeVisible();
    await expect(page.getByRole('link', { name: /Read the story/i }).first()).toBeVisible();
  });

  test('shows contact form', async ({ page }) => {
    await goto(page, '/');
    const contactSection = page.locator('#contact');
    await contactSection.scrollIntoViewIfNeeded();
    await expect(contactSection).toBeVisible();
    await expect(contactSection.locator('form')).toBeVisible();
    await expect(contactSection.locator('input[name="name"]')).toBeVisible();
    await expect(contactSection.locator('input[name="email"]')).toBeVisible();
    await expect(contactSection.locator('textarea[name="message"]')).toBeVisible();
    await expect(contactSection.locator('button[type="submit"]')).toBeVisible();
  });

  test('golden snapshot — full page', async ({ page }) => {
    await goto(page, '/');
    // Scroll to load lazy images
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(500);
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(300);
    await expect(page).toHaveScreenshot('homepage-full.png', { fullPage: true });
  });
});
