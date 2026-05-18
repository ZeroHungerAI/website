import { test, expect } from '@playwright/test';
import { goto } from './helpers';

test.describe('Contact', () => {
  test('/contact/ redirects to homepage contact section (not thank-you)', async ({ page }) => {
    await goto(page, '/contact/');

    // Must NOT show the static thank-you content on direct access
    await expect(page.getByRole('heading', { name: 'Received!' })).not.toBeVisible();
    await expect(page.getByText('Thank you for your message.')).not.toBeVisible();

    // Should land on the homepage (or a page with the contact form)
    await expect(page).toHaveURL(/\/#contact$|\/$/);
    await expect(page.locator('#contact form')).toBeVisible();
  });

  test('homepage /#contact anchor shows the contact form', async ({ page }) => {
    await goto(page, '/#contact');
    const contactSection = page.locator('#contact');
    await contactSection.scrollIntoViewIfNeeded();
    await expect(contactSection.locator('form')).toBeVisible();
    await expect(contactSection.locator('input[name="name"]')).toBeVisible();
    await expect(contactSection.locator('input[name="email"]')).toBeVisible();
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
