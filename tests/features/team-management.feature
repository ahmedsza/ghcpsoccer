Feature: Team Management
  As a soccer team manager
  I want to create, view, update, and delete teams
  So that I can manage team information effectively

  Background:
    Given the application is loaded
    And I am on the teams section
    And the API is configured and connected

  # Happy Path Scenarios
  Scenario: Create a new team with all required fields
    When I click the "New Team" button
    And I fill in the team form with:
      | field              | value                  |
      | Team Name          | Manchester United      |
      | Established Year   | 1878                   |
      | Home Stadium       | Old Trafford           |
      | Club Colors        | Red, White             |
      | Country            | England                |
      | League             | Premier League         |
      | Current Position   | 3                      |
      | Team Value         | 500000000              |
      | Description        | Historic football club |
      | Wikipedia Link     | https://en.wikipedia.org/wiki/Manchester_United_F.C. |
    And I submit the team form
    Then a new team should be created successfully
    And I should see "Manchester United" in the teams list
    And the team modal should close

  Scenario: View list of all teams
    Given the database contains the following teams:
      | name           | country | league          |
      | Real Madrid    | Spain   | La Liga         |
      | Bayern Munich  | Germany | Bundesliga      |
      | Liverpool      | England | Premier League  |
    When I navigate to the teams section
    Then I should see 3 teams in the list
    And each team should display name, country, league, and value

  Scenario: Edit an existing team
    Given a team "Chelsea FC" exists with value "400000000"
    When I click the edit button for "Chelsea FC"
    And I change the team value to "450000000"
    And I submit the team form
    Then the team "Chelsea FC" should have value "450000000"
    And the updated information should be reflected in the teams list

  Scenario: Delete a team
    Given a team "Test Team" exists
    When I click the delete button for "Test Team"
    And I confirm the deletion
    Then the team "Test Team" should be removed from the list
    And the team should no longer exist in the database

  # Search and Filter Scenarios
  Scenario: Search teams by name
    Given the database contains teams with names:
      | name              |
      | Arsenal           |
      | Barcelona         |
      | Paris Saint-Germain |
    When I enter "Barcelona" in the team search box
    Then I should see only 1 team
    And I should see "Barcelona" in the results

  Scenario: Filter teams by country
    Given the database contains teams from different countries:
      | name         | country |
      | AC Milan     | Italy   |
      | Inter Milan  | Italy   |
      | Juventus     | Italy   |
      | Real Madrid  | Spain   |
    When I select "Italy" from the country filter
    Then I should see 3 teams
    And all displayed teams should be from "Italy"

  Scenario: Filter teams by league
    Given the database contains teams from different leagues:
      | name          | league         |
      | Liverpool     | Premier League |
      | Chelsea       | Premier League |
      | Real Madrid   | La Liga        |
    When I select "Premier League" from the league filter
    Then I should see 2 teams
    And all displayed teams should be from "Premier League"

  Scenario: Combine search and filters
    Given the database contains multiple teams
    When I enter "United" in the search box
    And I select "England" from the country filter
    And I select "Premier League" from the league filter
    Then I should see only teams matching all criteria

  # Edge Cases
  Scenario: Create team with minimum required fields
    When I click the "New Team" button
    And I fill in only the required fields:
      | field            | value          |
      | Team Name        | Minimal FC     |
      | Established Year | 2000           |
      | Home Stadium     | Stadium        |
      | Club Colors      | Blue           |
      | Country          | USA            |
      | League           | MLS            |
      | Current Position | 1              |
      | Team Value       | 10000000       |
    And I submit the team form
    Then a new team should be created successfully

  Scenario: View teams when database is empty
    Given the database contains no teams
    When I navigate to the teams section
    Then I should see "No teams found" message
    And the teams table should be empty

  Scenario: Search with no matching results
    Given the database contains teams
    When I enter "NonExistentTeam123" in the search box
    Then I should see "No teams found" message

  # Error Scenarios
  Scenario: Attempt to create team without required fields
    When I click the "New Team" button
    And I leave the team name field empty
    And I attempt to submit the form
    Then I should see a validation error
    And the form should not be submitted

  Scenario: Create team with invalid year
    When I click the "New Team" button
    And I enter "999" as the established year
    And I attempt to submit the form
    Then I should see an appropriate validation message

  Scenario: Create team with negative value
    When I click the "New Team" button
    And I fill in all required fields
    And I enter "-1000000" as the team value
    And I attempt to submit the form
    Then I should see a validation error for team value

  Scenario: Handle API connection failure when loading teams
    Given the API is not available
    When I navigate to the teams section
    Then I should see an error message
    And the teams list should indicate a loading failure

  Scenario: Handle API failure when creating team
    Given the API will return an error
    When I attempt to create a new team
    Then I should see an error notification
    And the team should not be added to the list

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate team form with keyboard
    When I click the "New Team" button
    And I use Tab to navigate through form fields
    Then I should be able to reach all form inputs
    And I should be able to submit using Enter key
    And I should be able to cancel using Escape key

  @accessibility
  Scenario: Screen reader announces team information
    Given teams exist in the database
    When I navigate to the teams section using a screen reader
    Then each team's information should be announced
    And action buttons should have descriptive labels
    And the table should have proper ARIA attributes

  # Boundary Tests
  Scenario: Create team with maximum allowed name length
    When I create a team with a 100-character name
    Then the team should be created successfully

  Scenario Outline: Create teams with various establishment years
    When I create a team established in <year>
    Then the team should be created successfully
    
    Examples:
      | year |
      | 1850 |
      | 1900 |
      | 2000 |
      | 2024 |

  Scenario: Display teams with very large value
    Given a team exists with value "999999999999"
    When I view the teams list
    Then the value should be displayed with proper formatting
    And the value should be readable with comma separators
