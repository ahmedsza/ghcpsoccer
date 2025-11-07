Feature: Application Settings and Configuration
  As a system administrator
  I want to configure API settings and test connectivity
  So that the application can connect to the correct backend

  Background:
    Given the application is loaded
    And I can access the settings

  # Settings Modal Access
  Scenario: Open settings modal
    When I click the settings icon in the header
    Then the settings modal should be displayed
    And I should see the API configuration options

  Scenario: Close settings modal with close button
    Given the settings modal is open
    When I click the close button
    Then the settings modal should close
    And I should return to the previous section

  Scenario: Close settings modal with cancel action
    Given the settings modal is open
    When I click outside the modal
    Then the settings modal should close

  # API Type Selection
  Scenario: Select Python API backend
    Given the settings modal is open
    When I select "Python API" from the backend API dropdown
    Then the Python API should be selected
    And the API type setting should be saved

  Scenario: Select C# API backend
    Given the settings modal is open
    When I select "C# API" from the backend API dropdown
    Then the C# API should be selected
    And the API type setting should be saved

  Scenario: Switch between API backends
    Given the current backend is "Python API"
    When I open settings
    And I change the backend to "C# API"
    And I save settings
    Then the application should use the C# API endpoint

  # API URL Configuration
  Scenario: Configure custom API URL
    Given the settings modal is open
    When I enter "http://localhost:5000/api" in the API URL field
    And I save settings
    Then the API base URL should be set to "http://localhost:5000/api"
    And subsequent API calls should use this URL

  Scenario: Configure API URL with trailing slash
    When I set the API URL to "http://localhost:5000/api/"
    And I save settings
    Then the application should handle the trailing slash correctly
    And API endpoints should be constructed properly

  Scenario: Update API URL to different port
    Given the current API URL is "http://localhost:5000/api"
    When I change the API URL to "http://localhost:8080/api"
    And I save settings
    Then all API requests should be sent to port 8080

  # API Connection Testing
  Scenario: Test successful API connection
    Given I have configured a valid API URL
    When I click the "Test Connection" button
    Then I should see a loading indicator
    And after the test completes, I should see a success status
    And the status indicator should show "Connected"

  Scenario: Test failed API connection
    Given I have configured an invalid API URL
    When I click the "Test Connection" button
    Then I should see a loading indicator
    And after the test completes, I should see an error status
    And the status indicator should show "Connection failed"

  Scenario: Test API connection with timeout
    Given the API server is not responding
    When I click the "Test Connection" button
    Then the connection test should timeout after a reasonable period
    And I should see a timeout error message

  # Settings Persistence
  Scenario: Settings persist after page reload
    Given I have configured custom settings:
      | setting        | value                       |
      | API Type       | Python API                  |
      | API URL        | http://localhost:5000/api   |
    When I save the settings
    And I reload the page
    Then the settings should be restored
    And the API Type should be "Python API"
    And the API URL should be "http://localhost:5000/api"

  Scenario: Settings stored in localStorage
    When I save settings
    Then the settings should be stored in browser localStorage
    And I should be able to retrieve them on subsequent visits

  # Default Settings
  Scenario: Application loads with default settings
    Given this is the first time loading the application
    When the application initializes
    Then default API settings should be applied
    And the API type should have a default value
    And the API URL should have a default value

  Scenario: Reset to default settings
    Given I have custom settings configured
    When I reset settings to defaults
    Then the API type should revert to the default
    And the API URL should revert to the default

  # Validation and Error Handling
  Scenario: Validate API URL format
    Given the settings modal is open
    When I enter an invalid URL "not-a-url"
    And I attempt to save settings
    Then I should see a validation error
    And the settings should not be saved

  Scenario: Require API URL to be provided
    Given the settings modal is open
    When I clear the API URL field
    And I attempt to save settings
    Then I should see an error message
    And the settings should not be saved

  Scenario: Handle special characters in API URL
    When I enter an API URL with query parameters "http://localhost:5000/api?key=value"
    And I save settings
    Then the URL should be saved correctly
    And API calls should preserve the query parameters

  # API Status Indicator
  Scenario: Status indicator shows checking state
    When I open the settings modal
    Then the status indicator should show "Checking connection..."
    And a connection test should be initiated automatically

  Scenario: Status indicator updates after test
    Given the settings modal is open
    When the automatic connection test completes
    Then the status indicator should update with the result
    And the status dot should reflect the connection state

  Scenario: Status dot color indicates connection state
    When the API connection is successful
    Then the status dot should be green
    When the API connection fails
    Then the status dot should be red

  # Settings Form Interaction
  Scenario: Save settings button is always enabled
    Given the settings modal is open
    When I make changes to any setting
    Then the save button should be clickable
    And I should be able to save the changes

  Scenario: Save settings and close modal
    Given the settings modal is open
    When I configure settings
    And I click "Save Settings"
    Then the settings should be persisted
    And the modal should remain open for confirmation

  # API Endpoint Construction
  Scenario: Correct API endpoints are constructed
    Given the base API URL is "http://localhost:5000/api"
    When the application makes requests
    Then teams endpoint should be "http://localhost:5000/api/teams"
    And players endpoint should be "http://localhost:5000/api/players"
    And reports endpoints should be constructed correctly

  # Integration with Application
  Scenario: Settings affect all API calls
    Given I change the API URL in settings
    When I navigate to teams section
    Then teams should be loaded from the new API URL
    When I navigate to players section
    Then players should be loaded from the new API URL

  Scenario: Application behavior with API unavailable
    Given the configured API is unavailable
    When I interact with the application
    Then appropriate error messages should be displayed
    And the user should be prompted to check settings

  # Accessibility
  @accessibility
  Scenario: Navigate settings with keyboard
    When I press the settings shortcut key
    Then the settings modal should open
    When I use Tab to navigate
    Then I should be able to reach all form controls
    And I should be able to save with Enter key
    And I should be able to close with Escape key

  @accessibility
  Scenario: Screen reader announces settings
    Given I am using a screen reader
    When I open the settings modal
    Then the modal title should be announced
    And form labels should be properly associated
    And the status indicator should be announced
    And button purposes should be clear

  # Edge Cases
  Scenario: Handle concurrent settings changes
    Given two browser tabs are open
    When I change settings in one tab
    And I change different settings in another tab
    Then the most recent save should take precedence
    And settings should be consistent across tabs

  Scenario: Settings with very long API URL
    When I enter a very long API URL (200+ characters)
    And I save settings
    Then the URL should be saved correctly
    And API calls should work with the long URL

  Scenario Outline: Configure API for different environments
    When I configure the API for "<environment>"
    And I set the URL to "<url>"
    And I save settings
    Then the application should connect to "<environment>"
    
    Examples:
      | environment | url                              |
      | Local       | http://localhost:5000/api        |
      | Development | https://dev.example.com/api      |
      | Production  | https://api.example.com/api      |

  # API Response Handling
  Scenario: Display API version or info if available
    Given the API returns version information
    When I test the connection
    Then the API version should be displayed if available

  Scenario: Settings modal shows current active API
    When I open settings
    Then I should see which API backend is currently active
    And the current API URL should be displayed
