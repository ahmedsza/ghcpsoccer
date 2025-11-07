# Example Test Setup for Gherkin Feature Files

This directory contains example configurations for setting up BDD testing with the Gherkin feature files.

## Option 1: JavaScript with Cucumber.js + Playwright

### Installation

```bash
npm install --save-dev @cucumber/cucumber @playwright/test
npx playwright install chromium
```

### Configuration Files

**cucumber.js** (root directory):
```javascript
module.exports = {
  default: {
    require: ['tests/step_definitions/**/*.js', 'tests/support/**/*.js'],
    format: ['progress', 'html:reports/cucumber-report.html'],
    publishQuiet: true
  }
};
```

**tests/support/world.js**:
```javascript
const { World } = require('@cucumber/cucumber');
const { chromium } = require('@playwright/test');

class CustomWorld extends World {
  async init() {
    this.browser = await chromium.launch({ headless: true });
    this.context = await this.browser.newContext();
    this.page = await this.context.newPage();
  }

  async cleanup() {
    await this.page?.close();
    await this.context?.close();
    await this.browser?.close();
  }
}

module.exports = { CustomWorld };
```

**tests/support/hooks.js**:
```javascript
const { Before, After, setWorldConstructor } = require('@cucumber/cucumber');
const { CustomWorld } = require('./world');

setWorldConstructor(CustomWorld);

Before(async function () {
  await this.init();
});

After(async function () {
  await this.cleanup();
});
```

**tests/step_definitions/common-steps.js**:
```javascript
const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');

Given('the application is loaded', async function () {
  await this.page.goto('http://localhost:8000');
  await this.page.waitForLoadState('networkidle');
});

Given('I am on the {string} section', async function (section) {
  const sectionMap = {
    'teams': '#teams-link',
    'players': '#players-link',
    'dashboard': '#dashboard-link',
    'reports': '#reports-link'
  };
  await this.page.click(sectionMap[section.toLowerCase()]);
});

When('I click the {string} button', async function (buttonText) {
  await this.page.click(`button:has-text("${buttonText}")`);
});

Then('I should see {string}', async function (text) {
  await expect(this.page.locator(`text=${text}`)).toBeVisible();
});
```

**package.json** scripts:
```json
{
  "scripts": {
    "test:bdd": "cucumber-js tests/features/",
    "test:bdd:team": "cucumber-js tests/features/team-management.feature",
    "test:bdd:accessibility": "cucumber-js --tags @accessibility"
  }
}
```

### Running Tests

```bash
# Run all feature tests
npm run test:bdd

# Run specific feature
npm run test:bdd:team

# Run only accessibility tests
npm run test:bdd:accessibility
```

## Option 2: Python with behave + Selenium

### Installation

```bash
pip install behave selenium webdriver-manager
```

### Configuration Files

**tests/features/environment.py**:
```python
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

def before_all(context):
    """Setup before all tests"""
    context.base_url = 'http://localhost:8000'

def before_scenario(context, scenario):
    """Setup before each scenario"""
    service = Service(ChromeDriverManager().install())
    context.driver = webdriver.Chrome(service=service)
    context.driver.implicitly_wait(10)
    context.driver.maximize_window()

def after_scenario(context, scenario):
    """Cleanup after each scenario"""
    context.driver.quit()
```

**tests/features/steps/common_steps.py**:
```python
from behave import given, when, then
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@given('the application is loaded')
def step_impl(context):
    context.driver.get(context.base_url)
    WebDriverWait(context.driver, 10).until(
        EC.presence_of_element_located((By.TAG_NAME, "header"))
    )

@given('I am on the {section} section')
def step_impl(context, section):
    link_id = f"{section.lower()}-link"
    element = context.driver.find_element(By.ID, link_id)
    element.click()

@when('I click the "{button_text}" button')
def step_impl(context, button_text):
    button = context.driver.find_element(By.XPATH, f"//button[contains(text(), '{button_text}')]")
    button.click()

@then('I should see "{text}"')
def step_impl(context, text):
    WebDriverWait(context.driver, 10).until(
        EC.visibility_of_element_located((By.XPATH, f"//*[contains(text(), '{text}')]"))
    )
```

**behave.ini** (root directory):
```ini
[behave]
paths = tests/features
show_skipped = false
format = progress
summary = true
```

