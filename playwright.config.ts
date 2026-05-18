import { defineConfig, devices } from '@playwright/test';

const BASE_URL = process.env.BASE_URL || 'https://www.dev.zerohunger.ai';

export default defineConfig({
  testDir: './tests/e2e',
  snapshotDir: './tests/snapshots',
  outputDir: './tests/test-results',

  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 2 : undefined,

  reporter: [
    ['list'],
    ['html', { outputFolder: 'tests/playwright-report', open: 'never' }],
  ],

  use: {
    baseURL: BASE_URL,
    // Dismiss cookie consent before screenshots
    storageState: undefined,
    screenshot: 'only-on-failure',
    trace: 'on-first-retry',
  },

  expect: {
    // Tolerate minor pixel differences in golden snapshots (fonts/anti-aliasing)
    toHaveScreenshot: {
      maxDiffPixelRatio: 0.02,
      threshold: 0.2,
      animations: 'disabled',
    },
  },

  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
        deviceScaleFactor: 1,
        // Accept cookies so consent banner doesn't pollute golden snapshots
        extraHTTPHeaders: {},
      },
    },
  ],
});
