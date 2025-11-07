Feature: Navigation and User Interface
  As a user of the soccer management application
  I want to navigate between different sections
  So that I can access different features efficiently

  Background:
    Given the application is loaded
    And I am on the main page

  # Basic Navigation
  Scenario: Navigate to Dashboard
    When I click on the "Dashboard" navigation link
    Then the Dashboard section should be displayed
    And the "Dashboard" link should be highlighted as active
    And other sections should be hidden

  Scenario: Navigate to Teams section
    When I click on the "Teams" navigation link
    Then the Teams section should be displayed
    And the "Teams" link should be highlighted as active
    And the teams list should be loaded

  Scenario: Navigate to Players section
    When I click on the "Players" navigation link
    Then the Players section should be displayed
    And the "Players" link should be highlighted as active
    And the players list should be loaded

  Scenario: Navigate to Reports section
    When I click on the "Reports" navigation link
    Then the Reports section should be displayed
    And the "Reports" link should be highlighted as active
    And the report configuration should be visible

  # Navigation State
  Scenario: Only one section is active at a time
    Given I am on the Dashboard
    When I navigate to Teams
    Then only the Teams section should be visible
    And the Dashboard section should be hidden

  Scenario: Active navigation link is visually distinct
    When I am on any section
    Then the corresponding navigation link should have the active class
    And other navigation links should not have the active class

  # Section Content Loading
  Scenario: Dashboard loads statistics on navigation
    When I navigate to the Dashboard
    Then the dashboard statistics should be loaded
    And team count should be fetched
    And player count should be fetched
    And injured player count should be displayed

  Scenario: Teams section loads teams on navigation
    When I navigate to the Teams section
    Then the teams list should be fetched from the API
    And teams should be displayed in the table
    And filter options should be populated

  Scenario: Players section loads players on navigation
    When I navigate to the Players section
    Then the players list should be fetched from the API
    And players should be displayed in the table
    And team filter should be populated with available teams

  Scenario: Reports section initializes on navigation
    When I navigate to the Reports section
    Then the report type selector should be visible
    And the team selector should be populated
    And report options should be ready

  # Modal Interactions
  Scenario: Team modal doesn't interfere with navigation
    Given the team modal is open
    When I click a navigation link
    Then the modal should close
    And the selected section should be displayed

  Scenario: Player modal doesn't interfere with navigation
    Given the player modal is open
    When I click a navigation link
    Then the modal should close
    And the selected section should be displayed

  # Header Elements
  Scenario: Application header is always visible
    When I navigate to any section
    Then the header should remain visible
    And the logo should be displayed
    And navigation links should be accessible
    And settings icon should be visible

  Scenario: Settings button is accessible from any section
    Given I am on any section
    When I click the settings icon
    Then the settings modal should open
    And I should be able to configure API settings

  # Loading States
  Scenario: Show loading indicator during data fetch
    When I navigate to a section that requires data loading
    Then a loading indicator should be displayed
    And the indicator should disappear when loading completes

  Scenario: Loading overlay prevents interaction during loading
    Given data is being loaded
    When the loading overlay is displayed
    Then I should not be able to interact with the page
    And the overlay should block all clicks

  # Error States
  Scenario: Handle navigation when API is unavailable
    Given the API is not available
    When I navigate to Teams section
    Then an error message should be displayed
    And the section should still be accessible
    And navigation should still work

  # Page Title and Context
  Scenario: Section title is displayed
    When I navigate to any section
    Then the section title should be visible
    And the title should match the selected section

  Scenario Outline: Each section has correct title
    When I navigate to "<section>"
    Then the section title should be "<title>"
    
    Examples:
      | section    | title      |
      | Dashboard  | Dashboard  |
      | Teams      | Teams      |
      | Players    | Players    |
      | Reports    | Reports    |

  # Quick Actions Navigation
  Scenario: Quick action navigates to correct section
    Given I am on the Dashboard
    When I click a quick action button
    Then I should be navigated to the appropriate section
    And the relevant modal or feature should be activated

  # Accessibility
  @accessibility
  Scenario: Navigate with keyboard only
    When I use Tab to navigate
    Then I should be able to focus on each navigation link
    And I should be able to activate links with Enter key
    And focus should be visually indicated

  @accessibility
  Scenario: Screen reader announces section changes
    Given I am using a screen reader
    When I navigate to a different section
    Then the section change should be announced
    And the section title should be read
    And the section content should be accessible

  @accessibility
  Scenario: Skip navigation link for keyboard users
    When I press Tab on page load
    Then I should be able to skip to main content
    And keyboard focus should move efficiently

  # Responsive Behavior
  Scenario: Navigation works on mobile viewport
    Given I am on a mobile device
    When I interact with navigation
    Then navigation should be accessible
    And sections should display properly

  # State Preservation
  Scenario: Form state is lost on navigation
    Given I am filling out a team form
    When I navigate to a different section without saving
    Then the form data should be lost
    And a fresh section should be displayed

  Scenario: Filter state is lost on navigation
    Given I have applied filters in Teams section
    When I navigate away and come back
    Then the filters should be reset to default
    And all teams should be displayed

  # Deep Linking
  Scenario: Application supports section-based routing
    When I access a specific section directly
    Then that section should be displayed
    And the application should initialize properly

  # Header Logo
  Scenario: Logo is displayed in header
    When the application loads
    Then the "Soccer Team Management" logo should be visible in the header
    And the logo should be clickable

  Scenario: Clicking logo returns to dashboard
    Given I am on any section other than Dashboard
    When I click the application logo
    Then I should be navigated to the Dashboard
    And dashboard statistics should be displayed

  # Navigation Performance
  Scenario: Navigation is instantaneous for UI changes
    When I click on a navigation link
    Then the section should change immediately
    And there should be no noticeable delay in UI updates

  Scenario: Data loading doesn't block navigation UI
    Given I am navigating to a data-heavy section
    When the section is loading data
    Then the section UI should be displayed immediately
    And loading indicators should show for data

  # Multiple Modal Handling
  Scenario: Only one modal is open at a time
    Given a modal is open
    When I trigger another modal
    Then the first modal should close
    And only the new modal should be visible

  Scenario: Escape key closes active modal
    Given any modal is open
    When I press the Escape key
    Then the modal should close
    And focus should return to the page

  # Navigation Link States
  Scenario: Hover state for navigation links
    When I hover over a navigation link
    Then the link should show a visual hover effect
    And the cursor should indicate it's clickable

  Scenario: Active link is visually distinct from hover
    Given a navigation link is active
    When I hover over other links
    Then the active link should remain distinguishable
    And hover effects should not make links look active
