# BDD Feature Files for Soccer Team Management Application

This directory contains comprehensive Gherkin feature files for behavior-driven development (BDD) testing of the Soccer Team Management application.

## Overview

The feature files describe the expected behavior of the application from a user's perspective using the **Given-When-Then** format. These files serve as:

- **Living Documentation**: Clear, business-readable specifications of what the application does
- **Test Specifications**: Detailed scenarios that can be automated with testing frameworks
- **Requirements Validation**: Ensures all requirements are captured and testable
- **Communication Tool**: Bridge between technical and non-technical stakeholders

## Feature Files

### 1. `dashboard.feature`
**Purpose**: Tests for the main dashboard view and quick actions

**Coverage**:
- ✅ Display of statistics (teams, players, injured players, average value)
- ✅ Dashboard with data and empty states
- ✅ Quick action buttons (Add Team, Add Player, Generate Report)
- ✅ Real-time updates after data changes
- ✅ Accessibility features (keyboard navigation, screen readers)

**Key Scenarios**: 9 scenarios covering happy path, edge cases, and accessibility

### 2. `team-management.feature`
**Purpose**: Comprehensive team CRUD operations and filtering

**Coverage**:
- ✅ Create teams with full and minimal data
- ✅ View, edit, and delete teams
- ✅ Search teams by name
- ✅ Filter by country and league
- ✅ Combined search and filter
- ✅ Validation and error handling
- ✅ Accessibility support

**Key Scenarios**: 28 scenarios including happy paths, edge cases, errors, and accessibility

### 3. `player-management.feature`
**Purpose**: Player management including injury tracking

**Coverage**:
- ✅ Create players with complete and minimal information
- ✅ Injury status management with details
- ✅ View, edit, and delete players
- ✅ Search and filter by team, position, injury status
- ✅ Position-specific scenarios (Goalkeeper, Defender, Midfielder, Forward)
- ✅ Performance rating validation (1-10 scale)
- ✅ Jersey number validation
- ✅ Team assignment and updates

**Key Scenarios**: 39 scenarios with extensive validation and edge case coverage

### 4. `reports.feature`
**Purpose**: Report generation and data analysis

**Coverage**:
- ✅ Team Composition Report (positions, nationalities, ratings, injuries)
- ✅ Player Performance Report (sorted by rating, top/bottom performers)
- ✅ Value Report (sorted by value, totals, averages)
- ✅ Injury Report (injury rate, injured players with details)
- ✅ CSV export functionality
- ✅ Empty states and error handling
- ✅ Report type switching

**Key Scenarios**: 33 scenarios covering all report types and edge cases

### 5. `settings.feature`
**Purpose**: Application configuration and API connectivity

