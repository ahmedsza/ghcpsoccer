Feature: Dad Joke Integration
  As a user of the soccer management application
  I want to see a dad joke displayed on the page
  So that I can enjoy some humor while managing teams

  Background:
    Given the application is loaded
    And the dad joke API is accessible

  # Basic Joke Display
  Scenario: Dad joke is displayed on page load
    When the application loads
    Then I should see a dad joke section
    And a dad joke should be displayed
    And the joke should be visible to all users

  Scenario: Initial loading message
    Given the application is just starting to load
    When the joke is being fetched
    Then I should see "Loading joke of the day..." message
    And the message should be replaced once the joke loads

  # Joke API Integration
  Scenario: Fetch joke from external API successfully
    Given the dad joke API is available
    When the application requests a joke
    Then a joke should be fetched from "https://icanhazdadjoke.com/"
    And the joke should be displayed in the joke section

  Scenario: Display joke text clearly
    Given a joke has been fetched
    When I view the joke section
    Then the joke text should be clearly readable
    And the joke should be formatted properly

  # Caching Behavior
  Scenario: Joke is cached for 30 seconds
    Given a joke has been fetched and cached
    When less than 30 seconds have passed
    And the application requests a joke again
    Then the cached joke should be returned
    And no new API call should be made

  Scenario: Cached joke expires after 30 seconds
    Given a joke has been cached
    When 30 seconds have passed
    And the application requests a joke
    Then a new joke should be fetched from the API
    And the cache should be updated

  Scenario: Cache timestamp is updated on new fetch
    Given a joke is fetched at time T
    When the cache expires and a new joke is fetched at time T+30
    Then the cache timestamp should be updated to T+30
    And the new joke should be cached

  # Fallback Scenarios
  Scenario: Use fallback joke when API is unavailable
    Given the dad joke API is not responding
    When the application attempts to fetch a joke
    Then a fallback soccer-themed joke should be displayed
    And the joke should be one of the predefined fallbacks

  Scenario: Handle API timeout gracefully
    Given the dad joke API request times out
    When the timeout occurs
    Then a fallback joke should be displayed
    And the error should not be shown to the user

  Scenario: Handle API error response
    Given the dad joke API returns a non-200 status code
    When the application processes the response
    Then a fallback joke should be displayed
    And the application should continue to function normally

  Scenario Outline: Display various fallback jokes
    Given the API call fails
    When a fallback joke is needed
    Then one of the following jokes may be displayed:
      | joke                                                                     |
      | Why did the soccer player bring string to the game? To tie the score!   |
      | Why don't soccer players ever get cold? Because they have lots of fans!  |
      | What do you call a sleeping bull on a soccer field? A bulldozer!        |

  # API Request Configuration
  Scenario: API request includes correct headers
    When the application makes a joke API request
    Then the request should include Accept header "application/json"
    And the API should return JSON formatted data

  Scenario: API request has timeout protection
    When the application makes a joke API request
    Then the request should have a 5-second timeout
    And if timeout occurs, fallback should be used

  # Joke Display Format
  Scenario: Joke section has proper styling
    When I view the joke section
    Then the joke should be in a dedicated section
    And the section should have the class "joke-section"
    And the joke text should have the class "dad-joke"

  Scenario: Joke is displayed prominently
    When the page loads
    Then the joke section should be visible
    And it should be positioned appropriately in the layout
    And it should not interfere with main functionality

  # Multiple Page Loads
  Scenario: Fresh joke on page reload after cache expiry
    Given I loaded the page and saw a joke
    When I wait for 30 seconds
    And I reload the page
    Then a potentially different joke should be displayed
    And it should be fetched fresh from the API

  Scenario: Same joke displayed on quick reload
    Given I just loaded the page with a joke
    When I immediately reload the page
    Then the same joke should be displayed
    And it should come from the cache

  # Edge Cases
  Scenario: Handle empty joke response
    Given the API returns an empty joke
    When the application processes the response
    Then a fallback joke should be displayed
    And the application should not crash

  Scenario: Handle malformed JSON response
    Given the dad joke API returns malformed JSON
    When the application tries to parse the response
    Then the error should be caught
    And a fallback joke should be displayed

  Scenario: Joke with special characters
    Given the API returns a joke with special characters or emojis
    When the joke is displayed
    Then all characters should render correctly
    And the joke should be readable

  # Cache Indicator
  Scenario: Cache status is tracked in API response
    Given the joke API endpoint returns cache information
    When I check the joke API response
    Then it should include a "cached" field
    And the field should indicate if the joke is from cache

  Scenario: Fresh joke has cached=false
    Given no joke is cached
    When a new joke is fetched
    Then the response should have "cached": false
    And the joke should be stored in cache

  Scenario: Cached joke has cached=true
    Given a joke is in cache
    When the joke endpoint is called within 30 seconds
    Then the response should have "cached": true
    And no external API call should be made

  # Accessibility
  @accessibility
  Scenario: Joke is accessible to screen readers
    Given I am using a screen reader
    When the page loads
    Then the joke section should be announced
    And the joke text should be readable by screen readers
    And it should have appropriate ARIA attributes

  @accessibility
  Scenario: Joke text has sufficient contrast
    When I view the joke
    Then the text should have sufficient color contrast
    And it should be readable for users with visual impairments

  # Performance
  Scenario: Joke loading doesn't block page render
    When the application loads
    Then the page should render immediately
    And the joke should load asynchronously
    And other functionality should not wait for the joke

  Scenario: Failed joke fetch doesn't delay page load
    Given the joke API is slow or unavailable
    When the page loads
    Then the page should load completely
    And the joke section should show fallback quickly
    And no long delays should occur

  # Integration with Application
  Scenario: Joke section visible on all pages
    When I navigate to different sections
    Then the joke section should remain visible
    And the same joke should be displayed across sections

  Scenario: Joke persists during navigation
    Given I see a joke on the dashboard
    When I navigate to teams or players
    Then the same joke should still be displayed
    And no new fetch should occur (if within cache period)

  # Server-side Caching
  Scenario: Backend implements cache correctly
    Given the backend joke endpoint exists at "/api/dad-joke"
    When the endpoint is called multiple times within 30 seconds
    Then only the first call should hit the external API
    And subsequent calls should return the cached joke

  Scenario: Backend cache structure
    When a joke is cached on the backend
    Then the cache should store the joke text
    And the cache should store the timestamp
    And the cache should validate timestamp before returning
