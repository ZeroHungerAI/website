import { test, expect } from '@playwright/test';
import { goto } from './helpers';

test.describe('Contact', () => {
  test('/contact/ redirects to homepage contact section (not thank-you)', async ({ page }) => {
    await goto(page, '/contact/');

    // Must NOT show the static thank-you content on direct access
    await expect(page.getByRole('heading', { name: 'Received!' })).not.toBeVisible();
    await expect(page.getByText('Thank you for your message.')).not.toBeVisible();

    // Should land on the homepage contact section
    // #zh-booking-placeholder auto-loads the iframe via IntersectionObserver on scroll,
    // so assert on the persistent wrapper instead.
    await expect(page).toHaveURL(/\/#contact$|\/$/);
    await expect(page.locator('#zh-booking-wrap')).toBeVisible();
  });

  test('homepage /#contact anchor shows the booking section', async ({ page }) => {
    await goto(page, '/#contact');
    const contactSection = page.locator('#contact');
    await contactSection.scrollIntoViewIfNeeded();
    // IntersectionObserver fires on scroll → zhLoadBooking() replaces placeholder with iframe.
    // Wait up to 10s for the iframe to appear after the observer triggers.
    await expect(contactSection.locator('#zh-booking-wrap')).toBeVisible();
    await expect(contactSection.locator('#zh-booking-wrap iframe')).toBeVisible({ timeout: 10000 });
  });

  test('/thanks/ shows confirmation message (shown after form submit)', async ({ page }) => {
    await goto(page, '/thanks/');
    await expect(page.getByRole('heading', { name: 'Received!' })).toBeVisible();
    await expect(page.getByText('Thank you for your message.')).toBeVisible();
  });

  test('golden snapshot — contact section on homepage', async ({ page }) => {
    await goto(page, '/#contact');
    const contactSection = page.locator('#contact');
    await contactSection.scrollIntoViewIfNeeded();
    await page.waitForTimeout(300);
    await expect(contactSection).toHaveScreenshot('contact-section.png');
  });

  test('golden snapshot — thanks page', async ({ page }) => {
    await goto(page, '/thanks/');
    await expect(page).toHaveScreenshot('thanks-page.png', { fullPage: true });
  });
});