**Coverage**:
- ✅ Settings modal access and interaction
- ✅ API backend selection (Python API vs C# API)
- ✅ Custom API URL configuration
- ✅ Connection testing (success, failure, timeout)
- ✅ Settings persistence (localStorage)
- ✅ Default settings and validation
- ✅ URL format validation
- ✅ Status indicators

**Key Scenarios**: 32 scenarios covering configuration, validation, and persistence

### 6. `navigation.feature`
**Purpose**: User interface navigation and section switching

**Coverage**:
- ✅ Navigation between Dashboard, Teams, Players, Reports
- ✅ Active section highlighting
- ✅ Section content loading
- ✅ Modal interactions with navigation
- ✅ Loading states and error handling
- ✅ Header elements (logo, settings)
- ✅ Quick actions integration
- ✅ Keyboard navigation

**Key Scenarios**: 28 scenarios covering navigation flow and UX

### 7. `dad-joke.feature`
**Purpose**: Dad joke API integration and caching

**Coverage**:
- ✅ Joke display on page load
- ✅ API integration with icanhazdadjoke.com
- ✅ 30-second caching mechanism
- ✅ Fallback jokes when API unavailable
- ✅ Error handling (timeout, malformed response)
- ✅ Cache expiry and refresh
- ✅ Accessibility of joke content

**Key Scenarios**: 30 scenarios covering API integration, caching, and fallbacks

## Coverage Matrix

```
┌──────────────────────────┬─────────┬───────────┬─────────┬──────────────┐
│ Feature Area             │ Happy   │ Edge      │ Error   │ Accessibility│
├──────────────────────────┼─────────┼───────────┼─────────┼──────────────┤
│ Dashboard                │ ✓       │ ✓         │ ✓       │ ✓            │
│ Team Management          │ ✓       │ ✓         │ ✓       │ ✓            │
│ Player Management        │ ✓       │ ✓         │ ✓       │ ✓            │
│ Reports                  │ ✓       │ ✓         │ ✓       │ ✓            │
│ Settings                 │ ✓       │ ✓         │ ✓       │ ✓            │
│ Navigation               │ ✓       │ ✓         │ ✓       │ ✓            │
│ Dad Joke                 │ ✓       │ ✓         │ ✓       │ ✓            │
└──────────────────────────┴─────────┴───────────┴─────────┴──────────────┘

Total Scenarios: 199
```

## Scenario Types

### Happy Path Scenarios
Standard user flows with valid inputs and expected successful outcomes.

**Example**:
```gherkin
Scenario: Create a new team with all required fields
  When I fill in the team form with valid data
  And I submit the team form
  Then a new team should be created successfully
```

### Edge Case Scenarios
Boundary conditions and unusual but valid inputs.

**Example**:
```gherkin
Scenario: Create team with minimum required fields
Scenario: Display teams with very large value
Scenario: Player name with special characters
```

### Error Scenarios
Invalid inputs, API failures, and error handling.

**Example**:
```gherkin
Scenario: Attempt to create team without required fields
Scenario: Handle API connection failure when loading teams
```

### Accessibility Scenarios (Tagged with @accessibility)
Keyboard navigation, screen reader support, and WCAG compliance.

**Example**:
```gherkin
@accessibility
Scenario: Navigate team form with keyboard
  When I use Tab to navigate through form fields
  Then I should be able to reach all form inputs
```

## Testing Frameworks

These feature files can be used with various BDD testing frameworks:

### For JavaScript/Frontend Testing
- **Cucumber.js** + Playwright/Puppeteer
- **Cypress** with cucumber preprocessor
- **Jest** + cucumber

### For Python/Backend Testing
- **behave**
- **pytest-bdd**
- **lettuce**

### Example Test Setup (Cucumber.js + Playwright)

```javascript
// features/step_definitions/team-steps.js
const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');

Given('I am on the teams section', async function () {
  await this.page.goto('http://localhost:8000');
  await this.page.click('#teams-link');
});

When('I click the "New Team" button', async function () {
  await this.page.click('#new-team-btn');
});

Then('the team modal should be displayed', async function () {
  const modal = await this.page.locator('#team-modal');
  await expect(modal).toBeVisible();
});
```

## Running the Tests

### Prerequisites
1. Install testing framework (e.g., Cucumber.js, behave)
2. Install test automation tool (e.g., Playwright, Selenium)
3. Ensure the application is running (frontend + backend API)

### Example Commands

```bash
# JavaScript with Cucumber + Playwright
npm install @cucumber/cucumber playwright
npx cucumber-js tests/features/

# Python with behave
pip install behave selenium
behave tests/features/

# Run specific feature
npx cucumber-js tests/features/team-management.feature

# Run scenarios with specific tag
npx cucumber-js --tags @accessibility
```

## Implementing Step Definitions

Each scenario requires corresponding step definitions. Here's the recommended structure:

```
tests/
├── features/                      # Feature files (Gherkin)
│   ├── dashboard.feature
│   ├── team-management.feature
│   ├── player-management.feature
│   ├── reports.feature
│   ├── settings.feature
│   ├── navigation.feature
│   └── dad-joke.feature
├── step_definitions/              # Step implementations
│   ├── common-steps.js           # Shared steps (navigation, assertions)
│   ├── dashboard-steps.js
│   ├── team-steps.js
│   ├── player-steps.js
│   ├── report-steps.js
│   ├── settings-steps.js
│   └── joke-steps.js
└── support/                       # Test helpers
    ├── world.js                  # Test context
    ├── hooks.js                  # Before/After hooks
    └── page-objects/             # Page object models
        ├── TeamPage.js
        ├── PlayerPage.js
        └── DashboardPage.js
```

## Best Practices

### 1. **Keep Scenarios Independent**
Each scenario should be runnable in isolation without depending on other scenarios.

### 2. **Use Background Wisely**
Background steps run before each scenario. Use them for common setup.

### 3. **Write Declarative Scenarios**
Focus on **what** the user does, not **how** the system implements it.

✅ **Good**: `When I create a new team`  
❌ **Bad**: `When I click button#new-team-btn and fill input#team-name`

### 4. **Tag Scenarios Appropriately**
Use tags for organization and selective execution:
- `@accessibility` - Accessibility tests
- `@smoke` - Critical path tests
- `@regression` - Full regression suite
- `@wip` - Work in progress

### 5. **Data Tables for Multiple Values**
Use tables for testing multiple similar cases:

```gherkin
Examples:
  | position   |
  | Goalkeeper |
  | Defender   |
  | Midfielder |
  | Forward    |
```

## API Endpoints Tested

The features validate the following API endpoints:

### Teams API
- `GET /api/teams` - List teams
- `GET /api/teams/:id` - Get team details
- `POST /api/teams` - Create team
- `PUT /api/teams/:id` - Update team
- `DELETE /api/teams/:id` - Delete team

### Players API
- `GET /api/players` - List players
- `GET /api/players/:id` - Get player details
- `POST /api/players` - Create player
- `PUT /api/players/:id` - Update player
- `DELETE /api/players/:id` - Delete player

### Reports API
- `GET /api/reports/team-composition?team_id=:id`
- `GET /api/reports/player-performance?team_id=:id`
- `GET /api/reports/value-report?team_id=:id`
- `GET /api/reports/injury-report?team_id=:id`

### Joke API
- `GET /api/dad-joke` - Get dad joke (with caching)

## Continuous Integration

These feature files can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
name: BDD Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: npm install
      - name: Start application
        run: npm start &
      - name: Run BDD tests
        run: npx cucumber-js tests/features/
      - name: Upload test results
        uses: actions/upload-artifact@v2
        with:
          name: cucumber-report
          path: reports/
```

## Contributing

When adding new features to the application:

1. **Write feature file first** (BDD/TDD approach)
2. **Review scenarios** with stakeholders
3. **Implement step definitions**
4. **Run tests** (should fail initially)
5. **Implement feature**
6. **Run tests** (should pass)
7. **Refactor** as needed

## Statistics

- **Total Feature Files**: 7
- **Total Scenarios**: 199
- **Lines of Gherkin**: ~700+
- **Coverage Areas**: Dashboard, Teams, Players, Reports, Settings, Navigation, External API
- **Accessibility Scenarios**: 12+
- **Error Handling Scenarios**: 25+

## Related Documentation

- [Cucumber Documentation](https://cucumber.io/docs/cucumber/)
- [Gherkin Syntax Reference](https://cucumber.io/docs/gherkin/reference/)
- [Playwright Documentation](https://playwright.dev/)
- [Application API Documentation](../schemas/README.md)

## Support and Questions

For questions about these feature files or BDD testing:
1. Review the feature files for examples
2. Check the Cucumber/Gherkin documentation
3. Refer to the application's main README
4. Contact the development team

---

**Last Updated**: 2025-11-07  
**Version**: 1.0.0  
**Maintainer**: Soccer App Development Team