### Running Tests

```bash
# Run all features
behave tests/features/

# Run specific feature
behave tests/features/team-management.feature

# Run with tags
behave --tags=@accessibility tests/features/

# Generate HTML report
behave -f html -o reports/behave-report.html
```

## Option 3: Cypress with cucumber preprocessor

### Installation

```bash
npm install --save-dev cypress @badeball/cypress-cucumber-preprocessor
```

**cypress.config.js**:
```javascript
const { defineConfig } = require('cypress');
const createBundler = require('@bahmutov/cypress-esbuild-preprocessor');
const preprocessor = require('@badeball/cypress-cucumber-preprocessor');
const createEsbuildPlugin = require('@badeball/cypress-cucumber-preprocessor/esbuild');

module.exports = defineConfig({
  e2e: {
    specPattern: 'tests/features/**/*.feature',
    supportFile: 'cypress/support/e2e.js',
    async setupNodeEvents(on, config) {
      await preprocessor.addCucumberPreprocessorPlugin(on, config);
      on('file:preprocessor',
        createBundler({
          plugins: [createEsbuildPlugin.default(config)],
        })
      );
      return config;
    },
  },
});
```

**cypress/support/step_definitions/common-steps.js**:
```javascript
import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

Given('the application is loaded', () => {
  cy.visit('http://localhost:8000');
});

Given('I am on the {string} section', (section) => {
  cy.get(`#${section.toLowerCase()}-link`).click();
});

When('I click the {string} button', (buttonText) => {
  cy.contains('button', buttonText).click();
});

Then('I should see {string}', (text) => {
  cy.contains(text).should('be.visible');
});
```

### Running Tests

```bash
# Open Cypress Test Runner
npx cypress open

# Run headless
npx cypress run

# Run specific feature
npx cypress run --spec "tests/features/team-management.feature"
```

## CI/CD Integration

### GitHub Actions Example

**.github/workflows/bdd-tests.yml**:
```yaml
name: BDD Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      backend:
        image: python:3.9
        ports:
          - 5000:5000
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright browsers
        run: npx playwright install chromium
      
      - name: Start frontend
        run: |
          cd src/frontend
          python -m http.server 8000 &
          sleep 3
      
      - name: Start backend
        run: |
          cd src/backend/python_api
          pip install -r requirements.txt
          python app.py &
          sleep 5
      
      - name: Run BDD tests
        run: npm run test:bdd
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: cucumber-report
          path: reports/
```

## Reports

### Cucumber HTML Report

Install reporter:
```bash
npm install --save-dev cucumber-html-reporter
```

**generate-report.js**:
```javascript
const report = require('cucumber-html-reporter');

const options = {
  theme: 'bootstrap',
  jsonFile: 'reports/cucumber-report.json',
  output: 'reports/cucumber-report.html',
  reportSuiteAsScenarios: true,
  scenarioTimestamp: true,
  launchReport: true,
  metadata: {
    'App Version': '1.0.0',
    'Test Environment': 'Local',
    'Browser': 'Chrome',
    'Platform': 'Linux',
    'Executed': 'Local'
  }
};

report.generate(options);
```

## Best Practices

1. **Page Object Pattern**: Create page objects for better maintainability
2. **Data Management**: Use fixtures for test data
3. **Wait Strategies**: Use explicit waits instead of sleep
4. **Parallel Execution**: Run tests in parallel when possible
5. **Screenshot on Failure**: Capture screenshots for failed tests
6. **Clean State**: Ensure each test starts with a clean state
7. **Environment Variables**: Use .env for configuration

## Troubleshooting

### Common Issues

**Issue**: Tests fail with "element not found"
- **Solution**: Add appropriate waits, check selectors

**Issue**: API connection errors
- **Solution**: Ensure backend is running on correct port

**Issue**: Tests work locally but fail in CI
- **Solution**: Check environment variables, ensure all services are started

**Issue**: Flaky tests
- **Solution**: Add proper waits, avoid hard-coded delays

## Resources

- [Cucumber.js Documentation](https://github.com/cucumber/cucumber-js)
- [Playwright Documentation](https://playwright.dev/)
- [behave Documentation](https://behave.readthedocs.io/)
- [Cypress Documentation](https://docs.cypress.io/)
